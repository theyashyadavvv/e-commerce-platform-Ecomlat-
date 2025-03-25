import 'dart:convert';
import 'dart:io';

import 'package:ecommerce_int2/app/user_and_seller/model/orderDetails.dart';
import 'package:ecommerce_int2/constants/apiEndPoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SellerAOrders extends StatefulWidget {
  const SellerAOrders({super.key});

  @override
  State<SellerAOrders> createState() => _SellerAOrdersState();
}

class _SellerAOrdersState extends State<SellerAOrders> {
  String email = '';
  List<Map<String, dynamic>> requestData = [];

  Future<void> orderData() async {
    List<OrderDetails> orderDataList = [];
    try {
      var res = await http.post(
        Uri.parse(ApiEndPoints.baseURL + ApiEndPoints.fetch_orders_seller),
        body: {
          'email': 'sar1@k.com',
        },
      );
      if (res.statusCode == 200) {
        print('Response : ${res.body}');
        var responseOrderOfBody = jsonDecode(res.body);
        if (responseOrderOfBody['success'] == true) {
          final request =
              responseOrderOfBody["orderItemsRecords"] as List<dynamic>;

          setState(() {
            requestData = request.cast<Map<String, dynamic>>();
          });
          print('RequestedData : $requestData');

          // (responseOrderOfBody['orderItemsRecords'] as List).forEach((element) {
          //   orderDataList.add(OrderDetails.fromJson(element));
          // });
        } else {
          Get.snackbar("Error", "Failed to fetch orders");
        }
      } else {
        Get.snackbar("Error", "Connection Error");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: requestData.isEmpty
          ? Center(
              child: Text(
                "No Orders Found",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: requestData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.amber,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image.asset(
                          //   requestData[index]['product_image'] ?? '',
                          //   height: 100,
                          //   width: 100,
                          //   // fit: BoxFit.contain,
                          // ),
                          Text(
                            "Your Coming Accepted Orders",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("User: ${requestData[index]['user']}"),
                          SizedBox(height: 10),
                          Text(
                              "Total Amount: ${requestData[index]['total_amount']}"),
                          SizedBox(height: 10),
                          Text({requestData[index]['cash_on_delivery']} == 0
                              ? "Payment Type : Cash On Delivery"
                              : "Payment Type : Online"),
                          SizedBox(height: 10),
                          Text(
                              "Delivery Date: ${requestData[index]['delivery_date']}"),
                          SizedBox(height: 10),
                          Text(
                              "Product: ${requestData[index]['product_name']}"),
                          SizedBox(height: 10),
                          Text(
                              "Seller Phone: ${requestData[index]['seller_phone']}"),
                          SizedBox(height: 10),
                          Text(
                              "User Phone: ${requestData[index]['user_phone']}"),
                          SizedBox(height: 10),
                          Text(
                              "Shop Address: ${requestData[index]['shop_address']}"),
                          SizedBox(height: 10),
                          Text(
                              "User Address: ${requestData[index]['user_address']}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
