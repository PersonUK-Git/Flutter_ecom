import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PaymentPage extends StatefulWidget {
  final String price;
  final String name;

  const PaymentPage({super.key, required this.price, required this.name});

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

  @override
  void initState() {
    super.initState();
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
  void showSuccessDialog() {
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
      Navigator.pop(context); // Go back to the previous screen
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
      body: Column(
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
                color: Colors.blue.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "Pay Now ₹${widget.price}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFececf8),
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
