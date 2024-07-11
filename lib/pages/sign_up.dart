import 'package:ecom/pages/animated_text.dart';
import 'package:ecom/pages/bottomnav.dart';
import 'package:ecom/pages/login.dart';
import 'package:ecom/services/database.dart';
import 'package:ecom/services/shared_pref.dart';
import 'package:ecom/widget/support_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:random_string/random_string.dart';
import 'dart:io';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? name, email, password;
  File? _image;
  final picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadImage(File imageFile) async {
    String fileName = randomAlphaNumeric(10) + '.jpg';
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('profilePictures/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  registration() async {
    if (password != null && name != null && email != null) {
      setState(() {
        isLoading = true;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );

        User user = FirebaseAuth.instance.currentUser!;
        await user.sendEmailVerification();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Verification email sent. Please check your email.",
              style: TextStyle(fontSize: 20),
            ),
          ),
        );

        setState(() {
          isLoading = false;
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Email Verification"),
            content: Text(
              "A verification email has been sent to your email address. Please verify your email before logging in.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: Text("OK"),
              ),
            ],
          ),
        );

        String Id = randomAlphaNumeric(10);

        String imageUrl;
        if (_image != null) {
          imageUrl = await uploadImage(_image!);
        } else {
          imageUrl =
              "https://firebasestorage.googleapis.com/v0/b/ecom-flutter-78d60.appspot.com/o/blogImage%2FIMG-20240710-WA0002.jpg?alt=media&token=644d3864-f826-4499-976b-a0f466545a35";
        }

        await SharedPreferenceHelper().saveUserEmail(emailController.text);
        await SharedPreferenceHelper().saveUserId(Id);
        await SharedPreferenceHelper().saveUserName(nameController.text);
        await SharedPreferenceHelper().saveUserImage(imageUrl);

        Map<String, dynamic> userInfoMap = {
          "Name": nameController.text,
          "Email": emailController.text,
          "Id": Id,
          "Image": imageUrl,
        };

        await DatabaseMethods().addUserDetails(userInfoMap, Id);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Password provided is too weak",
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        }
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.blue,
                size: 50,
              ),
            )
          : Container(
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
                      GestureDetector(
                        onTap: pickImage,
                        child: Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : AssetImage('assets/default_user.png') as ImageProvider,
                            child: _image == null
                                ? Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey,
                                  )
                                : Container(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                              setState(() {
                                name = nameController.text;
                                email = emailController.text;
                                password = passwordController.text;
                              });
                              registration();
                            }
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
