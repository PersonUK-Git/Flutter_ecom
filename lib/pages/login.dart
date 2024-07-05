import 'package:ecom/pages/animated_text.dart';
import 'package:ecom/pages/sign_up.dart';
import 'package:ecom/widget/support_widget.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder Icon
                Center(
                  child: Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: AnimatedText(
                    text: "Sign In",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: Text(
                    "Please enter the details below to continue",
                    style: AppStyle.lightTextFieldStyle().copyWith(
                      color: Colors.white70,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 100),
                Text(
                  "Email",
                  style: AppStyle.boldTextFieldStyle().copyWith(color: Colors.white),
                ),
                const SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF4F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Email",
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Password",
                  style: AppStyle.boldTextFieldStyle().copyWith(color: Colors.white),
                ),
                const SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF4F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Password",
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Add your forgot password logic here
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your login logic here
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: Size(MediaQuery.of(context).size.width / 2, 50),
                    ),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Add your sign-up logic here
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
                    },
                    child: Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
