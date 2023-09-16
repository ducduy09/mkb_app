// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mkb_technology/helper/DbHelper.dart';
import 'package:mkb_technology/models/user_login.dart';
import 'package:mkb_technology/view/admin/screens/main/components/side_menu.dart';
import 'package:mkb_technology/view/admin/screens/manage/setting/setting_child/admin_acc_management/edit_acc.dart';
import 'package:mkb_technology/view/admin/screens/manage/setting/setting_child/user_acc_management/edit_acc.dart';
import 'package:mkb_technology/view/admin/screens/manage/setting/setting_child/widget/list_widget.dart';
import 'package:mkb_technology/view/admin/screens/manage/slider/list_slider.dart';
import 'package:mkb_technology/view/auth/src/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'setting_child/edit_page.dart';

class AdminSetting extends StatefulWidget {
  const AdminSetting({super.key});

  @override
  _AdminSettingState createState() => _AdminSettingState();
}

class _AdminSettingState extends State<AdminSetting> {
  late SharedPreferences pref;
  final TextStyle greyTExt = const TextStyle(
    color: Color.fromARGB(255, 88, 85, 85),
  );
  bool? isLoggedIn = false;
  UserLogin? user;
  int level = 0;
  String image = "";
  bool _emailNotify = true;
  bool _pushNotify = false;

  void deleteSharedPreferencesCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void logout() async {
    setState(() {
      deleteSharedPreferencesCache();
    });
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
    user != null ? level = user!.level! : level = 0;
    List<Map<String, dynamic>> dataList =
        await DatabaseHelper.getDataById(user!.userId);
    dataList.isNotEmpty  ? image = dataList[0]["avatar"] : image = "";
    print(image);
  }

  @override
  void initState() {
    initPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 51, 122, 245),
        leading: Builder(
            builder: (context) => IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ))),
        title: const Text('Setting',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      drawer: const SideMenu(isCase: 8),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                image != ""
                    ? SizedBox(
                        height: 100,
                        width: 100,
                        child: ClipOval(
                          child: Image.asset(
                            image,
                            fit: BoxFit.cover,
                          ),
                        ))
                    : SizedBox(
                        height: 100,
                        width: 100,
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/user_1.jpg",
                            fit: BoxFit.cover,
                          ),
                        )),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "MKB Technology",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        user != null
                            ? "Level: ${user!.level.toString()}"
                            : "Account Admin",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditPage()));
                    },
                    child: const Icon(Icons.settings)),
              ],
            ),
            const SizedBox(height: 20.0),
            Card(
              color: const Color.fromARGB(255, 209, 162, 9),
              elevation: 8,
              child: ListTile(
                title: Text(
                  "Setting Slider",
                  style: GoogleFonts.montserrat(),
                ),
                subtitle: Text(
                  "Count: ",
                  style: greyTExt,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.green.shade800,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListSlider()));
                },
              ),
            ),
            if (level > 2)
              Card(
                color: const Color.fromARGB(255, 209, 162, 9),
                elevation: 8,
                child: ListTile(
                  title: Text(
                    "Admin Account Management",
                    style: GoogleFonts.montserrat(),
                  ),
                  subtitle: Text(
                    "Authorization",
                    style: greyTExt,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.green.shade800,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditAdminAccount(level: level)));
                  },
                ),
              ),
            if (level > 2)
              Card(
                color: const Color.fromARGB(255, 209, 162, 9),
                elevation: 6,
                child: ListTile(
                  title: Text(
                    "Manager Account",
                    style: GoogleFonts.montserrat(),
                  ),
                  subtitle: Text(
                    "Block, unlock or delete",
                    style: greyTExt,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.green.shade800,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditAccount()));
                  },
                ),
              ),
            Card(
              color: const Color.fromARGB(255, 209, 162, 9),
              //elevation: 6,
              child: ListTile(
                title: Text(
                  "Manager Widget",
                  style: GoogleFonts.montserrat(),
                ),
                subtitle: Text(
                  "Add, edit, delete widget",
                  style: greyTExt,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.green.shade800,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListWidget()));
                },
              ),
            ),
            Card(
              color: const Color.fromARGB(255, 209, 162, 9),
              elevation: 4,
              child: SwitchListTile(
                activeColor: Colors.green,
                title: Text(
                  "Email Notifications",
                  style: GoogleFonts.montserrat(),
                ),
                subtitle: Text(
                  _emailNotify ? "On" : "Off",
                  style: greyTExt,
                ),
                value: _emailNotify,
                onChanged: (val) {
                  setState(() {
                    _emailNotify = val;
                  });
                },
              ),
            ),
            Card(
              color: const Color.fromARGB(255, 209, 162, 9),
              //elevation: 1,
              child: SwitchListTile(
                activeColor: Colors.green,
                title: Text(
                  "Push Notifications",
                  style: GoogleFonts.montserrat(),
                ),
                subtitle: Text(
                  _pushNotify ? "On" : "Off",
                  style: greyTExt,
                ),
                value: _pushNotify,
                onChanged: (val) {
                  setState(() {
                    _pushNotify = val;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                "Logout",
                style: GoogleFonts.montserrat(color: Colors.redAccent),
              ),
              trailing: const Icon(
                Icons.login,
                color: Colors.red,
              ),
              onTap: () {
                logout();
                clearCache();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
                //Restart.restartApp();
                Phoenix.rebirth(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
