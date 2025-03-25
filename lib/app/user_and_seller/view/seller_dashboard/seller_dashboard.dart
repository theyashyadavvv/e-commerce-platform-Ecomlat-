import 'dart:convert';

import 'package:ecommerce_int2/app/user_and_seller/model/user.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/profile_page_content/add_seller_item.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/profile_page_content/edit_item.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/seller_a_order_page/seller_a_order_page.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/service_men/service_men_list.dart';
import 'package:ecommerce_int2/shared/viewmodels/commonViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/apiEndPoints.dart';
import '../../../../main.dart';
import '../../controller/userController.dart';
import '../../controller/userProductController.dart';
import '../../model/products.dart';
import '../../model/services.dart';
import '../profile_page/profile_page_seller.dart';

class SellerDashboard extends StatefulWidget {
  static const routeName = "/SellerDashboard";
  @override
  _SellerDashboardState createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard>
    with TickerProviderStateMixin {
  String name = '';
  String email = '';
  String totalOrders = '' ;
  List<User> users = [];
  String month_orders='';
  String all_orders='';

  getUsers() async {
    final _prefs = await SharedPreferences.getInstance();
    name = await _prefs.getString('userName') ?? '';
    email = await _prefs.getString('userEmail') ?? '';
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getUsers();
      // await _fetchTotalOrders();
      await _fetchUserOrders();
    });
    super.initState();
  }

  Future<void> _fetchTotalOrders() async {
    try {
      var response = await http.post(
          Uri.parse(ApiEndPoints.baseURL+ApiEndPoints.get_sales), body: {
        'seller_id': '2',
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          setState(() {
            totalOrders = responseData['total_orders'];
          });
        } else {
          print('Failed to fetch total orders');
        }
      } else {
        print('Server error');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  Future<void> _fetchUserOrders() async {
    try {
      var response = await http.post(
          Uri.parse(ApiEndPoints.baseURL+ApiEndPoints.total_sales), body: {
        'email': email,
      });
      final responseData = json.decode(response.body);
      print(responseData.toString());

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          setState(() {
            all_orders = responseData['all_orders'];
            month_orders = responseData['month_orders'];
          });
        } else {
          print('Failed to fetch total orders');
        }
      } else {
        print('Server error');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[100],
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Text(
                  'Hi $name',
                  style: CommonViewModel.primaryTitleBlack,
                ),
                //this navigate you on seller_a_order_page file
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SellerAOrders(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Icon(CupertinoIcons.cart),
                        Text("Orders"),
                      ],
                    )),
              ],
            ),
            actions: [
              InkWell(
                onTap: () {
                  launch(context, ProfilePageSeller.routeName, email);
                },
                child: CircleAvatar(
                    child: Text(
                        name.trim().isNotEmpty
                            ? name.substring(0, 1).toUpperCase()
                            : "",
                        style: CommonViewModel.primaryTitleWhite),
                    backgroundColor: Colors.red,
                    radius: 32),
              )
            ],
          ),
          floatingActionButton:ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddSellerItemScreen(),
                  ),
                );


              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text("Add Items",
                  style: TextStyle(fontSize: 20,
                  height: 3),),
                  // Icon(CupertinoIcons.add),
                ],
              )),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    children: [
                      Card(
                        color: Colors.greenAccent,
                        elevation: 10,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                all_orders.toString(),
                                style: CommonViewModel.primaryTitleBlack
                                    .copyWith(
                                        color: Colors.white70, fontSize: 32),
                              ),
                              Text(
                                'Total Sale',
                                style: CommonViewModel.primaryTitleBlack
                                    .copyWith(
                                        color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.greenAccent,
                        elevation: 10,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                month_orders.toString(),
                                style: CommonViewModel.primaryTitleBlack
                                    .copyWith(
                                        color: Colors.white70, fontSize: 32),
                              ),
                              Text(
                                'This Month Sale',
                                style: CommonViewModel.primaryTitleBlack
                                    .copyWith(
                                        color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Text(
                    'All Services',
                    style: CommonViewModel.primaryTitleBlack
                        .copyWith(color: Colors.grey, fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  FutureBuilder(
                      future: UserController.getSellerServices(),
                      builder: (context, AsyncSnapshot snapshot) {
                        return snapshot.hasData
                            ? Container(
                                height: 86,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  separatorBuilder: (_, i) {
                                    return SizedBox(width: 16);
                                  },
                                  itemBuilder: (_, i) {
                                    RepairApi services = snapshot.data[i];
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            launch(context,
                                                ServiceMenList.routeName, {
                                              "service_id": services.id,
                                              "service_name": services.service
                                            });
                                          },
                                          child: FadeInImage(
                                            placeholder: AssetImage(
                                                'assets/icons/service.png'),
                                            image: AssetImage(
                                                'assets/icons/${services.service.toLowerCase()}.png'),
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                  'assets/icons/service.png',
                                                  height: 56);
                                            },
                                            height: 56,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          services.service,
                                          style: CommonViewModel
                                              .primaryTitleBlack
                                              .copyWith(
                                                  color: Colors.blueGrey,
                                                  fontSize: 14),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            : Text(
                                'No Service Found',
                                style: CommonViewModel.primaryTitleBlack
                                    .copyWith(color: Colors.grey, fontSize: 16),
                              );
                      }),
                  SizedBox(height: 32),
                  Text(
                    'All Products',
                    style: CommonViewModel.primaryTitleBlack
                        .copyWith(color: Colors.grey, fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Flexible(
                    child: FutureBuilder(
                      future: UserProductController.getSellerProducts(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: Text("Loading..."),
                          );
                        }
                        if (snapshot.hasData) {
                          return Container(
                            padding: EdgeInsets.only(top: 22.0, right: 16.0, left: 16.0),
                            child: StaggeredGrid.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 2.0,
                              crossAxisSpacing: 2,
                              children: (snapshot.data! as List<Products>).map(
                                (product) => InkWell(
                                  onTap: () async {
                                    final result = await launch(
                                      context,
                                      EditItem.routeName,
                                      {
                                        "product": product,
                                        "email": email,
                                      },
                                    );
                                    await _fetchTotalOrders();
                                    setState(() {});
                                    print("hello \n\n\n\n this is after set State \n\n\n\n hello");

                                    if (result == true) {
                                      print("this is calling setState");
                                      setState(() {});
                                    }
                                  },
                                  child: product.imgurl.contains("assets")
                                      ? Card(
                                          elevation: 10,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  FadeInImage(
                                                    image: product.imgurl.contains("assets")
                                                        ? AssetImage("assets/cap_1.png")
                                                        : AssetImage("assets/cap_1.png"),
                                                    placeholder: NetworkImage(
                                                        "https://i.gifer.com/ZZ5H.gif"),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    product.name,
                                                    style: CommonViewModel.primaryTitleBlack
                                                        .copyWith(
                                                      color: Colors.blueGrey,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    'RS ${product.price}',
                                                    style: CommonViewModel.primaryTitleBlack
                                                        .copyWith(
                                                      color: Colors.greenAccent,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 4),
                                                  // Safe integer parsing
                                                  Builder(
                                                    builder: (context) {
                                                      int stockAlert = int.tryParse(
                                                              product.stock_alert ?? "0") ??
                                                          0;
                                                      int stock =
                                                          int.tryParse(product.stock ?? "0") ?? 0;

                                                      return stockAlert >= stock
                                                          ? Text(
                                                              'Low Stock Available',
                                                              style: CommonViewModel
                                                                  .primaryTitleBlack
                                                                  .copyWith(
                                                                color: Colors.red.shade400,
                                                                fontSize: 16,
                                                              ),
                                                              textAlign: TextAlign.center,
                                                            )
                                                          : SizedBox();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ),
                              ).toList(),
                            ),
                          );
                        }
                        return Center(
                          child: Text(
                            "No products",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class YellowDollarButton extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double height = size.height;
    double width = size.width;

    canvas.drawCircle(Offset(width / 2, height / 2), height / 2,
        Paint()..color = Color.fromRGBO(253, 184, 70, 0.2));
    canvas.drawCircle(Offset(width / 2, height / 2), height / 2 - 4,
        Paint()..color = Color.fromRGBO(253, 184, 70, 0.5));
    canvas.drawCircle(Offset(width / 2, height / 2), height / 2 - 12,
        Paint()..color = Color.fromRGBO(253, 184, 70, 1));
    canvas.drawCircle(Offset(width / 2, height / 2), height / 2 - 16,
        Paint()..color = Color.fromRGBO(255, 255, 255, 0.1));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
