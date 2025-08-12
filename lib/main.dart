import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '/UeberIfta.dart';
import '/HistoryPage.dart';
import '/LoginPage.dart';

import 'FirstPage.dart';

void main() {
  // Stellt sicher, dass Flutter-Binding initialisiert ist,
  // bevor Plattform-Klassen genutzt werden
  WidgetsFlutterBinding.ensureInitialized();

  // Plattform-spezifische WebView-Implementierung registrieren
  if (Platform.isAndroid) {
    WebViewPlatform.instance = AndroidWebViewPlatform();
  } else if (Platform.isIOS || Platform.isMacOS) {
    WebViewPlatform.instance = WebKitWebViewPlatform();
  }
  // Für Windows/macOS könntest du webview_flutter_windows bzw. -macos importieren
  // und hier WebViewPlatform.instance = WindowsWebViewPlatform(); setzen.

  runApp(
    MaterialApp(
      title: 'IFTA Mobile',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        primarySwatch: Colors.green,
        fontFamily: 'VarelaRound',
      ),
      home: const FirstPage(),
      routes: {
        '/ueber':    (_) => const UeberPage(),
        '/history': (_) => const HistoryPage(),
        '/login':   (_) => const LoginPage(),
      },

    ),
  );
}
