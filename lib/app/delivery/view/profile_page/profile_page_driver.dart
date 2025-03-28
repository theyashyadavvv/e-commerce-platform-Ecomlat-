import 'package:ecommerce_int2/app/delivery/view/kyc/kyc_page.dart';
import 'package:ecommerce_int2/helper/app_properties.dart';
import 'package:ecommerce_int2/app/admin/view/profile_page/showMessageDriver.dart';
import 'package:ecommerce_int2/main.dart';
import 'package:flutter/material.dart';
import '../../../user_and_seller/view/profile_page_content/faq_page.dart';
import '../../../user_and_seller/view/profile_page_content/pending_requests.dart';
import '../../../user_and_seller/view/profile_page_content/sell_item.dart';
import '../../../user_and_seller/view/profile_page_content/tracking_page.dart';
import '../../../user_and_seller/view/settings/settings_page.dart';
import '../../../user_and_seller/view/wallet/wallet_page.dart';


class ProfilePageDriver extends StatelessWidget {
  static const routeName = "/ProfileDriver";
  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.only(left: 16.0, right: 16.0, top: kToolbarHeight),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  maxRadius: 48,
                  backgroundImage: AssetImage('assets/background.jpg'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    email,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Please complete your KYC',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: transparentYellow,
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: Offset(0, 1))
                      ]),
                  height: 150,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Image.asset('assets/icons/wallet.png'),
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => WalletPage())),
                            ),
                            Text(
                              'Wallet',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Image.asset('assets/icons/truck.png'),
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => TrackingPage())),
                            ),
                            Text(
                              'Shipped',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Image.asset('assets/icons/card.png'),
                               
                              onPressed: () =>   launch(context, SellItem.routeName, email),
                              
                              // Navigator.of(context).pushNamed(
                              //     SellItem.routeName,
                              //     arguments: email),
                            ),
                            Text(
                              'Sell Item',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Image.asset('assets/icons/contact_us.png'),
                              onPressed: () {},
                            ),
                            Text(
                              'Support',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Settings'),
                  subtitle: Text('Privacy and logout'),
                  leading: Image.asset(
                    'assets/icons/settings_icon.png',
                    fit: BoxFit.scaleDown,
                    width: 30,
                    height: 30,
                  ),
                  trailing: Icon(Icons.chevron_right, color: yellow),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => SettingsPage())),
                ),
                Divider(),
                ListTile(
                  title: Text('KYC'),
                  subtitle: Text('Service Area and other details'),
                  leading: Icon(
                    Icons.area_chart_outlined,
                    color: Colors.black54,
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: yellow,
                  ),
                  onTap: () {
                    //final String email = 'user@example.com';
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => KycPageDriver(),
                        settings: RouteSettings(arguments: email),
                      ),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('Pending Requests'),
                  subtitle: Text('Repairing services'),
                  leading: Image.asset('assets/icons/support.png'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: yellow,
                  ),
                  onTap: () =>  launch(context, PendingRequest.routeName, email),
                  //  Navigator.of(context)
                  //     .pushNamed(PendingRequest.routeName, arguments: email),
                ),
                Divider(),
                ListTile(
                  title: Text('Messages'),
                  subtitle: Text('Received Messages'),
                  leading: Image.asset('assets/icons/support.png'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: yellow,
                  ),
                  onTap: () => launch(context, ShowMessagesDriver.routeName, email),
                  //  Navigator.of(context).pushNamed(
                  //     ShowMessagesDriver.routeName,
                  //     arguments: email ),
                ),
                Divider(),
                ListTile(
                  title: Text('Help & Support'),
                  subtitle: Text('Help center and legal support'),
                  leading: Image.asset('assets/icons/support.png'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: yellow,
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text('FAQ'),
                  subtitle: Text('Questions and Answer'),
                  leading: Image.asset('assets/icons/faq.png'),
                  trailing: Icon(Icons.chevron_right, color: yellow),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => FaqPage())),
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
