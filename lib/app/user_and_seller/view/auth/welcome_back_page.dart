import 'package:ecommerce_int2/app/admin/view/auth/admin_login.dart';
import 'package:ecommerce_int2/app/delivery/view/auth/welcome_back_driver.dart';
import 'package:ecommerce_int2/app/user_and_seller/controller/userAuthController.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/auth/register_page.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/auth/welcome_back-page-owner.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/main/main_page.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/profile_page/forgot_password_page.dart';
import 'package:ecommerce_int2/constants/colors.dart';
import 'package:ecommerce_int2/helper/app_properties.dart';
import 'package:ecommerce_int2/helper/base.dart';
import 'package:ecommerce_int2/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/widgets/diffUserText.dart';
import '../../../delivery/view/auth/duplicate_welcome_driver.dart';

class WelcomeBackPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  State<WelcomeBackPage> createState() => _WelcomeBackPageState();
}

class _WelcomeBackPageState extends State<WelcomeBackPage> {
  TextEditingController emailController =
      TextEditingController(text: 'example@email.com');
  TextEditingController passwordController =
      TextEditingController(text: '12345678');
  bool _obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  // Function to toggle the obscureText property
  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/minions.jpg'),
                  height: size.height * 0.2,
                ),
                Text('Welcome Back',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'OpenSans',
                      color: Colors.orangeAccent,
                    )),
                SizedBox(height: 10.0),
                Text(
                  'Login to your account using \nyour account number',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.yellow[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 25.0),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      emailField(),
                      const SizedBox(height: 20.0),
                      passwordField(),
                      forgotPasswordField(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      loginButton(),
                      const SizedBox(height: 70),
                      RegisterTextButton(
                          mainText: 'Admin? ',
                          actionText: 'Login here',
                          onTap: () =>
                              launch(context, AdminLoginPage.routeName)),
                      const SizedBox(height: 5.0),
                      Row(
                        children: [
                          Expanded(
                            child: RegisterTextButton(
                                mainText: 'Seller? ',
                                actionText: 'Login here',
                                onTap: () => launch(
                                    context, WelcomeBackPageOwner.routeName)),
                          ),
                          //const SizedBox(height: 15.0,width: 20.0,),
                          Expanded(
                            child: RegisterTextButton(
                                mainText: 'Driver? ',
                                actionText: 'Login here',
                                onTap: () => launch(
                                    context, WelcomeBackPageDriver.routeName)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      RegisterTextButton(
                          mainText: 'Don\'t have an account ? ',
                          actionText: 'Register here',
                          onTap: () => launch(context, RegisterPage.routeName)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget emailField() {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon:
            Icon(Icons.person_outline_outlined, color: Colors.yellow[700]),
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.yellow[700]),
        hintText: 'example@gmail.com',
        //hintStyle: TextStyle(color: Colors.black54),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow[700]!, width: 2.0),
        ),
      ),
    );
  }

  Widget passwordField() {
    return TextField(
      controller: passwordController,
      obscureText: _obscureText,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.yellow[700]),
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.yellow[700]),
        hintText: '12345678',
        hintStyle: TextStyle(color: Colors.black87),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow[700]!, width: 2.0),
        ),
        suffixIcon: IconButton(
          onPressed: _toggleObscureText,
          icon: Icon(Icons.remove_red_eye_rounded, color: Colors.yellow[700]),
        ),
      ),
    );
  }

  Widget forgotPasswordField() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
              fontWeight: FontWeight.normal,
              fontFamily: 'OpenSans',
              fontSize: 14.0),
        ),
      ),
    );
  }

  Widget loginButton() {
    return InkWell(
      onTap: () async {
        await UserAuthController.userLogin(
                emailController.text, passwordController.text)
            .then((value) async {
          print("this is the value print statement\n\n"+value.toString());
          // print("\n\n\n\n\n\n\n\n"+value['data']['isRestrict']+"\n\n\n\n\n\n\n\n");
          if (value['auth']) {
            if(value['data']['isRestrict']!="1"){
            await UserAuthController.storeUserData(value['data']['id'],
                value['data']['name'], value['data']['email'], 'customer',
                profile: value['data']['image_url']);
            final _prefs = await SharedPreferences.getInstance();
            _prefs.setBool('isLoggedIn', true);
            launch(context, MainPage.routeName, emailController.text);
            }
            else{
              context.toast("This Account is Restricted\n Please contact Admin!!!");
            }
          } else {
            // context.toast(value['msg']);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 80.0),
        decoration: BoxDecoration(
          color: Colors.yellow[700],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          'LOGIN',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
