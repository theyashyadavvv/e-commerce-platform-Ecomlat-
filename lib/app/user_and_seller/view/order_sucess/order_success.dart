import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecommerce_int2/app/user_and_seller/model/Seller.dart';
import 'package:ecommerce_int2/app/user_and_seller/model/products.dart';
import 'package:ecommerce_int2/app/user_and_seller/model/seller_detail_by_id/SellerDetailsBySellerId.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/category/my_product/my_product_list.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/product/product_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/apiEndPoints.dart';
import '../profile_page_content/orderHistoryUser.dart';
import '../user_place_order/place_order_and_confirm.dart';

class OrderSuccessScreen extends StatefulWidget {
  static final String routeName = '/payment_success_screen';
  final Products product;
  final String email;
  final String? address;
  final String? paymentMode;

  OrderSuccessScreen(
      {required this.email,
      required this.product,
      this.address,
      this.paymentMode});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  DateTime now = new DateTime.now();
  late DateTime futureDate; //for future date
  List<SellerDetailsBySellerId> sellers = [];
  //buyNow
  _buyNow(BuildContext context) async {
    try {
      await fetchSeller(int.tryParse(widget.product.sellerId)!);
      var res = await http.post(
        Uri.parse(ApiEndPoints.baseURL + ApiEndPoints.insert_order),
        body: {
          "product_name": widget.product.name,
          "user": widget.email,
          "seller": sellers.first.email,
          "shop_name": sellers.first.shopName,
          "user_phone": '9999999999',
          "seller_phone": sellers.first.phone,
          "shop_lat": sellers.first.lat.toString(),
          "shop_lng": sellers.first.lng.toString(),
          "shop_address":sellers.first.address,
          "user_lat": "11.321",
          "user_lng": "99.325",
          "user_address": widget.address,
          "total_amount":  widget.product.price.toString(),
          "driver_id": "1",
          "driver_status": "0",
          "order_date": now.toString(),
          "delivery_date": futureDate.toString(),
          "product_image": widget.product.imgurl,
          "cash_on_delivery": widget.paymentMode,
        },
      );
      if (res.statusCode == 200) {
        var resBodyOfBuyNow = jsonDecode(res.body);
        if (resBodyOfBuyNow['success'] == true) {
          await _addPaymentHistory();
          //print('SUUUUUUUUUUUUUUUUUUUUUUUUUCESSSSSSSSSSSSSSS');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) {
              return ProductPage(widget.email, product: widget.product);
            }),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("Something went wrong"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchSeller(int userID) async {
    try {
      // Prepare the request body
      var body = {
        'userID': int.tryParse(widget.product.sellerId), // Convert int to string
      };
      var dio = Dio();
      String url = '${ApiEndPoints.baseURL}${ApiEndPoints.seller_detail_api_by_user_name}?sellerID=$userID';

      Response response = await dio.get(url);
      // // Make the POST request
      // var res = await http.get(
      //   Uri.parse(
      //       ApiEndPoints.baseURL + ApiEndPoints.seller_detail_api_by_user_name + '?sellerID=$userID'),
      //
      // );
      // Check if the response is successful
      if (response.statusCode == 200) {
        var data = jsonDecode(response.data); // Decode JSON response
        print(data);
        for (var item in data) {
          
          sellers.add(SellerDetailsBySellerId.fromJson(item));
        }

        print('Seller Data: $data');
      } else {
        print('Failed to fetch seller. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching seller: $e');
    }
  }

  // Add payment history
  _addPaymentHistory() async {
    try {
      var res = await http.post(
        Uri.parse(ApiEndPoints.baseURL + ApiEndPoints.payment_history_add),
        body: {
          "user_id": "1", // Use actual user_id
          "product_name":
              widget.product.name, // Product name from the product object
          "seller": "sar1@k.com",
          "shop_name": "SarShop",
          "order_date": now.toString(), // Date can be dynamic
        },
      );
      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);
        if (resBody['success'] == true) {
          print("Payment history added successfully.");
        } else {
          print("Failed to add payment history.");
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureDate = now.add(Duration(days: 10));
    // fetchSeller(int.tryParse(widget.product.sellerId)!);
    _buyNow(context);
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        elevation: 0.0,
        title: Text(
          'Payment Success',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle,
                color: Colors.yellow[700],
                size: 100,
              ),
              SizedBox(height: 16),
              Text(
                'Payment Successful!',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Thank you for your purchase. Your transaction has been completed successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  _buyNow(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.yellow[700],
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Go to Home',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
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
