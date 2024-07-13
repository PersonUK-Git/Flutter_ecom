import 'dart:convert';
import 'package:ecom/pages/billing.dart';
import 'package:ecom/services/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ecom/widget/support_widget.dart';
import 'package:http/http.dart' as http;

class ProductDetail extends StatefulWidget {
  final String image, name, price, detail;

  ProductDetail({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.detail,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late Future<void> _imageLoader;
  Map<String, dynamic>? paymentIntent;

  @override
  void initState() {
    super.initState();
    _imageLoader = _loadImage();
    Stripe.publishableKey = publishablekey; // Set your Stripe publishable key here
  }

  Future<void> _loadImage() async {
    // Simulate a delay to load the image
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfef5f1),
      body: FutureBuilder<void>(
        future: _imageLoader,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.orange,
                size: 200,
              ),
            );
          } else {
            return Container(
              padding: EdgeInsets.only(top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(
                          widget.image,
                          height: 400,
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 10,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              color: Color(0xFFfef5f1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(Icons.arrow_back_ios_new_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.name,
                                style: AppStyle.boldTextFieldStyle(),
                              ),
                              Text(
                                "\$${widget.price}",
                                style: TextStyle(
                                  color: Color(0xFFfd6f3e),
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Description",
                            style: AppStyle.semiBoldTextFieldStyle(),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.detail,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 90),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentPage(
                                    price: widget.price,
                                    name: widget.name,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: Color(0xFFfd6f3e),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                  "Buy Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Future<void> makePayment(String amount) async {
  //   try {
  //     paymentIntent = await createPaymentIntent(amount, "INR");
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: paymentIntent?['client_secret'],
  //         style: ThemeMode.dark,
  //         merchantDisplayName: "Prateek",
  //       ),
  //     ).then((value){});
  //     displayPaymentSheet();
  //   } catch (e, s) {
  //     print('Exception: $e $s');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Payment Initialization Failed: $e'),
  //       ),
  //     );
  //   }
  // }

  //  displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet().then((value) {
  //       showDialog(
  //         context: context,
  //         builder: (_) => AlertDialog(
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Row(
  //                 children: [
  //                   Icon(Icons.check_circle, color: Colors.green),
  //                   Text("Payment Successful"),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //       paymentIntent = null;
  //     }).onError((error, stackTrace) {
  //       print("Error is:--->$error $stackTrace");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Error presenting payment sheet: $error'),
  //         ),
  //       );
  //     });
  //   } on StripeException catch (e) {
  //     print("Error is:---> $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Payment Cancelled: $e'),
  //       ),
  //     );
  //   } catch (e) {
  //     print('$e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error: $e'),
  //       ),
  //     );
  //   }
  // }


  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount(amount),
  //       'currency': currency,
  //       'payment_method_types[]': 'card', // Corrected this line
  //     };

  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       headers: {
  //         'Authorization': 'Bearer $secretkey',
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //       },
  //       body: body,
  //     );

  //     if (response.statusCode == 200) {
  //       print("Payment Intent Created: ${response.body}");
  //       return jsonDecode(response.body);
  //     } else {
  //       print("Failed to create Payment Intent: ${response.body}");
  //       throw Exception("Failed to create Payment Intent");
  //     }
  //   } catch (e) {
  //     print('Error charging user: ${e.toString()}');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error charging user: ${e.toString()}'),
  //       ),
  //     );
  //     return null;
  //   }
  // }

  // calculateAmount(String amount) {
  //   final calculatedAmount = ((int.parse(amount)) * 100).toString();
  //   return calculatedAmount;
  // }
}
