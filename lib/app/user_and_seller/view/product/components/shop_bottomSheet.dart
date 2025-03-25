import 'package:ecommerce_int2/helper/app_properties.dart';
import 'package:ecommerce_int2/main.dart';


import 'package:flutter/material.dart';

import '../../../model/products.dart';
import '../../shop/check_out_page.dart';
import 'shop_product.dart';

class ShopBottomSheet extends StatefulWidget {
  final email;
  ShopBottomSheet(this.email);
  @override
  _ShopBottomSheetState createState() => _ShopBottomSheetState(email);
}

class _ShopBottomSheetState extends State<ShopBottomSheet> {
  final email2;
  _ShopBottomSheetState(this.email2);
  List<Products> products = [
    Products(
        pid: '1',
        imgurl: 'assets/headphones.png',
        name: 'Boat roackerz 400 On-Ear Bluetooth Headphones',
        description: 'description',
        price: '45.3',
        categoryId: '1',
        stock:"0",
        stock_alert:"0",
        sellerId: '1',
        gst: '12',
        sellerBoost: '1'),
  ];

  @override
  Widget build(BuildContext context) {
    Widget confirmButton = InkWell(
      onTap: () async {
        Navigator.of(context).pop();
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (_) => CheckOutPage(email2)));
        launch(context,CheckOutPage.routeName,email2);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        padding: EdgeInsets.symmetric(vertical: 20.0),
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom == 0
                ? 20
                : MediaQuery.of(context).padding.bottom),
        child: Center(
            child: new Text("Confirm",
                style: const TextStyle(
                    color: const Color(0xfffefefe),
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0))),
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
      ),
    );

    return Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.9),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(24), topLeft: Radius.circular(24))),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Image.asset(
                  'assets/box.png',
                  height: 24,
                  width: 24.0,
                  fit: BoxFit.cover,
                ),
                onPressed: () {},
                iconSize: 48,
              ),
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (_, index) {
                    return Row(
                      children: <Widget>[
                        ShopProduct(
                          products[index],
                          onRemove: () {
                            setState(() {
                              products.remove(products[index]);
                            });
                          },
                        ),
                        index == 4
                            ? SizedBox()
                            : Container(
                                width: 2,
                                height: 200,
                                color: Color.fromRGBO(100, 100, 100, 0.1))
                      ],
                    );
                  }),
            ),
            confirmButton
          ],
        ));
  }
}
