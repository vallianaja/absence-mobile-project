import 'package:absensi/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyC5n0bNfAou1U2paelEk8HFIveD0k3-nV4', //current_key
      appId: "1:426796739250:android:94e210c84e9c9f890bb7ab", //mobilesdk_app_id
      messagingSenderId: '426796739250',//project_number
      projectId: 'absensi-f2b11' //project_id
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cardTheme: CardTheme(
          surfaceTintColor: Colors.white,
        ),
        dialogTheme: DialogTheme(
          surfaceTintColor: Colors.white, backgroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent
        ),
        useMaterial3: true
      ),
      home: const HomeScreen(),
    );
  }
}