import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mkb_technology/helper/products.dart';
import 'package:mkb_technology/models/user_login.dart';
import 'package:mkb_technology/view/user/about_us.dart';
import 'package:mkb_technology/view/admin/screens/main/components/side_menu.dart';
// import 'package:mkb_technology/view/admin/screens/manage/user/list_user.dart';
import 'package:mkb_technology/view/auth/src/loginPage.dart';
import 'package:mkb_technology/view/user/list_cart.dart';
import 'package:mkb_technology/view/user/profile_user.dart';
import 'package:mkb_technology/view/user/orders_success/list_transaction.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'product/products.dart';

class MyWidgetDrawer extends StatefulWidget {
  final int isCase;
  const MyWidgetDrawer({super.key, required this.isCase});

  @override
  State<MyWidgetDrawer> createState() => _MyWidgetDrawerState();
}

void clearCache() {
  DefaultCacheManager().emptyCache();
}

class _MyWidgetDrawerState extends State<MyWidgetDrawer> {
  late SharedPreferences pref;
  bool? isLoggedIn = false;
  UserLogin? user;

  @override
  void initState() {
    _getProductListData();
    initPreferences();
    super.initState();
  }

  void deleteSharedPreferencesCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void logout() async {
    // List<String> a = [];
    setState(() {
      deleteSharedPreferencesCache();
      pref.setBool("isLogin", false);
      isLoggedIn = pref.getBool("isLogin");
    });
    final UserLogin userlg =
        UserLogin(userId: 0, userName: "", email: "", password: "", type: "");

    String jsonString = jsonEncode(userlg);
    pref.setString("userData", jsonString);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initPreferences() async {
    pref = await SharedPreferences.getInstance();
    String? userData = pref.getString("userData");
    setState(() {
      if (userData != null) {
        user = UserLogin.fromMap(jsonDecode(userData));
      }
      isLoggedIn = pref.getBool("isLogin");
    });
  }

  List<Map<String, dynamic>> dataList = [];

  void _getProductListData() async {
    List<Map<String, dynamic>> updateData = await ProductHelper.getData();
    dataList = updateData;
    setState(() {
      dataList = updateData;
      context.read<ListData>().transmissionData(dataList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //backgroundColor: Colors.white,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          Image.asset('assets/images/logo_office.png'),
          // const UserAccountsDrawerHeader(
          //   decoration: BoxDecoration(color: const Color(0xff764abc)),
          //   accountName: Text(
          //     "Pinkesh Darji",
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   accountEmail: Text(
          //     "pinkesh.earth@gmail.com",
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   currentAccountPicture: FlutterLogo(),
          // ),
          ListTile(
            leading: const Icon(
              Icons.home,
            ),
            title: const Text('Home'),
            onTap: () {
              if (widget.isCase != 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHomePage()));
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.phone_iphone_rounded,
            ),
            title: const Text('Products'),
            onTap: () {
              if (widget.isCase != 2) {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProductPage()));
              }
            },
          ),
          if (isLoggedIn == false || isLoggedIn == null)
            ListTile(
              leading: const Icon(
                Icons.person,
              ),
              title: const Text('About Us'),
              onTap: () {
                if (widget.isCase != 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutUsPage()));
                }
              },
            ),
          if (isLoggedIn == true)
            ListTile(
              leading: const Icon(
                Icons.person,
              ),
              title: const Text('Profile'),
              onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileUser()));
              },
            ),
          if (isLoggedIn == true)
            ListTile(
              leading: const Icon(
                Icons.shopping_cart_outlined,
              ),
              title: const Text('Cart'),
              onTap: () {
                if (widget.isCase != 3) {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ListCart()));
                }
              },
            ),
          if (isLoggedIn == true)
            ListTile(
              leading: const Icon(
                Icons.checklist,
              ),
              title: const Text('Order approved'),
              onTap: () {
                if (widget.isCase != 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListTransaction()));
                }
              },
            ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.person,
          //   ),
          //   title: const Text('About Us'),
          //   onTap: () {
          //      Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsPage()));
          //   },
          // ),
          const AboutListTile(
            // <-- SEE HERE
            icon: Icon(
              Icons.info,
            ),
            applicationIcon: Icon(
              Icons.local_play,
            ),
            applicationName: 'MKB App',
            applicationVersion: '1.0.0',
            applicationLegalese: '© 2019 Company',
            // aboutBoxChildren: [
            //   ///Content goes here...
            // ],
            child: Text('About app'),
          ),
          const SizedBox(
            height: 26,
          ),
          if (isLoggedIn == true)
            ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text('Logout'),
              onTap: () {
                logout();
                clearCache();
              },
            ),
          if (isLoggedIn == false || isLoggedIn == null)
            ListTile(
              leading: const Icon(
                Icons.login,
              ),
              title: const Text('Login'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
        ],
      ),
    );
  }
}
