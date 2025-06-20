import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

/* ─── Firebase Options ─── */
import 'package:test3/firebase_options.dart';

/* ─── Ekranlar (Screens) ─── */
import 'package:test3/Screens/Login.dart' show LogIn;
import 'package:test3/Screens/Register.dart' show Register;
import 'package:test3/Screens/Galeri.dart' show GaleriScanUI;
import 'package:test3/Screens/Camera.dart' show CameraScanUI;
import 'package:test3/Screens/MyProfile.dart' show UserProfile;
import 'package:test3/Screens/Result.dart' show ResultScreen;
import 'package:test3/Screens/Home.dart' show HomePage;

/* ─── Hastalık verileri ─── */
import 'package:test3/Screens/disease_data.dart'
    show diseaseNames, diseaseSuggestions;

/* ─── SSL Sertifika Doğrulamasını Pas Geçmek İçin HttpOverrides ─── */
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    var client = super.createHttpClient(context);
    // Tüm sertifikalar geçerli sayılır (Geliştirme için)
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SSL doğrulamayı pas geçmek için override set et
  HttpOverrides.global = MyHttpOverrides();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cilt Uygulaması',
      theme: ThemeData(primarySwatch: Colors.blue),

      routes: {
        '/LogIn': (_) => const LogIn(),
        '/Register': (_) => const Register(),
        '/GaleriScanUI': (_) => const GaleriScanUI(),
        '/CameraScanUI': (_) => CameraScanUI(),
        '/UserProfile': (_) => const UserProfile(),
        '/HomePage': (_) => const HomePage(),
      },

      onGenerateRoute: (settings) {
        if (settings.name == '/ResultScreen') {
          final args = settings.arguments as Map<String, dynamic>?;
          final String? diseaseName = args?['diseaseName'] as String?;
          final bool hasDisease = diseaseName != "None";
          final List<String> suggestionsFromBackend =
              (args?['suggestions'] as List?)?.cast<String>() ?? <String>[];
          List<String> suggestions;
          if (suggestionsFromBackend.isNotEmpty) {
            suggestions = suggestionsFromBackend;
          } else {
            final index = diseaseNames.indexOf(diseaseName ?? '');
            suggestions = index >= 0 ? diseaseSuggestions[index] : <String>[];
          }
          return MaterialPageRoute(
            builder:
                (_) => ResultScreen(
                  hasDisease: hasDisease,
                  diseaseName: diseaseName,
                  suggestions: suggestions,
                ),
          );
        }
        return null;
      },

      home: const AuthGate(),
    );
  }
}

/*───────────────────────  Auth Gate  ───────────────────────*/
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomePage();
        }

        return const LogIn();
      },
    );
  }
}
