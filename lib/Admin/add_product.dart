import 'dart:async';
import 'dart:io';

import 'package:ecom/services/database.dart';
import 'package:ecom/widget/support_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  Future<void> getImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
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
    try {
      if (selectedImage != null && nameController.text.isNotEmpty) {
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
            .child("blogImage")
            .child(addId);

        final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
        var downloadURL = await (await task).ref.getDownloadURL();
        Map<String, dynamic> addProduct = {
          "Name": nameController.text,
          "Image": downloadURL,
          "Price": priceController.text,
          "Description": detailController.text
        };

        await DatabaseMethods().addProduct(addProduct, value!).then((value) {
          setState(() {
            selectedImage = null;
            priceController.text = "";
            detailController.text = "";
            nameController.text = "";
            this.value = null;
          });
          Navigator.pop(context); // Hide loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "Product has been uploaded successfully",
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Please select an image and enter a product name",
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Hide loading indicator if there's an error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Failed to upload product: $e",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }
  }

  String? value;
  final List<String> categoryItems = [
    'Watch', 'Laptop', 'TV', 'Headphones', 'test',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Product",
          style: AppStyle.semiBoldTextFieldStyle(),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload the Product image",
                style: AppStyle.lightTextFieldStyle(),
              ),
              SizedBox(height: 20),
              selectedImage == null
                  ? GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Center(
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.camera_alt_outlined, size: 50),
                        ),
                      ),
                    )
                  : Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              Text(
                "Product Name",
                style: AppStyle.lightTextFieldStyle(),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Product Name",
                  ),
                  controller: nameController,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Product Rate",
                style: AppStyle.lightTextFieldStyle(),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Product Rate",
                  ),
                  controller: priceController,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Product Detail",
                style: AppStyle.lightTextFieldStyle(),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  maxLines: 6,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Product Detail",
                  ),
                  controller: detailController,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Product Category",
                style: AppStyle.lightTextFieldStyle(),
              ),
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: categoryItems.map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: AppStyle.semiBoldTextFieldStyle(),
                          ),
                        )).toList(),
                    onChanged: (value) => setState(() {
                      this.value = value;
                    }),
                    dropdownColor: Color(0xffececf8),
                    hint: Text("Select Category"),
                    iconSize: 36,
                    icon: Icon(
                      Icons.arrow_drop_down_outlined,
                      color: Colors.black,
                    ),
                    value: value,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    uploadItem();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Add Product",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
