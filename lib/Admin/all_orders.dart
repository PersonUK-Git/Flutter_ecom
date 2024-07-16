import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/services/database.dart';
import 'package:ecom/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  Stream? orderStream;
  bool isLoading = true;

  getOnTheLoad() async {
    orderStream = await DatabaseMethods().allOrders();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  Widget allOrders() {
    return StreamBuilder(
      stream: orderStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData || isLoading) {
          return Center(
            child: LoadingAnimationWidget.stretchedDots(
              color: Colors.blue,
              size: 200,
            ),
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];

              return Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      top: 10,
                      bottom: 10,
                    ),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          ds["Image"],
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name : " + ds["Name"],
                                style: AppStyle.semiBoldTextFieldStyle(),
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    "Email : " + ds["Email"],
                                    style: AppStyle.lightTextFieldStyle(),
                                  )),
                              Text("Product : " + ds["Product"], style: AppStyle.semiBoldTextFieldStyle(),),
                              Text("\$"+ds["Price"].toString(),
                        style: TextStyle(
                          color: Color(0xFFfd6f3e),
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        )),
                        SizedBox(height: 20,),
                        GestureDetector(
                          onTap: ()async{
                            await DatabaseMethods().updateStatus(ds.id);
                            setState(() {
                              
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xfffd6f3e),
                          
                            ),
                            child: Center(child: Text("Delivered", style: AppStyle.semiBoldTextFieldStyle(),)),
                          ),
                        )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new_outlined),
        ),
          title: Text("All Orders", style: AppStyle.boldTextFieldStyle()),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [Expanded(child: allOrders())],
          ),
        ));
  }
}
