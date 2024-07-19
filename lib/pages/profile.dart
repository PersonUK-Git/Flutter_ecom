import "dart:io";

import "package:ecom/services/shared_pref.dart";
import "package:ecom/widget/support_widget.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";
import "package:random_string/random_string.dart";

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? image, email, name;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  @override
  void initState() {
    getTheSharedPref();
    super.initState();
  }

  getTheSharedPref() async {
    image = await SharedPreferenceHelper().getUserImage();
    email = await SharedPreferenceHelper().getUserEmail();
    name = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  Future<void> getImage() async {
    try {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          selectedImage = File(pickedImage.path);
        });
        await uploadItem();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "No image selected",
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Failed to pick image: $e",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }
  }

  Future<void> uploadItem() async {
    if (selectedImage == null) return;

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: LoadingAnimationWidget.threeArchedCircle(
              color: Colors.blue,
              size: 200,
            ),
          );
        },
      );

      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("profileImages")
          .child(addId);

      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadURL = await (await task).ref.getDownloadURL();

      await SharedPreferenceHelper().saveUserImage(downloadURL);

      setState(() {
        image = downloadURL;
      });

      Navigator.pop(context); // Hide loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Image uploaded successfully",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Hide loading indicator if there's an error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Failed to upload image: $e",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login screen after successful logout
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Failed to log out: $e",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }
  }

  Future<void> deleteAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Delete user data from Firestore or Realtime Database if needed
        // await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();

        await user.delete();
        // Navigate to the login screen after account deletion
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Failed to delete account: $e",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        title: Text("Profile", style: AppStyle.boldTextFieldStyle()),
        centerTitle: true,
        backgroundColor: Color(0xfff2f2f2),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                getImage();
              },
              child: Center(
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: selectedImage != null
                      ? FileImage(selectedImage!)
                      : (image != null
                          ? NetworkImage(image!) as ImageProvider
                          : AssetImage("assets/default_profile.png")),
                  child: selectedImage == null && image == null
                      ? Icon(
                          Icons.person,
                          size: 75,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person_outlined, size: 40),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: AppStyle.lightTextFieldStyle(),
                            ),
                            Text(
                              name ?? "No name available",
                              style: AppStyle.semiBoldTextFieldStyle(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.mail_outline, size: 40),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email",
                              style: AppStyle.lightTextFieldStyle(),
                            ),
                            Text(
                              email ?? "No email available",
                              style: AppStyle.semiBoldTextFieldStyle(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    logout();
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.logout_outlined, size: 40),
                        SizedBox(width: 10),
                        Text(
                          "Log Out",
                          style: AppStyle.semiBoldTextFieldStyle(),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    deleteAccount();
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 40),
                        SizedBox(width: 10),
                        Text(
                          "Delete Account",
                          style: AppStyle.semiBoldTextFieldStyle().copyWith(color: Colors.red),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
