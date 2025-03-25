import 'package:ecommerce_int2/app/user_and_seller/view/auth/welcome_back_page.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/seller_dashboard/seller_dashboard.dart';
import 'package:ecommerce_int2/helper/app_properties.dart';
import 'package:ecommerce_int2/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/user_and_seller/view/main/main_page.dart';

class IntroPage extends StatefulWidget {
  static const String routeName = "/IntroPage";

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  PageController controller = PageController();
  int pageIndex = 0;

  Future<void> _checkIntroStatusAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool introShown = prefs.getBool('introShown') ?? false;
    bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    String? userType = prefs.getString("userType");

    String email = prefs.getString("userEmail") ?? "";
    if (introShown) {
      // Navigator.of(context).pushReplacementNamed(WelcomeBackPage.routeName);

      isLoggedIn
          ? userType == 'userOwnerLogin'
              ? launch(context, SellerDashboard.routeName, email)
              : launch(context, MainPage.routeName, email)
          : replace(context, WelcomeBackPage.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIntroStatusAndNavigate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[100],
            image: DecorationImage(image: AssetImage('assets/background.png'))),
        child: Stack(children: <Widget>[
          PageView(
              onPageChanged: (value) {
                setState(() {
                  pageIndex = value;
                });
              },
              controller: controller,
              children: <Widget>[
                itemPageView(
                  image: 'assets/firstScreen.png',
                  title: 'Get Any Thing Online',
                  subtitle:
                      'You can buy anything ranging from digital products to hardware within few clicks.',
                ),
                itemPageView(
                  image: 'assets/secondScreen.png',
                  title: 'Shipping to anywhere ',
                  subtitle:
                      'We will ship to anywhere in the world, With 30 day 100% money back policy.',
                ),
                itemPageView(
                  image: 'assets/thirdScreen.png',
                  title: 'On-time delivery',
                  subtitle:
                      'You can track your product with our powerful tracking service.',
                )
              ]),
          Positioned(
            bottom: 16.0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      itemIndicator(0),
                      itemIndicator(1),
                      itemIndicator(2),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Opacity(
                        opacity: pageIndex != 2 ? 1.0 : 0.0,
                        child: buttonView('SKIP',
                            onPressed: () async => loadIntroPage()),
                      ),
                      pageIndex != 2
                          ? buttonView('NEXT', onPressed: () => loadNextPage())
                          : buttonView('FINISH',
                              onPressed: () async => loadIntroPage()),
                    ]),
              ]),
            ),
          )
        ]),
      ),
    );
  }

  Widget itemPageView(
      {required String image,
      required String title,
      required String subtitle}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Image.asset(
            image,
            height: 200,
            width: 200,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            title,
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16.0),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
        ),
      ],
    );
  }

  Widget itemIndicator(int index) {
    return Container(
      margin: EdgeInsets.all(8.0),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 2),
          color: pageIndex == index ? yellow : Colors.white),
    );
  }

  Widget buttonView(String title, {VoidCallback? onPressed}) {
    return MaterialButton(
      splashColor: Colors.transparent,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      onPressed: onPressed,
    );
  }

  void loadNextPage() {
    if (!(controller.page == 2.0)) {
      controller.nextPage(
          duration: Duration(milliseconds: 200), curve: Curves.linear);
    }
  }

  Future<void> loadIntroPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('introShown', true);
    replace(context, WelcomeBackPage.routeName);
  }
}
