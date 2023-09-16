// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mkb_technology/helper/widget_helper.dart';
// import 'package:file_picker/file_picker.dart';

// List<String> list = <String>['prdA', 'prdB', 'prdC'];

class EditWidget extends StatefulWidget {
  final List<Map> data;
  final int id;
  const EditWidget({Key? key, required this.data, required this.id})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditWidgetState createState() => _EditWidgetState();
}

class _EditWidgetState extends State<EditWidget> {
  late TextEditingController wdIdController = TextEditingController();
  late TextEditingController titleController = TextEditingController();
  late TextEditingController prIdController = TextEditingController();
  late TextEditingController typeController = TextEditingController();
  late TextEditingController contentController = TextEditingController();

  // String? dropdownValue = list.first;
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
              child: const Icon(Icons.keyboard_arrow_left,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ),
            const Text('Back',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFFFFFF)))
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _entryField(String title, String text,
      TextEditingController? Controller, bool? read) {
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
    getDataWidget();
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    wdIdController.dispose();
    prIdController.dispose();
    titleController.dispose();
    typeController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void getDataWidget() {
    wdIdController.text = widget.data[widget.id]["widgetId"];
    prIdController.text = widget.data[widget.id]["productId"];
    titleController.text = widget.data[widget.id]["title"].toString();
    typeController.text = widget.data[widget.id]["type"];
    contentController.text = widget.data[widget.id]["content"].toString();
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        try {
          WidgetHelper.changeContent(contentController.text,
              wdIdController.text, prIdController.text, typeController.text);
          WidgetHelper.changeTitle(titleController.text, wdIdController.text,
              prIdController.text, typeController.text);

          fToast.showToast(
            child: const Text('Edit Widget Successfully !!',
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
        } catch (e) {
          print(e.toString());
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
        _entryField("ID Widget", "ID Widget", wdIdController, false),
        _entryField("Title", "Title", titleController, true),
        _entryField("Product ID", "Product ID", prIdController, false),
        _entryField("Type", "Type", typeController, false),
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
