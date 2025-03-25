import 'dart:convert';

import 'package:ecommerce_int2/helper/app_properties.dart';
import 'package:ecommerce_int2/helper/base.dart';


import 'package:flutter/material.dart';

import '../../../../../constants/apiEndPoints.dart';
import '../../../model/products.dart';
import 'package:http/http.dart' as http;

class ProductDisplay extends StatefulWidget {
  final Products product;
  final email;
  const ProductDisplay(
    this.email, {
    required this.product,
  });

  @override
  State<ProductDisplay> createState() => _ProductDisplayState();
}

class _ProductDisplayState extends State<ProductDisplay> {
  bool isLiked = false;
  Future<void> insertLikedProduct({
    required String pid,
    required String imageUrl,
    required String name,
    required String description,
    required double price,
    required int categoryId,
    required int sellerId,
    required double gst,
    required String emailId,
  }) async {
    var url = Uri.parse(ApiEndPoints.baseURL + ApiEndPoints.liked_product);

    var data = {
      'pid': pid,
      'imageurl': imageUrl,
      'name': name,
      'description': description,
      'price': price.toString(),
      'categoryid': categoryId.toString(),
      'seller_id': sellerId.toString(),
      'gst': gst.toString(),
      'email_id': emailId,
    };

    try {
      var response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);

        if (res['message'] == "exists") {
          setState(() {
            isLiked = true;
          });
          context.toast("Already liked this product");
        } else if (res["message"] == "success") {
          setState(() {
            isLiked = true;
          });
          context.toast("Added to liked List");
        }
        // print('Data sent successfully');
        print('Response: ${response.body}');
        // Handle success response here
      } else {
        print('Failed to send data');
        // Handle error response here
      }
    } catch (e) {
      print('Error: $e');
      // Handle network error here
    }
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
            top: 30.0,
            right: 0,
            child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                height: 85,
                padding: EdgeInsets.only(right: 24),
                decoration: new BoxDecoration(
                    color: darkGrey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.16),
                          offset: Offset(0, 3),
                          blurRadius: 6.0),
                    ]),
                child: Align(
                  alignment: Alignment(1, 0),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: '\u{20B9}${widget.product.price}',
                        style: const TextStyle(
                            color: const Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                            fontSize: 36.0)),
                  ])),
                ))),
        Align(
          alignment: Alignment(-1, 0),
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
            child: Container(
              height: screenAwareSize(220, context),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 18.0,
                    ),
                    child: Container(
                      child: Hero(
                        tag: widget.product.imgurl,
                        child: Image.network(
                          widget.product.imgurl,
                          fit: BoxFit.contain,
                          height: 230,
                          width: 230,
                          errorBuilder:(context, error, stackTrace) {
                            return Image.asset(
                          widget.product.imgurl,
                          fit: BoxFit.contain,
                          height: 230,
                          width: 230,
                        );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 20.0,
          bottom: 0.0,
          child: RawMaterialButton(
            onPressed: () async {
              //write function to save the product and send to backend
              await insertLikedProduct(
                  pid: widget.product.pid,
                  imageUrl: widget.product.imgurl,
                  name: widget.product.name,
                  description: widget.product.description,
                  price: double.parse(widget.product.price),
                  categoryId: int.parse(widget.product.categoryId),
                  sellerId: int.parse(widget.product.sellerId),
                  gst: double.parse(widget.product.gst),
                  emailId: widget.email);
            },
            constraints: const BoxConstraints(minWidth: 45, minHeight: 45),
            child:
                Icon(Icons.favorite, color: Color.fromRGBO(255, 137, 147, 1)),
            elevation: 0.0,
            shape: CircleBorder(),
            fillColor: Color.fromRGBO(255, 255, 255, 0.4),
          ),
        )
      ],
    );
  }
}
