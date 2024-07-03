import "package:curved_navigation_bar/curved_navigation_bar.dart";
import "package:ecom/pages/order.dart";
import "package:ecom/pages/profile.dart";
import "package:flutter/material.dart";

import "home.dart";

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  late List<Widget> pages;

  late Home HomePage;
  late Order order;
  late Profile profile;
  int currentTabIndex = 0;

  @override
  void initState() {
    HomePage = Home();
    order = Order();
    profile = Profile();

    pages = [HomePage, order, profile];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index){
          setState(() {
            
            currentTabIndex = index;
          });
        },
        items: [
        Icon(Icons.home_outlined,
        color: Colors.white,),
        Icon(Icons.shopping_bag_outlined,
          color: Colors.white,),
        Icon(Icons.person_outlined,
          color: Colors.white,),
      ],),

      body: pages[currentTabIndex],
    );
  }
}