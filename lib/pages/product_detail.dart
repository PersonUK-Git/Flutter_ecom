import 'package:ecom/pages/bottomnav.dart';
import 'package:ecom/pages/home.dart';
import 'package:ecom/services/database.dart';
import 'package:ecom/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
  late Future<void> _sharedPrefLoader;

  String? Name, Mail, userImage;

  Future<void> getTheSharedPref() async {
    Name = await SharedPreferenceHelper().getUserName();
    Mail = await SharedPreferenceHelper().getUserEmail();
    userImage = await SharedPreferenceHelper().getUserImage();
  }

  Future<void> _loadImage() async {
    // Simulate a delay to load the image
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  void initState() {
    super.initState();
    _imageLoader = _loadImage();
    _sharedPrefLoader = getTheSharedPref();
  }

  // Function to show PaymentPage as a bottom sheet
  void showPaymentPage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentSheet(
        price: widget.price,
        name: widget.name,
        productImage: widget.image, // Pass the product image here
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfef5f1),
      body: FutureBuilder<void>(
        future: Future.wait([_imageLoader, _sharedPrefLoader]),
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
                    child: SingleChildScrollView(
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
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
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
                            
                            GestureDetector(
                              onTap: () {
                                showPaymentPage(context);
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
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class PaymentSheet extends StatelessWidget {
  final String price;
  final String name;
  final String productImage;

  const PaymentSheet({Key? key, required this.price, required this.name, required this.productImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFFececf8),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 6,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Expanded(
                child: PaymentPage(price: price, name: name, productImage: productImage), // Pass the product image here
              ),
            ],
          ),
        );
      },
    );
  }
}

class PaymentPage extends StatefulWidget {
  final String price;
  final String name;
  final String productImage;

  const PaymentPage({super.key, required this.price, required this.name, required this.productImage});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = "";
  String expiryDate = "";
  String cardHolderName = "";
  String cvvCode = "";
  bool isCvvFocused = false;

  bool showBackView = false;
  String? Name, Mail, userImage;

  @override
  void initState() {
    super.initState();
    getTheSharedPref();
  }

  Future<void> getTheSharedPref() async {
    Name = await SharedPreferenceHelper().getUserName();
    Mail = await SharedPreferenceHelper().getUserEmail();
    userImage = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  // Function to show loading screen
  void showLoadingScreen() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.orange,
          size: 100,
        ),
      ),
    );

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context); // Dismiss the loading screen
      showSuccessDialog(); // Show success dialog
    });
  }

  // Function to show success dialog
  void showSuccessDialog() async{
    Map<String, dynamic> orderInfoMap = {
      "Product": widget.name,
      "Price": widget.price,
      "Name": Name,
      "Email": Mail,
      "Image": userImage,
      "ProductImage": widget.productImage, // Include the product image
      "Status" : "On the Way",
    };

    await DatabaseMethods().orderDetails(orderInfoMap);
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 10),
                Text("Payment Successful"),
              ],
            ),
          ],
        ),
      ),
    );

    Future.delayed(Duration(seconds: 5), () {
      Navigator.pop(context); // Dismiss the success dialog
      Navigator.push(context, MaterialPageRoute(builder: (context) => Bottomnav())); // Go back to the previous screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFececf8),
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFFececf8),
      ),
      body: 
         Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.arrow_back_ios_new_outlined),
                      SizedBox(width: 5),
                      Text("Back"),
                    ],
                  ),
                ),
              ),
            ),
            // Credit card
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (p0) {},
            ),
            // Credit card form
            CreditCardForm(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              onCreditCardModelChange: (data) {
                setState(() {
                  cardNumber = data.cardNumber;
                  expiryDate = data.expiryDate;
                  cardHolderName = data.cardHolderName;
                  cvvCode = data.cvvCode;
                });
              },
              formKey: formKey,
            ),
            const Spacer(),
            GestureDetector(
              onTap: showLoadingScreen, // Call showLoadingScreen on tap
              child: Container(
                padding: EdgeInsets.all(25),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Pay Now ₹${widget.price}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      );
    
  }
}
