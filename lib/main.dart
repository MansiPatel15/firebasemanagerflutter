import 'package:firebase_core/firebase_core.dart';
import 'package:firebasemanager/AddEmployee.dart';
import 'package:firebasemanager/AddStudent.dart';
import 'package:firebasemanager/FireBaseManager.dart';
import 'package:flutter/material.dart';

import 'AddProduct.dart';
import 'CameraGallery.dart';
import 'FirebaseAuthentication.dart';
import 'GoogleMapExample.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FireBaseManager(),
    );
  }
}

