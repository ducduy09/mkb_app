// ignore_for_file: avoid_print, file_names, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:mkb_technology/main.dart';
// import 'package:mkb_technology/view/admin/main.dart';
// import 'package:mkb_technology/view/admin/screens/manage/store/widget.dart';
// import 'package:provider/provider.dart';
import 'package:mkb_technology/helper/products.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mkb_technology/view/admin/screens/manage/store/list_product.dart';
// import 'package:file_picker/file_picker.dart';

List<String> list = <String>['prdA', 'prdB', 'prdC'];

class InsertPrForm extends StatefulWidget {
  const InsertPrForm({Key? key, this.title}) : super(key: key);

  final String? title;
  // static int isAuthenticated = 0;
  @override
  // ignore: library_private_types_in_public_api
  _InsertPrFormState createState() => _InsertPrFormState();
}

class _InsertPrFormState extends State<InsertPrForm> {
  late TextEditingController idController = TextEditingController();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController linkController = TextEditingController();
  late TextEditingController priceController = TextEditingController();
  late TextEditingController quantityController = TextEditingController();
  late TextEditingController saleController = TextEditingController();
  late TextEditingController prSaleController = TextEditingController();
  late TextEditingController codeController = TextEditingController();
  String? dropdownValue = list.first;
  // static String value = "prdA";
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
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ListProduct(),
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: const Icon(Icons.keyboard_arrow_left,
                  color: Color.fromARGB(255, 7, 7, 7)),
            ),
            const Text('Back',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 0, 0, 0)))
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
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 228, 150, 6),
                fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            enabled: read,
            style: const TextStyle(color: Color.fromARGB(255, 228, 150, 6)),
            controller: Controller,
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
        //cho 1 cái combobox để chọn loại sản phẩm -> gán id ++ và cái loại sp ý r ms add
        // try{
        ProductHelper.insertProduct(
            idController.text,
            nameController.text,
            linkController.text,
            int.parse(priceController.text),
            int.parse(quantityController.text),
            saleController.text,
            int.parse(prSaleController.text));
        fToast.showToast(
          child: const Text('Add product successfully !!',
              style: TextStyle(
                color: Colors.white,
              )),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
        idController.text = "";
        nameController.text = "";
        linkController.text = "";
        priceController.text = "";
        quantityController.text = "";
        saleController.text = "";
        prSaleController.text = "";
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

  Widget inputImage() {
    return ElevatedButton(
      onPressed: () {
        _getImageLink();
      },
      child: const Text('Choose Image'),
    );
  }

  String isID = "";
  Future<String> getLastProduct(String id) async {
    List<Map<String, dynamic>> updateData = await ProductHelper.getLastID(id);
    dataList = updateData;
    int? number = 0;
    try {
      print(dataList);
      if (dataList.isEmpty) {
        number = 1;
        print(number);
      } else {
        String id = dataList[0]["productId"];
        String kitu = id.substring(id.length - 4);
        number = int.tryParse(kitu);
        if (number != null) {
          number++;
          print(number);
        } else {
          kitu = id.substring(id.length - 3);
          number = int.tryParse(kitu);
          if (number != null) {
            number++;
            print(number);
          } else {
            kitu = id.substring(id.length - 2);
            number = int.tryParse(kitu);
            if (number != null) {
              number++;
              print("So $number");
            } else {
              kitu = id.substring(id.length - 1);
              number = int.parse(kitu);
              number++;
              print(number);
            }
          }
        }
      }
    } catch (e) {
      // Xử lý ngoại lệ ở đây
      print('Đã xảy ra một ngoại lệ: $e');
    }

    setState(() {
      isID = id + number.toString();
    });
    print("ID test: $isID");
    return isID;
  }

  Widget dropdownButton() {
    return DropdownButton<String>(
      dropdownColor: const Color.fromARGB(255, 224, 218, 208),
      value: dropdownValue,
      icon: const Icon(
        Icons.arrow_downward,
        color: Colors.amber,
      ),
      elevation: 16,
      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        dropdownValue = value;
        print(value);
        getLastProduct(value.toString()).then((value) {
          print("ID: $value");
          idController.text = isID;
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
        _entryField("ID product", "ID product", idController, false),
        dropdownButton(),
        _entryField("Name product", "Name product", nameController, true),
        _entryField("Link Image", "Link Image", linkController, false),
        inputImage(),
        _entryField("Price", "Price", priceController, true),
        _entryField("Quantity", "Quantity", quantityController, true),
        _entryField("Sale", "Sale", saleController, true),
        _entryField(
            "Price After Sale", "Price After Sale", prSaleController, true),
      ],
    );
  }

  String _imageLink = '';
  Future<void> _getImageLink() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageLink = pickedFile.path
            .replaceFirst("E:\\Project_Flutter\\mkb_technology\\", "");
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                      //SizedBox(height: height * .2),
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
