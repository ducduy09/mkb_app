// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert'; //to convert json to maps and vice versa
import 'package:path_provider/path_provider.dart'; //add path provider dart plugin on pubspec.yaml file

class AddJsonData extends StatefulWidget {
  const AddJsonData({super.key});

  @override
  State createState() => AddJsonDataState();
}

class AddJsonDataState extends State<AddJsonData> {
  TextEditingController codeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController idMfrPartController = TextEditingController();
  TextEditingController mfrPartNameController = TextEditingController();
  TextEditingController idBrandController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController idMkbPartController = TextEditingController();

  late File jsonFile;
  late Directory dir;
  String fileName = "data.json";
  bool fileExists = false;
  List<dynamic> listData = [];
  Map<String, dynamic>? fileContent;

  @override
  void initState() {
    super.initState();
    /*to store files temporary we use getTemporaryDirectory() but we need
    permanent storage so we use getApplicationDocumentsDirectory() */
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File("${dir.path}/$fileName");
      fileExists = jsonFile.existsSync();
      if (fileExists) {
        setState(() => listData = jsonDecode(jsonFile.readAsStringSync()));
      }
    });
  }

  @override
  void dispose() {
    codeController.dispose();
    quantityController.dispose();
    idMfrPartController.dispose();
    mfrPartNameController.dispose();
    idBrandController.dispose();
    brandNameController.dispose();
    descriptionController.dispose();
    idMkbPartController.dispose();
    super.dispose();
  }

  void createFile(
      List<Map<String, dynamic>> content, Directory dir, String fileName) {
    print("Creating file!");
    File file = File("${dir.path}/$fileName");
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(jsonEncode(content));
  }

  void writeToFile(int code, int quantity, int idMfrPart, String mfrPartName,
      int idBrand, String brandName, String description, int idMkbPart) {
    print("Writing to file!");
    Map<String, dynamic> content = {
      'code': code,
      'quantity': quantity,
      'idMfrPart': idMfrPart,
      'mfrPartName': mfrPartName,
      'idBrand': idBrand,
      'brandName': brandName,
      'description': description,
      'idMkbPart': idMkbPart
    };
    if (fileExists) {
      print("File exists");
      dynamic jsonFileContent = jsonDecode(jsonFile.readAsStringSync());

      jsonFileContent.add(content);
      jsonFile.writeAsStringSync(jsonEncode(jsonFileContent));
      print(jsonFileContent.runtimeType);
    } else {
      List<Map<String, dynamic>> jsonFileContent = [];
      jsonFileContent.add(content);
      print("File does not exist!");
      createFile(jsonFileContent, dir, fileName);
    }
    setState(() => listData = jsonDecode(jsonFile.readAsStringSync()));
    print(fileContent);
  }

  TextInputFormatter getInputFormatter(bool isNumericKeyBoard) {
    if (isNumericKeyBoard) {
      return FilteringTextInputFormatter.allow(RegExp('[0-9 ]'));
    } else {
      return FilteringTextInputFormatter.allow(
          RegExp('[^"\']*[^\'\"`]', unicode: true));
    }
  }

  Widget buildTextField(String labelText, String placeholder, bool readonly,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: TextField(
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
        ),
        controller: controller,
        inputFormatters: [getInputFormatter(false)],
        decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                //color: Colors.red, // Màu sắc của đường viền
                width: 2.0, // Độ dày của đường viền
              ),
            ),
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            labelStyle: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            //floatingLabelBehavior: FloatingLabelBehavior.always,
            //hintText: placeholder,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 199, 123),
      appBar: AppBar(
        title: const Text('Add Transaction',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        leading: Builder(
            builder: (context) => IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ))),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            const Text(
              "File content: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // Text(fileContent.toString()),
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            const Text("Add to JSON file: "),
            SizedBox(
              child: Column(
                children: [
                  buildTextField("code", "code", false, codeController),
                  const SizedBox(
                    height: 20,
                  ),
                  buildTextField(
                      "quantity", "quantity", false, quantityController),
                  const SizedBox(
                    height: 20,
                  ),
                  buildTextField(
                      "idMfrPart", "idMfrPart", false, idMfrPartController),
                  const SizedBox(
                    height: 20,
                  ),
                  buildTextField("mfrPartName", "mfrPartName", false,
                      mfrPartNameController),
                  const SizedBox(
                    height: 20,
                  ),
                  buildTextField(
                      "idBrand", "idBrand", false, idBrandController),
                  const SizedBox(
                    height: 20,
                  ),
                  buildTextField(
                      "brandName", "brandName", false, brandNameController),
                  const SizedBox(
                    height: 20,
                  ),
                  buildTextField("description", "description", false,
                      descriptionController),
                  const SizedBox(
                    height: 20,
                  ),
                  buildTextField(
                      "idMkbPart", "idMkbPart", false, idMkbPartController),
                  // SizedBox(
                  //   height: 20,
                  // ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            ElevatedButton(
                child: const Text("Add key, value pair"),
                onPressed: () {
                  if (codeController.text.isNotEmpty &&
                      idMfrPartController.text.isNotEmpty &&
                      idMkbPartController.text.isNotEmpty) {
                    writeToFile(
                        int.parse(codeController.text),
                        int.parse(quantityController.text),
                        int.parse(idMfrPartController.text),
                        mfrPartNameController.text,
                        int.parse(idBrandController.text),
                        brandNameController.text,
                        descriptionController.text,
                        int.parse(idMkbPartController.text));
                  }
                }),
            SizedBox(
              width: 500,
              height: 200,
              child: ListView.builder(
                itemCount: listData.isEmpty ? 0 : listData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Text(listData[index]['mfrPartName'] ?? ""),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
