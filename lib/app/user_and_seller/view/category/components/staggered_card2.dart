import 'package:ecommerce_int2/main.dart';
import 'package:flutter/material.dart';

import '../../main/components/shop_item_list.dart';

class CategoryCard2 extends StatelessWidget {
  final Color begin;
  final Color end;
  final String categoryName;
  final String assetPath;
  final String sellerId;
  final email;
  final bool isRestricted;

  CategoryCard2(
      this.email, {
        required this.controller,
        required this.begin,
        required this.end,
        required this.categoryName,
        required this.assetPath,
        required this.sellerId,
        required this.isRestricted,
      })  : height = Tween<double>(begin: 150, end: 200.0).animate(
    CurvedAnimation(
      parent: controller,
      curve: Interval(
        0.0,
        0.300,
        curve: Curves.ease,
      ),
    ),
  ),
        itemHeight = Tween<double>(begin: 0, end: 100.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.300,
              curve: Curves.ease,
            ),
          ),
        );

  final Animation<double> controller;
  final Animation<double> height;
  final Animation<double> itemHeight;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      height: height.value,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [begin, end],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Align(
            alignment: Alignment(-1, 0),
            child: Text(
              categoryName,
              style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 16.0),
                height: 40,
                child: Image.asset(
                  assetPath,
                ),
              ),
              Container(
                child: ElevatedButton(
                  child: Text(
                    'View products',
                    style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                  ),
                  onPressed: isRestricted
                      ? null // Disable the button if the seller is restricted
                      : () => launch(context, ShopList.routeName, [sellerId, email]),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

class StaggeredCardCard2 extends StatefulWidget {
  final email2;
  final Color begin;
  final Color end;
  final String categoryName;
  final String assetPath;
  final String sellerId;
  final bool isRestricted;

  const StaggeredCardCard2(
      this.email2, {
        required this.begin,
        required this.end,
        required this.categoryName,
        required this.assetPath,
        required this.sellerId,
        required this.isRestricted,
      });

  @override
  _StaggeredCardCard2State createState() => _StaggeredCardCard2State(email2);
}

class _StaggeredCardCard2State extends State<StaggeredCardCard2> with TickerProviderStateMixin {
  final email;

  _StaggeredCardCard2State(this.email);

  late AnimationController _controller;
  bool isActive = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  }

  Future<void> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  Future<void> _reverseAnimation() async {
    try {
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (isActive) {
          isActive = !isActive;
          _reverseAnimation();
        } else {
          isActive = !isActive;
          _playAnimation();
        }
      },
      child: CategoryCard2(
        email,
        controller: _controller.view,
        categoryName: widget.categoryName,
        begin: widget.begin,
        end: widget.end,
        assetPath: widget.assetPath,
        sellerId: widget.sellerId,
        isRestricted: widget.isRestricted, // Pass the restriction flag
      ),
    );
  }
}
