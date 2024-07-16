import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods{
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async{
    return await FirebaseFirestore.instance.collection("users").doc(id).set(userInfoMap);
  }

  Future addProduct(Map<String, dynamic> userInfoMap, String categoryName) async{
    return await FirebaseFirestore.instance.collection(categoryName).add(userInfoMap);
  }

  Future updateStatus(String id) async{
    return await FirebaseFirestore.instance.collection("Orders").doc(id).update({"Status": "Delivered"});
  }
  Future<Stream<QuerySnapshot>> getProducts(String category) async{
    return await FirebaseFirestore.instance.collection(category).snapshots();
    
  } 

  Future<Stream<QuerySnapshot>> allOrders() async{
  return await FirebaseFirestore.instance.collection("Orders").where("Status", isEqualTo: "On the way").snapshots();
    
  } 

  Future orderDetails(Map<String, dynamic> orderInfoMap) async{
    return await FirebaseFirestore.instance.collection("Orders").add(orderInfoMap);
  }
  Future<Stream<QuerySnapshot>> getOrders(String email) async{
    return await FirebaseFirestore.instance.collection("Orders").where("Email", isEqualTo: email).snapshots();

  } 
}