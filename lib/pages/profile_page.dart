// lib/pages/profile_page.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ifta_mobile/services/api_service.dart';
import 'package:ifta_mobile/services/session_manager.dart';
import 'package:ifta_mobile/models/UserData.dart';
import 'package:share_plus/share_plus.dart';// assumes User.fromMatchJson is defined here

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';
  final Animal animal;

  const ProfilePage({Key? key, required this.animal}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User> _futureUser;


  @override
  void initState() {
    super.initState();
    _futureUser = _loadUserData();
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }


  Widget _buildAnimalCard() {
    final a = widget.animal; // hier holst du dir das gewählte Tier
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tierdaten', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            _buildRow('Tiername',        a.name),
            _buildRow('Chip-Nr.',        a.transponder),
            _buildRow('Tierart',         a.species),
            _buildRow('Rasse',           a.breed),
            _buildRow('Geschlecht',      a.gender),
            _buildRow('Farbe',           a.color),
            _buildRow('Letzte Änderung', a.lastChanged),
          ],
        ),
      ),
    );
  }



  Future<User> _loadUserData() async {
    final sesid = await SessionManager.instance.storedSesId;
    if (sesid == null) {
      // kein sesId → Login erzwingen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return Future.error('Keine Session gefunden');
    }

    // adrId aus Prefs oder aus API nachladen
    var adrId = await SessionManager.instance.storedAdrId;
    if (adrId == null) {
      adrId = await ApiService.fetchAdrId(sesid: sesid);
      await SessionManager.instance.saveAdrId(adrId);
    }

    debugPrint('🛠️ Loading profile with sesid=$sesid   adrId=$adrId');

    // Profil‐Daten einholen
    final raw = await ApiService.fetchCustomerData(
      sesid: sesid,
      adrId: adrId,
    );
    debugPrint('🛠️ Raw profile JSON: $raw');

    final matches = raw['IFTA_MATCH'] as List<dynamic>? ?? [];
    if (matches.isEmpty) {
      throw Exception('Keine Profildaten gefunden für adrId $adrId');
    }

    final firstMatch = matches.first as Map<String, dynamic>;
    return User.fromMatchJson(firstMatch);
  }

  void _shareProfile(User user) {
    final sb = StringBuffer()
    // Header
      ..writeln('IFTA – Profil & Tierdaten')
      ..writeln('—————————————\n')

    // Owner-Daten
      ..writeln('Tierhalter ID       : ${user.adrId}')
      ..writeln('Name, Vorname       : ${user.name}')
      ..writeln('E-Mail              : ${user.email}')
      ..writeln('Telefon Festnetz    : ${user.telefonPriv}')
      ..writeln('Telefon Geschäftlich: ${user.telefonGes}')
      ..writeln('Telefon Mobil       : ${user.telefonMobil}')
      ..writeln('Fax                 : ${user.fax}')
      //..writeln('Benutzername        : ${user.username}')
      ..writeln('Straße              : ${user.street}')
      ..writeln('PLZ / Ort           : ${user.zip} ${user.city}')
      ..writeln('Land                : ${user.country}')

    // Tierdaten
      ..writeln('\nTierdaten:')
      ..writeln('- Tiername        : ${widget.animal.name}')
      ..writeln('- Chip-Nr.        : ${widget.animal.transponder}')
      ..writeln('- Tierart         : ${widget.animal.species}')
      ..writeln('- Rasse           : ${widget.animal.breed}')
      ..writeln('- Farbe           : ${widget.animal.color}')
      ..writeln('- Geschlecht      : ${widget.animal.gender}')
      ..writeln('- Letzte Änderung : ${widget.animal.lastChanged}');

    Share.share(
      sb.toString().trim(),
      subject: 'Mein IFTA-Profil & Tierdaten',
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mein Profil'),
        actions: [

        ],
      ),
      body: FutureBuilder<User>(
        future: _futureUser,
        builder: (c, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Fehler: ${snap.error}'));
          }
          final user = snap.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text('ifta Mobile',
                            style: Theme.of(context).textTheme.headlineSmall),
                        const Text('netzland'),
                        const Divider(height: 24),
                        const Text(
                            'Nördliche Ringstrasse 10, 91126 Schwabach, Deutschland'),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('T: 09122 88 519 88'),
                            SizedBox(width: 24),
                            Text('F: 09122 88 519 89'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('info@tierregistrierung.de'),
                        const SizedBox(height: 12),
                        const Text(
                          ' World wide free emergency number: \n 00800 4382 0000',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [// Title & Description
                        Text(
                          'Tierausweis und Registerbestätigung',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Die IFTA-Tierregistrierung bestätigt dem unten aufgeführten '
                              'Tierbesitzer die Registrierung seines Tieres in unserer Datenbank '
                              'zur Identifikation und Rückvermittlung.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                // Owner Data Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tierhalter ID: ${user.adrId}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        _buildRow('Name, Vorname', user.name),
                        _buildRow('Straße', user.street),
                        _buildRow('PLZ / Ort', '${user.zip} ${user.city}'),
                        _buildRow('Land', user.country),
                        _buildRow('E-Mail', user.email),
                        _buildRow('Telefon Festnetz', user.telefonPriv),
                        _buildRow('Telefon Geschäftlich', user.telefonGes),
                        _buildRow('Telefon Mobil', user.telefonMobil),
                        _buildRow('Fax', user.fax),
                        _buildRow('Letzte Änderung', user.lastChanged),
                        _buildRow('Registrierungs-Kennung (ICN)', user.icn),
                      ],
                    ),
                  ),
                ),

                // Animal Data Card
                _buildAnimalCard(),

                // Signature & Footer
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Mit freundlichen Grüßen\nIhre Ifta Internationale Zentrale für die Tierregistrierung',
                        style: TextStyle(fontStyle: FontStyle.normal),
                      ),
                      SizedBox(height: 24),
                      Divider(),
                      SizedBox(height: 8),
                      Text('Geschäftsführung: Frau Christine Beck'),
                      Text('HRB.: 25231   •   USt-IdNr.: DE261084534'),
                      SizedBox(height: 12),
                      Text('Bank Deutschland: Postbank'),
                      Text(
                          'IBAN: DE22 7601 0085 0900 0338 55   •   BIC: PBNKDEFF760'),
                      SizedBox(height: 6),
                      Text('Bank Österreich: Hypo Vorarlberg'),
                      Text('IBAN: AT88 5800 0104 6643 3018   •   BIC: HYPVAT2B'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // SHARE BUTTON
                ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text('Daten teilen'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  // ruft _shareProfile auf und übergibt den geladenen User
                  onPressed: user != null
                      ? () => _shareProfile(user)
                      : null,
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
