// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mkb_technology/helper/DbHelper.dart';
import 'package:mkb_technology/main.dart';
import 'package:mkb_technology/models/user_login.dart';
import 'package:mkb_technology/models/users.dart';
// import 'package:mkb_technology/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Widget/bezierContainer.dart';
import 'loginPage.dart';
import 'package:mkb_technology/helper/users.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:google_fonts/google_fonts.dart';
List<String> list = <String>['Guest', 'Admin', 'Other'];

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController nameController = TextEditingController();
  late TextEditingController passController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  final ageController = TextEditingController();
  final avtController = TextEditingController();
  final addressController = TextEditingController();
  String imageLink = "";

  String dropdownValue = list.first;

  TextInputFormatter getInputFormatter(bool isNumericKeyBoard) {
    if (isNumericKeyBoard) {
      return FilteringTextInputFormatter.allow(RegExp('[0-9 ]'));
    } else {
      return FilteringTextInputFormatter.allow(
          RegExp('[^"\']*[^\'\"`]', unicode: true));
    }
  }

  late SharedPreferences pref;
  bool? isLoggedIn;

  void initPreferences() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = pref.getBool("isLogin");
    });
  }

  Future<void> _getImageLink() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageLink = pickedFile.path
            .replaceFirst("E:\\Project_Flutter\\mkb_technology\\", "");
        imageLink = imageLink.replaceAll("\\", "/");
        avtController.text = imageLink;
        //_imageLink = pickedFile.path
        //int index = _imageLink.indexOf("mkb_technology\\");
        //String result = _imageLink[index + 1];
        //linkController.text = _imageLink;
      });
    }
  }

  Widget inputImage() {
    return ElevatedButton(
      onPressed: () {
        _getImageLink();
      },
      child: const Text('Choose Image'),
    );
  }

  List<Map<String, dynamic>> dataList = [];
  void registerUser() async {
    List<Map<String, dynamic>> updateData =
        await UserHelper.getDataByEmail(emailController.text);
    setState(() {
      pref.setBool("isLogin", true);
      dataList = updateData;
    });
    UserLogin user = UserLogin(
        userId: dataList[0]["userId"],
        userName: nameController.text,
        email: emailController.text,
        password: passController.text,
        type: "Guest");
    String jsonString = jsonEncode(user);
    pref.setString("userData", jsonString);

    List<Map<String, dynamic>> data =
        await DatabaseHelper.getDataById(dataList[0]["userId"]);
    print(data);
    final User userHp = User(
        id: data[0]["id"],
        avatar: data[0]["avatar"],
        name: data[0]["name"],
        age: data[0]["age"],
        address: data[0]["address"],
        wallet: data[0]["wallet"]);
    String jsonUserDt = jsonEncode(userHp);
    pref.setString("user", jsonUserDt);
    // Map<String, dynamic> userMap = userHp.toMap();
    // pref.setString("user", jsonEncode(userMap));
    print(pref.getString("userData"));
    print(pref.getString("user"));
    print(user.userId.toString());
  }

  bool checkUser(String email) {
    UserHelper.getDataByEmail(email);
    // ignore: unnecessary_null_comparison
    if (UserHelper.check == 1) {
      return true;
    }
    return false;
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
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _entryField(
      String title, String text, TextEditingController controller,
      {bool isNumericType = false, bool isPassword = false, bool read = false}) {
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
            readOnly: read,
            controller: controller,
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
              fillColor: const Color(0xfff3f3f4),
            ),
          ),
        ],
      ),
    );
  }

  late FToast fToast;
  @override
  void initState() {
    initPreferences();
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  int idUS = 0;
  void getLastID() async {
    idUS = UserHelper.getId();
    print(idUS);
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        if (checkUser(emailController.text) == true) {
          fToast.showToast(
            child: const Text("This account already exists"),
            gravity: ToastGravity.BOTTOM,
            toastDuration: const Duration(seconds: 2),
          );
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        } else {
          UserHelper.insertUser(nameController.text, emailController.text,
              passController.text, "Guest");
          DatabaseHelper.insertUser(
              idUS,
              avtController.text,
              nameController.text,
              int.parse(ageController.text),
              addressController.text,
              0);
          fToast.showToast(
            child: const Text('Create account successfully !!'),
            gravity: ToastGravity.BOTTOM,
            toastDuration: const Duration(seconds: 2),
          );
          registerUser();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MyHomePage()));
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
          'Register Now',
          style: TextStyle(
              fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 2, 2, 2)),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
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
        _entryField("Username", "Username", nameController),
        _entryField("Email ", "Email", emailController),
        _entryField("Password", "Password", passController, isPassword: true),
        _entryField("Age ", "Age", ageController),
        _entryField("Address ", "Address", addressController),
        _entryField("Avatar ", "Avatar", avtController, read: true),
        inputImage(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: const BezierContainer(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //SizedBox(height: height * .2),
                    _title(),
                    const SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .10),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 0, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
