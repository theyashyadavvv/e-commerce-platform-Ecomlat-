import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecommerce_int2/app/user_and_seller/model/product.dart';
import 'package:ecommerce_int2/app/user_and_seller/model/reviews_details_model/reviews_details_model.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/rating/rating_dialog.dart';
import 'package:ecommerce_int2/constants/apiEndPoints.dart';
import 'package:ecommerce_int2/helper/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

class RatingPage extends StatefulWidget {
  final email;
  final productId;
  final productImage;
  final productDescription;
  RatingPage(this.email,
      {this.productId, this.productImage, this.productDescription});

  @override
  _RatingPageState createState() => _RatingPageState(email);
}

class _RatingPageState extends State<RatingPage> {
  final email2;
  late ReviewsDetailsModel reviewData = ReviewsDetailsModel();
  _RatingPageState(this.email2);
  double rating = 0.0;
  List<int> ratings = [2, 1, 5, 2, 4, 3];
  List<Map<String, dynamic>> reviews = [];
  List<Map<String, dynamic>> requestData = [];

  double? AverageRating;
  int? TotalPeople;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reviewsAndCommentData();
    // reviewData = ReviewsDetailsModel.fromJson(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Image.asset('assets/icons/comment.png'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: RatingDialog(
                        email2,
                        productId: widget.productId,
                      ),
                    );
                  },
                );
              },
              color: Colors.black,
            ),
          ],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (b, constraints) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            height: 92,
                            width: 92,
                            decoration: BoxDecoration(
                                color: yellow,
                                shape: BoxShape.circle,
                                boxShadow: shadow,
                                border: Border.all(
                                    width: 8.0, color: Colors.white)),
                            child: Image.asset(widget.productImage ?? ''),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 72.0, vertical: 16.0),
                            child: Text(
                              '${widget.productDescription}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Text(
                                '${AverageRating ?? '0'}',
                                style: TextStyle(fontSize: 48),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                RatingBar(
//                      borderColor: Color(0xffFF8993),
//                      fillColor: Color(0xffFF8993),
                                  ignoreGestures: true,
                                  itemSize: 20,
                                  allowHalfRating: true,
                                  initialRating: 1,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
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
                                  onRatingUpdate: (value) {
                                    setState(() {
                                      rating = value;
                                    });
                                    print(value);
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child:
                                      Text('from ${TotalPeople ?? 0} people'),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Align(
                            alignment: Alignment(-1, 0),
                            child: Text('Recent Reviews')),
                      ),
                      reviews.isEmpty
                          ? Center(
                              child: Text('No Reviews'),
                            )
                          : Column(
                              children: <Widget>[
                                ...reviews.map((review) {
                                  // Extracting values from each review
                                  String userName = review['user_name'];
                                  String userImage = review['user_image'];
                                  String reviewText = review['review'];
                                  List comments = review['comments'];
                                  double rating = review['rating'].toDouble();

                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 16.0),
                                          child: CircleAvatar(
                                            maxRadius: 14,
                                            backgroundImage: NetworkImage(
                                                userImage), // User's image from the data
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    userName, // User's name
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '10 am, Via iOS', // This can be dynamic if you have timestamps
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10.0),
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: RatingBar(
                                                  ignoreGestures: true,
                                                  itemSize: 20,
                                                  initialRating: rating,
                                                  allowHalfRating: true,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 4.0),
                                                  ratingWidget: RatingWidget(
                                                    empty: Icon(
                                                        Icons.favorite_border,
                                                        color:
                                                            Color(0xffFF8993),
                                                        size: 20),
                                                    full: Icon(Icons.favorite,
                                                        color:
                                                            Color(0xffFF8993),
                                                        size: 20),
                                                    half: SizedBox(),
                                                  ),
                                                  onRatingUpdate: (value) {
                                                    // This is for interactive rating update, but you might not need it here
                                                  },
                                                ),
                                              ),
                                              Text(
                                                reviewText, // Review text
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      '${comments.length} likes', // Comment count
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[400],
                                                          fontSize: 10.0),
                                                    ),
                                                    Text(
                                                      '${comments.length} Comment', // Comment count
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10.0),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              // TextField(),
                                              StatefulBuilder(
  builder: (BuildContext context, StateSetter setState) {
    return TextField(
      // controller: _getController(comments.indexOf(comment)),
      decoration: InputDecoration(
        hintText: "Write a comment...",
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {});  // ✅ Only updates the TextField state
      },
    );
  },
),

                                              // Displaying the comments for the review
                                              ...comments.map((comment) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 32.0),
                                                  child: Text(
                                                    comment[
                                                        'comment_text'], // Comment text
                                                    style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12.0),
                                                  ),
                                                );
                                              }).toList(),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> reviewsAndCommentData() async {
    List reviewDetails = [];
    try {
      // Construct the URL using Uri.parse and widget.productId
      var url = Uri.parse(ApiEndPoints.baseURL +
          ApiEndPoints.reviews_details +
          "?product_id=${widget.productId}");
      print(url);
      print("this was url of the uri");

      // Make the HTTP GET request
      var res = await http.get(url);
      print(res.body.toString()+"\n\n this is the response of the url");

      if (res.statusCode == 200) {
        var responseBody = jsonDecode(res.body);
        Map<String, dynamic> responseString = json.decode(res.body);

        // Check if the response indicates success
        if (responseBody['success'] == true) {
          // If success is true, print the entire response body
          // print(res.body);
          ReviewsDetailsModel.fromJson(res.body);
          // Optionally, you can parse the data further and add it to your list
          // (responseBody['reviews'] as List).forEach((element) {
          //   reviewDetails.add(ReviewDetails.fromJson(element));
          // });
          // If success is true, print the entire response body
          // print(res.body);

          // Parse the response data and create model objects
          setState(() {
            reviews = responseBody['comments'];
            // reviewData = ReviewsDetailsModel.fromJson(responseBody);
          });

          print(reviews);
          // Optionally, add the parsed model to your list
          reviewDetails.add(reviewData);

          // You can now use 'reviewDetails' to access your reviews data
          print(reviewDetails); // For debugging purpose
        } else {
          // If success is false, print the response body
          print(responseBody);
          print("This was else part");
          setState(() {
            AverageRating = responseString['average_rating'];
            TotalPeople = responseString['total_reviews'];
            reviews =
                List<Map<String, dynamic>>.from(responseString['reviews']);
          });
        }
      } else {
        // If the status code is not 200, print the response
        print('Failed to load data: ${res.statusCode}');
        print(res.body);
      }
    } catch (e) {
      // If an error occurs during the request, show a Snackbar and print the error
      await Future.delayed(Duration(milliseconds: 500));
      Get.snackbar("Error", "Something went wrong");
      print(e);
    }
  }
}
