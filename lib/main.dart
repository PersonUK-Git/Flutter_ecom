import 'package:ecom/Admin/add_product.dart';
import 'package:ecom/Admin/admin_login.dart';
import 'package:ecom/pages/bottomnav.dart';
import 'package:ecom/pages/login.dart';
import 'package:ecom/pages/onboarding.dart';
import 'package:ecom/pages/product_detail.dart';
import 'package:ecom/pages/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AddProduct(),
    );
  }
}
