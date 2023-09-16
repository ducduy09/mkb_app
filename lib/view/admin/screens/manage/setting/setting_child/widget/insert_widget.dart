// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mkb_technology/helper/widget_helper.dart';
// import 'package:file_picker/file_picker.dart';

// List<String> list = <String>['prdA', 'prdB', 'prdC'];

class InsertWidget extends StatefulWidget {
  const InsertWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InsertWidgetState createState() => _InsertWidgetState();
}

class _InsertWidgetState extends State<InsertWidget> {
  late TextEditingController wdIdController = TextEditingController();
  late TextEditingController titleController = TextEditingController();
  late TextEditingController prIdController = TextEditingController();
  late TextEditingController typeController = TextEditingController();
  late TextEditingController contentController = TextEditingController();

  // String? dropdownValue = list.first;
  List<Map<String, dynamic>> dataList = [];
  TextInputFormatter getInputFormatter(bool isNumericKeyBoard) {
    if (isNumericKeyBoard) {
      return FilteringTextInputFormatter.allow(RegExp('[0-9 ]'));
    } else {
      return FilteringTextInputFormatter.allow(
          RegExp('[^"\']*[^\'\"`]', unicode: true));
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
              child: const Icon(Icons.keyboard_arrow_left,
                  color: Color(0xFF000000)),
            ),
            const Text('Back',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF000000)))
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _entryField(String title, String text,
      TextEditingController? controller, bool? read) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            enabled: read,
            style: const TextStyle(color: Color.fromARGB(255, 228, 150, 6)),
            controller: controller,
            inputFormatters: [getInputFormatter(false)],
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
        try {} catch (e) {
          print(e.toString());
        }
        WidgetHelper.insertWidget(wdIdController.text, titleController.text,
            prIdController.text, typeController.text, contentController.text);
        fToast.showToast(
          child: const Text('Add Widget Successfully !!',
              style: TextStyle(
                color: Colors.white,
              )),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
        wdIdController.text = "";
        titleController.text = "";
        prIdController.text = "";
        typeController.text = "";
        contentController.text = "";
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
          'SAVE',
          style: TextStyle(
              fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)),
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

  Widget _detailWidget() {
    return Column(
      children: <Widget>[
        _entryField("ID Widget", "EG: wd + index", wdIdController, true),
        _entryField("Title", "Title", titleController, true),
        _entryField(
            "Product ID", "EG: prd + <A/B/C> + index", prIdController, true),
        _entryField("Type", "EG: 1,2,3,...", typeController, true),
        _entryField("Content", "Content", contentController, true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 233, 218),
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
                      _detailWidget(),
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
