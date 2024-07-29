 import "dart:async";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:ecom/services/database.dart";
import "package:ecom/services/shared_pref.dart";
import "package:ecom/widget/support_widget.dart";
import "package:flutter/material.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  Stream? orderStream;
  String? email;
  bool isLoading = true;

  getSharedPref() async{
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {
      
    });
  }

  getOnTheLoad()async{
    await getSharedPref();
    orderStream = await DatabaseMethods().getOrders(email!);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState(){
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
                margin: EdgeInsets.only(bottom : 10),
                child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                
                child: Container(
                  
                  padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [Image.network(ds["ProductImage"], height: 120, width: 120, fit: BoxFit.cover,),
                    SizedBox(width: 30,), 
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ds["Product"], style: AppStyle.semiBoldTextFieldStyle(),),
                          Text("\$"+ds["Price"].toString(),
                          style: TextStyle(
                            color: Color(0xFFfd6f3e),
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          )),
                        
                          Text("Status : "+ds["Status"].toString(),
                          style: TextStyle(
                            color: Color(0xFFfd6f3e),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
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
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        title: Text("Current Orders", style: AppStyle.boldTextFieldStyle()),
        centerTitle: true,
        backgroundColor: Color(0xfff2f2f2),
      ),
      body : Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Expanded(child: allOrders())
          ],
        ),
      ) 
    );
  }
}
