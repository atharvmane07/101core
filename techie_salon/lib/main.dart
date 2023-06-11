import "dart:ui";
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'welcome.dart'; 



Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: welcome(),
     
  ));
}

