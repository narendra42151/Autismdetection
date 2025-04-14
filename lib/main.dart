import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mlautismdetection/firebase_options.dart';
import 'package:mlautismdetection/provider/AutismDetectorProvider.dart';
import 'package:provider/provider.dart';

import 'Homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AutismDetectorProvider(),
      child: MaterialApp(
        title: 'Autism Detection App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
