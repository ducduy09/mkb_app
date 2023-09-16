// ignore_for_file: avoid_print, file_names, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mkb_technology/helper/products.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mkb_technology/helper/sliderHelper.dart';
  
class InsertSlider extends StatefulWidget {
  const InsertSlider({Key? key, this.title}) : super(key: key);

  final String? title;
  @override
  // ignore: library_private_types_in_public_api
  _InsertSliderState createState() => _InsertSliderState();
}

class _InsertSliderState extends State<InsertSlider> {

  late TextEditingController linkController = TextEditingController();
  List<Map<String, dynamic>> dataList = [];

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
              child: const Icon(Icons.keyboard_arrow_left, color: Color.fromARGB(255, 255, 255, 255)),
            ),
            const Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFFFFFFFF)))
          ],
        ),
      ),
    );
  }
  // ignore: non_constant_identifier_names
  Widget _entryField(String title, String text,TextEditingController? Controller, bool? read) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          enabled: read,
          style: const TextStyle(color: Color.fromARGB(255, 228, 150, 6)), 
          controller: Controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            filled: true,
            hintText: text,
            fillColor: const Color.fromARGB(255, 202, 202, 202),
          ),
        ),
      ],
    ),
  );
}
  late FToast fToast;
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }
  Widget _submitButton() {
    return InkWell(
      onTap: () {
        SliderHelper.insertSlide(linkController.text);
          fToast.showToast(
            child: const Text('Add slide successfully !!', style: TextStyle( color: Colors.white,)),
            gravity: ToastGravity.BOTTOM,
            toastDuration: const Duration(seconds: 2),
          );
            linkController.text = ""; 
      },
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
          'SAVE',
          style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
  }
  Widget inputImage(){
    return ElevatedButton(
      onPressed: () {
        _getImageLink();
      },
      child: const Text('Choose Image'),
    );
  }
  void getLastProduct(String id) async{
    List<Map<String, dynamic>> updateData =  await ProductHelper.getLastID(id);
    setState(() {
      dataList = updateData;
    });
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

  Widget _detailProductWidget() {
    return Column(
      children: <Widget>[
        _entryField("Link Image","Link Image", linkController, false),
        inputImage(),
      ],
    );
  }
String _imageLink = '';
Future<void> _getImageLink() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _imageLink = pickedFile.path.replaceFirst("E:\\Project_Flutter\\mkb_technology\\", "");
        _imageLink = _imageLink.replaceAll("\\", "/");
        linkController.text = _imageLink;
        //_imageLink = pickedFile.path
        //int index = _imageLink.indexOf("mkb_technology\\");
        //String result = _imageLink[index + 1];
        //linkController.text = _imageLink;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF212332),
        body: SizedBox(
      height: height,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _title(),
                  const SizedBox(height: 50),
                  _detailProductWidget(),
                  const SizedBox(height: 20),
                  _submitButton(),
                  SizedBox(height: height * .055),
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
