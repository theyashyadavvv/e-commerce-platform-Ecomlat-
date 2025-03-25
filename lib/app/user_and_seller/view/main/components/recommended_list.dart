import 'package:ecommerce_int2/app/user_and_seller/controller/userController.dart';
import 'package:ecommerce_int2/helper/app_properties.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../model/products.dart';
import '../../product/product_page.dart';

class RecommendedList extends StatelessWidget {
  final email;

  RecommendedList(this.email);

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              /*IntrinsicHeight(
                child: Container(
                  margin: const EdgeInsets.only(left: 16.0, right: 8.0),
                  width: 4,
                  color: mediumYellow,
                ),
              ),*/
              Center(
                  child: Text('Recommended',
                      style: TextStyle(
                          color: darkGrey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
              future: UserController.fetchAllProductsForRecomended(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                      child: StaggeredGrid.count(
                        //physics: NeverScrollableScrollPhysics(),
                        //padding: EdgeInsets.zero,
                        crossAxisCount: 4,
                        //itemCount: snapshot.data!.length,
                        children: (snapshot.data! as List<Products>)
                            .map(
                              (product) => ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                child: InkWell(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) => ProductPage(email,
                                              product: product))),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        gradient: RadialGradient(
                                            colors: [
                                              Colors.grey.withOpacity(0.3),
                                              Colors.grey.withOpacity(0.7),
                                            ],
                                            center: Alignment(0, 0),
                                            radius: 0.6,
                                            focal: Alignment(0, 0),
                                            focalRadius: 0.1),
                                      ),
                                      child: Hero(
                                          tag: product.imgurl,
                                          child: Image.asset(product
                                              .imgurl, errorBuilder: (context, error, stackTrace) {
                                                 return Icon(Icons.error);
                                              },) /*Image.network(product.imgurl)*/)),
                                ),
                              ),
                            )
                            .toList(),
                        /*staggeredTileBuilder: (int index) => StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: index.isEven ? 3 : 2,
                          child: SizedBox(),
                        ),*/
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        axisDirection: AxisDirection.right,
                      ),
                    ),
                  );
                }
                return CircularProgressIndicator.adaptive();
              }),
        ),
      ],
    );
  }
}
