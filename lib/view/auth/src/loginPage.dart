// ignore_for_file: avoid_print, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mkb_technology/helper/DbHelper.dart';
import 'package:mkb_technology/main.dart';
import 'package:mkb_technology/models/user_login.dart';
import 'package:mkb_technology/models/users.dart';
import 'package:mkb_technology/view/admin/main.dart';
// import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:mkb_technology/helper/users.dart';

import 'Widget/bezierContainer.dart';

List<String> list = <String>['Guest', 'Admin', 'Other'];

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;
  // static int isAuthenticated = 0;
  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passController = TextEditingController();
  String dropdownValue = list.first;
  //bool isNumericType  = true;
  // final RegExp regExp = _getRegExp(isNumericType);

  late SharedPreferences pref;
  bool? isLoggedIn;
  List<Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    initPreferences();
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  void initPreferences() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = pref.getBool("isLogin");
    });
  }

  void setLoginState(String type) async {
    List<Map<String, dynamic>> updateData =
        await UserHelper.getDataByEmail(emailController.text);
    dataList = updateData;
    setState(() {
      dataList = updateData;
    });
    if (dataList != []) {
      final UserLogin user = UserLogin(
          userId: dataList[0]["userId"],
          password: passController.text,
          userName: dataList[0]["userName"],
          email: emailController.text,
          type: dropdownValue.toString(),
          level: dataList[0]["level"]);
      String jsonString = jsonEncode(user);
      pref.setString("userData", jsonString);

      List<Map<String, dynamic>> data =
          await DatabaseHelper.getDataById(dataList[0]["userId"]);
      setState(() {
        pref.setBool("isLogin", true);
        isLoggedIn = pref.getBool("isLogin");
        dataList = data;
      });
      if (type == "Guest") {
        final User userHp = User(
            id: dataList[0]["id"],
            avatar: dataList[0]["avatar"],
            name: dataList[0]["name"],
            age: dataList[0]["age"],
            address: dataList[0]["address"],
            wallet: dataList[0]["wallet"]);
        String jsonUserDt = jsonEncode(userHp);
        pref.setString("user", jsonUserDt);
        // Map<String, dynamic> userMap = userHp.toMap();
        // pref.setString("user", jsonEncode(userMap));
        print(pref.getString("userData"));
        print(pref.getString("user"));
        print(user.userId.toString());
      }
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            const Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _entryField(
      String title, String text, TextEditingController? Controller,
      {bool isNumericType = false, bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color.fromARGB(255, 255, 191, 0)),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: Controller,
            style: const TextStyle(color: Colors.white),
            obscureText: isPassword,
            inputFormatters: [getInputFormatter(isNumericType)],
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xfff3f3f4),
                ),
              ),
              filled: true,
              hintText: text,
              fillColor: const Color.fromARGB(255, 195, 195, 201),
            ),
          ),
        ],
      ),
    );
  }

  late FToast fToast;

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (emailController.text != '' && passController.text != '') {
          print(UserHelper.checkLogin(emailController.text, passController.text,
                  dropdownValue.toString())
              .toString());
          // ignore: unnecessary_null_comparison
          print(UserHelper.status);
          int check = 0;
          setState(() {
            UserHelper.checkLogin(emailController.text, passController.text,
                    dropdownValue.toString())
                .toString();
            check = UserHelper.check;
          });
          if (check == 1) {
            print('Login success');
            if (dropdownValue.toString() == "Admin") {
              setLoginState("Admin");
              print(isLoggedIn);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyAppAdmin()));
            } else {
              setLoginState("Guest");
              print(isLoggedIn);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()));
            }
            fToast.showToast(
              child: const Text('Login successfully !!',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              gravity: ToastGravity.BOTTOM,
              toastDuration: const Duration(seconds: 2),
            );
          } else if (UserHelper.check == 0) {
            print('Login:${emailController.text}');
            print('Login:${passController.text}');
            print('Login:${dropdownValue.toString()}');
            print('Login failed');
          } else {
            fToast.showToast(
              child: const Text('Login Error !!',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              gravity: ToastGravity.BOTTOM,
              toastDuration: const Duration(seconds: 2),
            );
            print('Login:${emailController.text}');
            print('Login:${passController.text}');
            print('Login:${dropdownValue.toString()}');
            print('Login error');
          }
          print(UserHelper.status);
          if (UserHelper.status == 0) {
            fToast.showToast(
              child: const Text('Your account has been banned !!',
                  style: TextStyle(
                    color: Color.fromARGB(255, 231, 108, 7),
                  )),
              gravity: ToastGravity.CENTER,
              toastDuration: const Duration(seconds: 2),
            );
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color:
                      const Color.fromARGB(255, 255, 255, 255).withAlpha(100),
                  offset: const Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: const Color.fromARGB(255, 236, 153, 29)),
        child: const Text(
          'Login',
          style: TextStyle(
              fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: const Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _dropdownButton() {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: const Text('f',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: const Text('Log in with Facebook',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SignUpPage()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 2, 2, 2)),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Column(children: [
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000.0, maxHeight: 400.0),
        child: FittedBox(
          fit: BoxFit.cover,
          child: Image.asset(
            'assets/images/logo_office.png',
            width: 800,
            height: 500,
          ),
        ),
      )
    ]);
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email", "Email", emailController),
        _entryField("Password", "Password", passController, isPassword: true),
        _dropdownButton()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SizedBox(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: const BezierContainer()),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //SizedBox(height: height * .2),
                      _title(),
                      const SizedBox(height: 50),
                      _emailPasswordWidget(),
                      const SizedBox(height: 20),
                      _submitButton(),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: const Text('Forgot Password ?',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                      _divider(),
                      _facebookButton(),
                      SizedBox(height: height * .055),
                      _createAccountLabel(),
                    ],
                  ),
                ),
              ),
              Positioned(top: 0, left: 0, child: _backButton()),
            ],
          ),
        ));
  }
}

// RegExp _getRegExp(bool isNumericKeyBoard) {
//   return isNumericKeyBoard
//       ? RegExp('[0-9 ]')
//       : RegExp('[^"\']*[^\'\"]', unicode: true);
// }

TextInputFormatter getInputFormatter(bool isNumericKeyBoard) {
  if (isNumericKeyBoard) {
    return FilteringTextInputFormatter.allow(RegExp('[0-9 ]'));
  } else {
    return FilteringTextInputFormatter.allow(
        RegExp('[^"\']*[^\'\"`]', unicode: true));
  }
}
