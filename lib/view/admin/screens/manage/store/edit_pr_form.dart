// ignore_for_file: prefer_const_constructors, must_be_immutable, avoid_print
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mkb_technology/helper/products.dart';
// import 'package:mkb_technology/view/admin/screens/manage/store/list_product.dart';
// import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  final List<Map> data;
  final int id;

  const EditProduct({Key? key, required this.data, required this.id})
      : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final idController = TextEditingController();
  final saleController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final prSaleController = TextEditingController();
  final quantityController = TextEditingController();
  final imageController = TextEditingController();
  String _imageLink = "";
  @override
  void initState() {
    super.initState();
    idController.text = widget.data[widget.id]["productId"];
    nameController.text = widget.data[widget.id]["productName"];
    priceController.text = widget.data[widget.id]["price"].toString();
    saleController.text = widget.data[widget.id]["sale"];
    quantityController.text = widget.data[widget.id]["quantity"].toString();
    prSaleController.text = widget.data[widget.id]["prSale"].toString();
    imageController.text = widget.data[widget.id]["productImage"];
  }

  void _saveData() async {
    final productId = idController.text;
    final productName = nameController.text;
    final price = int.parse(priceController.text);
    final sale = saleController.text;
    final productImage = imageController.text;
    final prSale = int.parse(prSaleController.text);
    final quantity = int.parse(quantityController.text);

    int insertId = await ProductHelper.updateAllById(
        productId, productName, productImage, price, quantity, sale, prSale);
    // // ignore: avoid_print
    // List<Map<String, dynamic>> updateData =  await ProductHelper.getData();
    // setState(() {
    //   widget.data = updateData;
    // });
    print(insertId);
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    priceController.dispose();
    saleController.dispose();
    quantityController.dispose();
    prSaleController.dispose();
    imageController.dispose();
    super.dispose();
  }

  Future<void> _getImageLink() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageLink = pickedFile.path
            .replaceFirst("E:\\Project_Flutter\\mkb_technology\\", "");
        _imageLink = _imageLink.replaceAll("\\", "/");
        imageController.text = _imageLink;
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

  Widget buildTextField(String labelText, String placeholder,
      bool readonly, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: TextField(
        enabled: readonly,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.amber),
        controller: controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                //color: Colors.red, // Màu sắc của đường viền
                width: 2.0, // Độ dày của đường viền
              ),
            ),
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            //floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.badge_outlined,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
        title: const Text('Edit Product')
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .35,
            padding: const EdgeInsets.only(bottom: 30),
            width: double.infinity,
            child: Image.asset(widget.data[widget.id]["productImage"]),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40, right: 14, left: 14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sửa TT Sản phẩm',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: const Color.fromARGB(255, 255, 0, 0),
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              buildTextField("Product ID", "Product ID", false,
                                  idController),
                              buildTextField("Product Name", "Product Name",
                                  true, nameController),
                              buildTextField("Product Image", "Product Image",
                                  true, imageController),
                              inputImage(),
                              const SizedBox(
                                height: 16,
                              ),
                              buildTextField(
                                  "Price", "Price", true, priceController),
                              buildTextField("Quantity", "Quantity", true,
                                  quantityController),
                              buildTextField("Product Sale", "Product Sale",
                                  true, saleController),
                              buildTextField("Product prSale", "Product prSale",
                                  true, prSaleController),
                              // TextFormField(
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(
                              //     color: Colors.black,
                              //   ),
                              //   controller: idController,
                              //   decoration: const InputDecoration(
                              //       border: OutlineInputBorder(
                              //         borderSide: BorderSide(
                              //           color: Colors
                              //               .red, // Màu sắc của đường viền
                              //           width: 2.0, // Độ dày của đường viền
                              //         ),
                              //       ),
                              //       hintText: 'Product ID'),
                              // ),
                              // TextFormField(
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(color: Colors.black),
                              //   controller: nameController,
                              //   decoration: const InputDecoration(
                              //       border: OutlineInputBorder(
                              //         borderSide: BorderSide(
                              //           color: Colors
                              //               .red, // Màu sắc của đường viền
                              //           width: 2.0, // Độ dày của đường viền
                              //         ),
                              //       ),
                              //       hintText: 'Product Name'),
                              // ),
                              // TextFormField(
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(color: Colors.black),
                              //   enabled: false,
                              //   controller: imageController,
                              //   decoration: const InputDecoration(
                              //       border: OutlineInputBorder(
                              //         borderSide: BorderSide(
                              //           color: Colors
                              //               .red, // Màu sắc của đường viền
                              //           width: 2.0, // Độ dày của đường viền
                              //         ),
                              //       ),
                              //       hintText: 'Product Image'),
                              // ),
                              // inputImage(),
                              // TextFormField(
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(color: Colors.black),
                              //   controller: priceController,
                              //   decoration: const InputDecoration(
                              //       border: OutlineInputBorder(
                              //         borderSide: BorderSide(
                              //           color: Colors
                              //               .red, // Màu sắc của đường viền
                              //           width: 2.0, // Độ dày của đường viền
                              //         ),
                              //       ),
                              //       hintText: 'Price'),
                              // ),
                              // TextFormField(
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(color: Colors.black),
                              //   controller: quantityController,
                              //   decoration: const InputDecoration(
                              //       border: OutlineInputBorder(
                              //         borderSide: BorderSide(
                              //           color: Colors
                              //               .red, // Màu sắc của đường viền
                              //           width: 2.0, // Độ dày của đường viền
                              //         ),
                              //       ),
                              //       hintText: 'Quantity'),
                              // ),
                              // TextFormField(
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(color: Colors.black),
                              //   controller: saleController,
                              //   decoration: const InputDecoration(
                              //       border: OutlineInputBorder(
                              //         borderSide: BorderSide(
                              //           color: Colors
                              //               .red, // Màu sắc của đường viền
                              //           width: 2.0, // Độ dày của đường viền
                              //         ),
                              //       ),
                              //       hintText: 'Product Sale'),
                              // ),
                              // TextFormField(
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(color: Colors.black),
                              //   controller: prSaleController,
                              //   decoration: const InputDecoration(
                              //       border: OutlineInputBorder(
                              //         borderSide: BorderSide(
                              //           color: Colors
                              //               .red, // Màu sắc của đường viền
                              //           width: 2.0, // Độ dày của đường viền
                              //         ),
                              //       ),
                              //       hintText: 'Product prSale'),
                              // ),
                              const SizedBox(
                                height: 16,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    try {
                                      _saveData();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Update successfully !!!'),
                                        ),
                                      );
                                      // Nếu không có lỗi xảy ra, tiến hành các thao tác khác
                                    } catch (e) {
                                      // Xử lý lỗi khi chuỗi khi lỗi
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                    // ],),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
