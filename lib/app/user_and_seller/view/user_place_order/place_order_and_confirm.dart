import 'dart:convert';
import 'package:ecommerce_int2/app/user_and_seller/model/buy_now/buy_now.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/main/main_page.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/order_sucess/order_success.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/payment/PhonePayPayment.dart';
import 'package:ecommerce_int2/common/common_enum.dart';
import 'package:ecommerce_int2/constants/apiEndPoints.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/products.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final Products product;
  final String email;
  OrderConfirmationScreen({required this.email, required this.product});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _flatNumberController = TextEditingController();
  final _postalCodeController = TextEditingController();
  ChoosePaymentMethod? _choosePaymentMethod = ChoosePaymentMethod.Online;

  @override
  void initState() {
    super.initState();
    _retrieveUserAddress();
  }

  Future<void> _retrieveUserAddress() async {
    try {
      var responseBody = jsonDecode(
          '{"success": true, "data": {"flat_number": "123", "street": "Main St", "postal_code": "12345"}}');
      if (responseBody['success']) {
        var data = responseBody['data'];
        _flatNumberController.text = data['flat_number'] ?? '';
        _streetController.text = data['street'] ?? '';
        _postalCodeController.text = data['postal_code'] ?? '';
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No address found for this email")),
        );
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: ${e.toString()}")),
      );
    }
  }

  void _submitForm() async {
    try {
      var res = await http.post(
          Uri.parse(ApiEndPoints.baseURL + ApiEndPoints.store_user_address),
          body: {
            "email": widget.email,
            "flat_number": _flatNumberController.text,
            "street": _streetController.text,
            "postal_code": _postalCodeController.text
          });
      if (res.statusCode != 200) {
        Dialog(
          child: Text("something got wrong"),
        );
      } else {
        print("\n\n\n\ Done !!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n\n\n");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<BuyNow>> getBuyNowData() async {
    List<BuyNow> buyNowDataList = [];
    try {
      var res = await http.post(
          Uri.parse(ApiEndPoints.baseURL + ApiEndPoints.fetch_buy_now_data));
      if (res.statusCode == 200) {
        var responseBodyOfBuyNowData = jsonDecode(res.body);
        if (responseBodyOfBuyNowData['success'] == true) {
          (responseBodyOfBuyNowData['buyNowRecordData'] as List)
              .forEach((eachRecord) {
            if (eachRecord['email'] == widget.email) {
              buyNowDataList.add(BuyNow.fromJson(eachRecord));
            }
          });
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text("Please check your internet connection."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }
    return buyNowDataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Your Order"),
        backgroundColor: Colors.yellow[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: getBuyNowData(),
          builder: (context, AsyncSnapshot<List<BuyNow>> dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (dataSnapShot.hasError) {
              return Center(child: Text("An error occurred"));
            }
            if (dataSnapShot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      // height: MediaQuery.of(context).size.height * 0.35, // Increased height
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Image.asset(
                                widget.product.imgurl,
                                height: 200,
                                width: 200,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 110,
                                    child: Text(
                                      "Price: ${widget.product.price}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    Text("Delivery Address",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _flatNumberController,
                            validator: (value) => value!.isEmpty
                                ? "Please fill this field"
                                : null,
                            decoration: InputDecoration(
                              labelText: "Flat Number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color:
                                        Colors.black), // Default border color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.yellow[
                                        800]!), // Yellow border when active
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors
                                        .black), // Black border when inactive
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _streetController,
                            validator: (value) => value!.isEmpty
                                ? "Please fill this field"
                                : null,
                            decoration: InputDecoration(
                              labelText: "Street",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color:
                                        Colors.black), // Default border color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.yellow[
                                        800]!), // Yellow border when active
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors
                                        .black), // Black border when inactive
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _postalCodeController,
                            validator: (value) => value!.isEmpty
                                ? "Please fill this field"
                                : null,
                            decoration: InputDecoration(
                              labelText: "Postal Code",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color:
                                        Colors.black), // Default border color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.yellow[
                                        800]!), // Yellow border when active
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors
                                        .black), // Black border when inactive
                              ),
                            ),
                          ),
                          SizedBox(height: 32),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Choose Payment Method",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RadioListTile<ChoosePaymentMethod>(
                                    contentPadding: EdgeInsets.zero,
                                    value: ChoosePaymentMethod.Online,
                                    groupValue: _choosePaymentMethod,
                                    onChanged: (ChoosePaymentMethod? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          _choosePaymentMethod = newValue;
                                        });
                                      }
                                    },
                                    title: Text('Online'),
                                  ),
                                  RadioListTile<ChoosePaymentMethod>(
                                    contentPadding: EdgeInsets.zero,
                                    value: ChoosePaymentMethod.Offline,
                                    groupValue: _choosePaymentMethod,
                                    onChanged: (ChoosePaymentMethod? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          _choosePaymentMethod = newValue;
                                        });
                                      }
                                    },
                                    title: Text('Cash On Delivery'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _submitForm();
                                  if (_choosePaymentMethod ==
                                      ChoosePaymentMethod.Offline) {
                                    navigateToSuccessScreen();
                                  } else {
                                    // PhonepePg(
                                    //   email: widget.email,
                                    //   context: context,
                                    //   amount: int.parse(widget.product.price),
                                    //   product: widget.product,
                                    //   address:
                                    //       "${_flatNumberController.text},${_streetController.text}\n${_postalCodeController.text}",
                                    // ).init();
                                  }
                                  print(' kidharrrrr beyyyy ???');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 25),
                                backgroundColor: Colors.yellow[800],
                              ),
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // adding for checkout weather user select online or pay on delivery method
                  ],
                ),
              );
            } else {
              return Center(child: Text("No Data Found"));
            }
          },
        ),
      ),
    );
  }

  void navigateToSuccessScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OrderSuccessScreen(
          email: widget.email,
          product: widget.product,
          address:
              "${_flatNumberController.text},${_streetController.text}\n${_postalCodeController.text}",
          paymentMode: _choosePaymentMethod == ChoosePaymentMethod.Offline ? "1":"0",
        ),
      ),
    );
  }
}
