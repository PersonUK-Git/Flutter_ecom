import 'package:ecom/pages/animated_text.dart';
import 'package:ecom/pages/bottomnav.dart';
import 'package:ecom/pages/home.dart';
import 'package:ecom/pages/login.dart';
import 'package:ecom/services/database.dart';
import 'package:ecom/widget/support_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? name, email, password;
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  registration() async{
    if(password!=null && name!=null && email!=null){
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.redAccent, content: Text("Registerd Successfully", style: TextStyle(fontSize: 20),), ),
        );
        String Id = randomAlphaNumeric(10);
        Map<String, dynamic> userInfoMap = {
          "Name" : nameController.text,
          "Email" : emailController.text,
          "Id" : Id,
        };

        await DatabaseMethods().addUserDetails(userInfoMap, Id);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Bottomnav()));
      } on FirebaseException catch (e) {
        if(e.code =='weak-password'){
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.redAccent, content: Text("Password provided is too weak", style: TextStyle(fontSize: 20),), ),
        );
      }

      else if(e.code =='email-already-in-use'){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.redAccent, content: Text("Account Already exists", style: TextStyle(fontSize: 20),), ),
        );
      }
    }
  }
  }

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
                    text: "Sign Up",
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
                const SizedBox(height: 70),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: AppStyle.boldTextFieldStyle().copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF4F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Name",
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
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
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Email",
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
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
                        child: TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Password",
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Add your sign-up logic here
                        setState(() {
                          name = nameController.text;
                          email = emailController.text;
                          password = passwordController.text;
                          
                        });
                      }

                      registration();
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
                      "SIGN UP",
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Colors.blue,
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
