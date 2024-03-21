import 'package:flutter/material.dart';
import 'package:mpesa_flutter_plugin/initializer.dart';
import 'package:mpesa_flutter_plugin/payment_enums.dart';

class MpesaDonations extends StatefulWidget {
  const MpesaDonations({super.key});

  @override
  State<MpesaDonations> createState() => _MpesaDonationsState();
}

class _MpesaDonationsState extends State<MpesaDonations> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize the MpesaFlutterPlugin
    
  }

  // Function to validate the phone number
  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (!value.startsWith('254') || value.length != 12) {
      return 'Invalid phone number';
    }
    return null;
  }

  // Function to validate the amount
  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    return null;
  }

  // Function that initiates transactions
  Future<void> startTransaction() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        double amount = double.parse(amountController.text);
        String phone = phoneController.text;

        dynamic transactionInitialization = await MpesaFlutterPlugin.initializeMpesaSTKPush(
          businessShortCode: '174379',
          transactionType: TransactionType.CustomerPayBillOnline,
          amount: amount,
          partyA: phone,
          partyB: '174379',
          callBackURL: Uri(),
          accountReference: "Twende Green Environment",
          phoneNumber: phone,
          baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
          passKey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919",
        );

        // Check if transactionInitialization is null
        if (transactionInitialization == null) {
          print("Transaction initialization failed.");
          return;
        }

        // Ongoing transaction logic here...

      } catch (e) {
        // Print the error to logs
        print("Exception Caught: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Image.asset("lib/images/mpesa.png",
                  height: 100,
                  ),
                ),
                // Phone Number Text Field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      labelText: 'Phone Number',
                    ),
                    keyboardType: TextInputType.phone,
                    maxLength: 12,
                    validator: validatePhoneNumber,
                  ),
                ),

                // Amount Text Field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: amountController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.attach_money),
                      labelText: 'Amount',
                    ),
                    keyboardType: TextInputType.number,
                    validator: validateAmount,
                  ),
                ),

                // Donate Button
                ElevatedButton(
                  onPressed: startTransaction,
                  child: const Text('Donate'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
