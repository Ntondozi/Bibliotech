import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kshieldauth/pages/home.dart';
import 'controllers/book_controller.dart';
import 'controllers/user_controller.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppInitializer());
}

class AppInitializer extends StatelessWidget {
  final Future<FirebaseApp> _initFirebase = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: _initFirebase,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Firebase initialisé, instanciation des controllers
          Get.put(BookController());
          Get.put(UserController());

          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Bibliothèque',
            theme: ThemeData(primarySwatch: Colors.blue),
            home: HomePage(),
          );
        } else if (snapshot.hasError) {
          // Affichage d'une erreur si Firebase échoue
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  'Erreur d’initialisation Firebase:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        } else {
          // Indicateur de chargement pendant l'initialisation
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}
