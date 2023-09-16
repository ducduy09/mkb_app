// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mkb_technology/helper/DbHelper.dart';
import 'package:mkb_technology/models/users.dart';
import 'package:mkb_technology/view/admin/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _submitButton(BuildContext context) {
  return InkWell(
    onTap: () {},
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 13),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: const Color.fromARGB(255, 255, 255, 255).withAlpha(100),
                offset: const Offset(2, 4),
                blurRadius: 8,
                spreadRadius: 2)
          ],
          color: const Color.fromARGB(255, 236, 153, 29)),
      child: const Text(
        'Save',
        style:
            TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)),
      ),
    ),
  );
}

class EditInfoPage extends StatefulWidget {
  const EditInfoPage({Key? key}) : super(key: key);

  @override
  State<EditInfoPage> createState() => _EditInfoPageState();
}

class _EditInfoPageState extends State<EditInfoPage> {
  final userIdController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final _avtController = TextEditingController();
  final addressController = TextEditingController();
  final walletController = TextEditingController();
  String _imageLink = "";
  late FToast fToast;
  User? user;
  TextInputFormatter getInputFormatter(bool isNumericKeyBoard) {
    if (isNumericKeyBoard) {
      return FilteringTextInputFormatter.allow(RegExp('[0-9 ]'));
    } else {
      return FilteringTextInputFormatter.allow(
          RegExp('[^"\']*[^\'\"`]', unicode: true));
    }
  }

  void initPreferences() async {
    SharedPreferences pref;
    pref = await SharedPreferences.getInstance();
    setState(() {
      if (pref.getString("user") != null) {
        user = User.fromJson(jsonDecode(pref.getString("user")!));
        userIdController.text = user!.id.toString();
        nameController.text = user!.name!;
        ageController.text = user!.age.toString();
        addressController.text = user!.address!;
        _avtController.text = user!.avatar!;
        walletController.text = "0";
      }
    });
    // print(user);
    // print(user?.id);
  }

  void _saveData() async {
    try {
      await DatabaseHelper.updateAllById(
          int.parse(userIdController.text),
          nameController.text,
          ageController.text,
          addressController.text,
          _avtController.text);
      await DatabaseHelper.recharge(
          int.parse(userIdController.text), int.parse(walletController.text));
      fToast.showToast(
        child: const Text('Edit Profile Successfully !!',
            style: TextStyle(
              color: Colors.white,
            )),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 3),
      );
    } catch (e) {
      print(e);
      fToast.showToast(
        child: const Text('Edit Profile Error !!',
            style: TextStyle(
              color: Colors.white,
            )),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 5),
      );
    }
  }

  Future<void> _getImageLink() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageLink = pickedFile.path
            .replaceFirst("E:\\Project_Flutter\\mkb_technology\\", "");
        _imageLink = _imageLink.replaceAll("\\", "/");
        _avtController.text = _imageLink;
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

  @override
  void initState() {
    initPreferences();
    super.initState();
    // print("abcL: ");
    print(user?.id);
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    userIdController.dispose();
    addressController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: Responsive.isDesktop(context)
            ? EdgeInsets.only(right: 200, left: 10)
            : EdgeInsets.only(right: 20, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text("ID User: ",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.end),
                  ),
                  Expanded(
                    flex: 8,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      enabled: false,
                      style: const TextStyle(color: Colors.black),
                      controller: userIdController,
                      inputFormatters: [getInputFormatter(false)],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red, // Màu sắc của đường viền
                              width: 2.0, // Độ dày của đường viền
                            ),
                          ),
                          hintText: 'User ID'),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text("User Name: ",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.end),
                  ),
                  Expanded(
                    flex: 8,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black),
                      controller: nameController,
                      inputFormatters: [getInputFormatter(false)],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red, // Màu sắc của đường viền
                              width: 2.0, // Độ dày của đường viền
                            ),
                          ),
                          hintText: 'User Name'),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text("Age: ",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.end),
                  ),
                  Expanded(
                    flex: 8,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black),
                      controller: ageController,
                      inputFormatters: [getInputFormatter(true)],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red, // Màu sắc của đường viền
                              width: 2.0, // Độ dày của đường viền
                            ),
                          ),
                          hintText: 'Age'),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text("Address: ",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.end),
                  ),
                  Expanded(
                    flex: 8,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black),
                      controller: addressController,
                      inputFormatters: [getInputFormatter(false)],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red, // Màu sắc của đường viền
                              width: 2.0, // Độ dày của đường viền
                            ),
                          ),
                          hintText: 'Address'),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text("Avatar: ",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.end),
                  ),
                  Expanded(
                    flex: 8,
                    child: TextFormField(
                      enabled: false,
                      controller: _avtController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.amber),
                      inputFormatters: [getInputFormatter(false)],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            //color: Colors.red, // Màu sắc của đường viền
                            width: 2.0, // Độ dày của đường viền
                          ),
                        ),
                        labelText: 'Avatar',
                        hintText: 'Avatar',
                        fillColor: Color.fromARGB(255, 255, 20, 20),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              inputImage(),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text("Wallet: ",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.end),
                  ),
                  Expanded(
                    flex: 8,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black),
                      controller: walletController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red, // Màu sắc của đường viền
                              width: 2.0, // Độ dày của đường viền
                            ),
                          ),
                          hintText: 'Amount you want to recharge',
                          hintStyle: TextStyle(color: Color(0xFFADACA8))),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  onPressed: () {
                    try {
                      _saveData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Update successfully !!!'),
                        ),
                      );
                      // Nếu không có lỗi xảy ra, tiến hành các thao tác khác
                    } catch (e) {
                      // Xử lý lỗi khi chuỗi khi lỗi
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Update error !!!'),
                        ),
                      );
                      print('Lỗi: ${e.toString()}');
                    }
                  },
                  child: const Text('Save')),
              const SizedBox(
                height: 16,
              ),
            ]),
          ],
        ),
      )),
    );
  }
}
