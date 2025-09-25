// lib/pages/transponder_result_page.dart

import 'package:flutter/material.dart';
import '../models/transponder_match.dart';
import '../services/api_service.dart';
import '../services/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TransponderResultPage extends StatefulWidget {
  final String transponder;

  const TransponderResultPage({
    Key? key,
    required this.transponder,
  }) : super(key: key);

  @override
  _TransponderResultPageState createState() => _TransponderResultPageState();
}

class _TransponderResultPageState extends State<TransponderResultPage> {
  List<TransponderMatch> _results = [];
  bool _isLoading = true;
  bool _loggedIn = false;
  String? _error;

  Future<bool> sendFinderNumber(String finderPhone) async {
    const base = 'https://www.tierregistrierung.de/mob_app';
    final uri = Uri.parse('$base/jwwdblog.php').replace(
      queryParameters: {
        'tag': 'log',
        'phone': finderPhone.trim(),
      },
    );

    debugPrint('🔐 sendFinderNumber → $uri');
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    debugPrint('🔐 Log-Response: ${res.statusCode}, Body: ${res.body}');
    return res.statusCode == 200;
  }

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    try {
      // Prüfe Login-Status und setze lokalen Zustand
      final loggedIn = await SessionManager.instance.isLoggedIn;
      setState(() => _loggedIn = loggedIn);

      // 1) Session-ID holen: wenn eingeloggt -> storedSesId, sonst anonymous fallback
      String? sesid;
      if (loggedIn) {
        sesid = await SessionManager.instance.storedSesId;
      }
      sesid ??= await SessionManager.instance.getAnonymousSesId();

      debugPrint('🌐 Anfrage an Server:');
      debugPrint('→ Transponder: ${widget.transponder.trim()}');
      debugPrint('→ Session-ID: $sesid');

      final prefs = await SharedPreferences.getInstance();
      final finderPhone = prefs.getString('userPhone') ?? '';

      // 2) Log-Request VOR der API-Abfrage (nur wenn Telefonnummer vorhanden)
      if (finderPhone.isNotEmpty) {
        final ok = await sendFinderNumber(finderPhone);
        if (!ok) {
          debugPrint('❌ Log-Request fehlgeschlagen');
        }
      } else {
        debugPrint('ℹ️ Keine Finder-Telefonnummer gespeichert — Log übersprungen.');
      }

      // 3) Fetch via ApiService
      final matches = await ApiService.fetchTransponderData(
        transponder: widget.transponder.trim(),
        sesid: sesid,
      );

      setState(() {
        _results = matches;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Transponder ${widget.transponder}'),
        ),
        body: Center(child: Text('Fehler: $_error')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Transponder ${widget.transponder}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _results.isEmpty
            ? const Center(child: Text('Kein Eintrag gefunden.'))
            : ListView.separated(
          itemCount: _results.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, i) {
            final item = _results[i];
            return ListTile(
              title: Text(item.tiername ?? '–'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Telefonnummer immer anzeigen (oder —)
                  Text(
                    'Tel Nummer: ${item.telefonPriv.isNotEmpty ? item.telefonPriv : '–'}',
                  ),

                  // Rest der Felder nur für eingeloggte User
                  if (_loggedIn) ...[
                    Text('Halter: ${item.haltername.isNotEmpty ? item.haltername : '–'}'),
                    Text('Transponder: ${item.transponder ?? '–'}'),
                    Text('Adresse: ${item.strasse ?? '–'}'),
                    Text('Ort: ${item.ort ?? '–'}'),
                  ]else ...[
                    // Hinweis für anonyme User
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Weitere Details nach Login sichtbar.',
                      style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ],
              ),
              isThreeLine: true,
            );
          },
        ),
      ),
    );
  }
}