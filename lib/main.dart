import 'package:ecom/Admin/add_product.dart';
import 'package:ecom/Admin/admin_login.dart';
import 'package:ecom/pages/bottomnav.dart';
import 'package:ecom/pages/login.dart';
import 'package:ecom/pages/onboarding.dart';
import 'package:ecom/pages/product_detail.dart';
import 'package:ecom/pages/sign_up.dart';
import 'package:ecom/services/constant.dart';
import 'package:ecom/services/shared_pref.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishablekey;
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _checkSignedInStatus();
  }

  Future<void> _checkSignedInStatus() async {
    String? userName = await SharedPreferenceHelper().getUserName();
    if (userName != null) {
      setState(() {
        _isSignedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _isSignedIn ? Bottomnav() : SignUp(),
    );
  }
}
