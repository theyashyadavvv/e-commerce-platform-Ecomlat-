import 'dart:io';

import 'package:ecommerce_int2/app/user_and_seller/view/profile_page/edit_profile_page.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/profile_page/liked_product.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/profile_page_content/orderHistoryUser.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/settings/help_support_user.dart';
import 'package:ecommerce_int2/app/user_and_seller/viewmodel/profile_view_model.dart';
import 'package:ecommerce_int2/helper/app_properties.dart';
import 'package:ecommerce_int2/helper/base.dart';
import 'package:ecommerce_int2/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../marketplace/marketPlacePage.dart';
import '../payment/payment_page.dart';
import '../profile_page_content/tracking_page.dart';
import '../settings/settings_page.dart';
import '../wallet/wallet_page.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = "/Profile";

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final email = data?['email'] ?? '';

    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel()..loadProfileData()..fetchWallet(email),
      child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text("Profile Page", style: TextStyle(fontSize: 16)),
            ),
            backgroundColor: Color(0xffF9F9F9),
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: kToolbarHeight),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: viewModel.pickImage,
                      child: viewModel.mediaFile != null
                          ? Image.file(File(viewModel.mediaFile!.path), width: 48, fit: BoxFit.cover)
                          : viewModel.profileUrl.isEmpty
                              ? CircleAvatar(
                                  maxRadius: 48,
                                  backgroundImage: AssetImage('assets/background.jpg'),
                                )
                              : Image.network(viewModel.profileUrl, width: 48, fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfilePage()),
                        ),
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Profile'),
                      ),
                    ),
                    Text(viewModel.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber)),
                    Text(email, style: TextStyle(fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Refferal Wallet: \₹${viewModel.walletBalance}",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    buildProfileOptions(context, email),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildProfileOptions(BuildContext context, String email) {
    return Column(
      children: [
        buildListTile(
          title: 'Settings',
          subtitle: 'Privacy and logout',
          iconPath: 'assets/icons/settings_icon.png',
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingsPage())),
        ),
        buildListTile(
          title: 'Liked Products',
          subtitle: 'Wish to buy products',
          iconPath: 'assets/icons/settings_icon.png',
          onTap: () => launch(context, LikedProduct.routeName),
        ),
        buildListTile(
          title: 'Marketplace',
          subtitle: 'Sell your own product',
          iconPath: 'assets/icons/settings_icon.png',
          onTap: () => launch(context, MarketPlaceProducts.routeName, email),
        ),
        buildListTile(
          title: 'Order History',
          subtitle: 'All previous orders',
          iconPath: 'assets/icons/settings_icon.png',
          onTap: () => launch(context, OrderHistroyUser.routeName, email),
        ),
        buildListTile(
          title: 'Help & Support',
          subtitle: 'Help center and legal support',
          iconPath: 'assets/icons/support.png',
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => HelpSupportPageUser())),
        ),
      ],
    );
  }

  Widget buildListTile({required String title, required String subtitle, required String iconPath, required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
          leading: Image.asset(iconPath, fit: BoxFit.scaleDown, width: 30, height: 30),
          trailing: Icon(Icons.chevron_right, color: yellow),
          onTap: onTap,
        ),
        Divider(),
      ],
    );
  }
}
