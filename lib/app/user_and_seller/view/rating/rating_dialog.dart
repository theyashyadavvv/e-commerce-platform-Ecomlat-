import 'dart:convert';

import 'package:ecommerce_int2/constants/apiEndPoints.dart';
import 'package:ecommerce_int2/helper/app_properties.dart';
import 'package:ecommerce_int2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

import '../shop/check_out_page.dart';

class RatingDialog extends StatefulWidget {
  final email;
  final productId;
  RatingDialog(this.email, {this.productId});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  final url =
      Uri.parse(ApiEndPoints.baseURL + ApiEndPoints.ratings_and_reviews);
  final TextEditingController aboutProductTextEditingController =
      TextEditingController();
  double rating = 0.0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    //data=ratingsAndReviews('')
    Widget payNow = InkWell(
      onTap: () async {

        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (_) => CheckOutPage(email)));
        var res = await saveRatingToDatabase();
        if(res){
          Dialog(
            child: Text("Rating and review Successfully"),
          );
          Navigator.pop(context);
        }else{
          Dialog(
            child: Text("Something went wrong"),
          );
        }
      },
      child: Container(
        height: 60,
        width: width / 1.5,
        decoration: BoxDecoration(
            gradient: mainButton,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ],
            borderRadius: BorderRadius.circular(9.0)),
        child: Center(
          child: Text("Pay Now",
              style: const TextStyle(
                  color: const Color(0xfffefefe),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0)),
        ),
      ),
    );

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.grey[50]),
          padding: EdgeInsets.all(24.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              'Thank You!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RichText(
                text: TextSpan(
                    style:
                        TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
                    children: [
                      TextSpan(
                        text: 'You rated ',
                      ),
                      TextSpan(
                          text: 'Boat Rockerz 350 On-Ear Bluetooth Headphones',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]))
                    ]),
              ),
            ),
            RatingBar(
              itemSize: 32,
              allowHalfRating: false,
              initialRating: 1,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              onRatingUpdate: (value) {
                setState(() {
                  
                print("Selected rating: $value");
                rating = value;
                });
              },
              ratingWidget: RatingWidget(
                empty: Icon(Icons.favorite_border,
                    color: Color(0xffFF8993), size: 20),
                full: Icon(
                  Icons.favorite,
                  color: Color(0xffFF8993),
                  size: 20,
                ),
                half: SizedBox(),
              ),
            ),
            // Container(
            //     margin: EdgeInsets.symmetric(vertical: 16.0),
            //     padding: EdgeInsets.all(16.0),
            //     decoration: BoxDecoration(
            //         color: Colors.grey[200],
            //         borderRadius: BorderRadius.all(Radius.circular(5))),
            //     child: TextField(
            //       controller: aboutProductTextEditingController,
            //       decoration: InputDecoration(
            //           border: InputBorder.none,
            //           contentPadding: EdgeInsets.zero,
            //           hintText: 'Say something about the product..'),
            //       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            //       maxLength: 200,
            //     )),
                Container(child:TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Say something about the product..'),
                )),
            payNow
          ])),
    );
  }
  //method for save ratings and it's details

  Future<bool> saveRatingToDatabase() async {
    var postData = {
      'rating': rating, // Send the dynamic rating to the server
      // other data like user ID, product ID, etc.
    };

    try {

      var response = await http.post(
        Uri.parse(ApiEndPoints.baseURL +
            ApiEndPoints.ratings_and_reviews), // Replace with your API URL
        body: {
          'user_email': widget.email,
          'rating': rating.toString(),
          'product_id':widget.productId.toString(),
          'review': aboutProductTextEditingController.text.toString()
        }, // Convert the postData map to JSON format

      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body); // Decode the JSON response body
        print(responseData['message']); // Access the 'message' field
        print("Rating saved successfully");
        return true;
      } else {
        print("Failed to save rating. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error saving rating: $e");
      return false;
    }
  }
}
