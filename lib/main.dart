import 'package:absensi/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC5n0bNfAou1U2paelEk8HFIveD0k3-nV4",//dari current_id
      appId: "1:426796739250:android:94e210c84e9c9f890bb7ab" , //dari mobilesdk_app_id
      messagingSenderId: "426796739250",//dari project_number
      projectId: "absensi-f2b11",//dari project_id
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
          cardTheme:const CardTheme(
            surfaceTintColor: Colors.white,
          ),
    dialogTheme: const DialogTheme(
            surfaceTintColor: Colors.white,
      backgroundColor:Colors.white ,
          ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ),
    ),
        home: const HomeScreen(),
    );
  }
}
