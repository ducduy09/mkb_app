// ignore_for_file: prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mkb_technology/view/user/payment/pay_screen.dart';

class ProductDetail extends StatefulWidget {
  final List<Map> data;
  final int id;
  const ProductDetail({Key? key, required this.data, required this.id})
      : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    // List<Map<String, dynamic>> dataList = context.watch<ListDataDetail>().dataProduct;
    print("object");
    print(widget.data[widget.id]);
    print("ID: ");
    print(widget.id);
    print(widget.data[widget.id]['productName']);
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.kBgColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.badge_outlined,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          alignment: Alignment.center,
          // width: Responsive.isDesktop(context)
          //     ? 1300
          //     : MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .35,
                padding: const EdgeInsets.only(bottom: 30),
                width: double.infinity,
                child: Image.asset(widget.data[widget.id]["productImage"]),
              ),
              Text(
                widget.data[widget.id]["productName"],
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Price: ${widget.data[widget.id]["price"]} VND",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque auctor consectetur tortor vitae interdum.',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              widget.data[widget.id]["quantity"] > 0
                  ? Text(
                      'In Stocks: ${widget.data[widget.id]["quantity"]}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Text(
                      'Out Stocks',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              const SizedBox(height: 10),
            ],
          ),
        )),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(
              //padding: const EdgeInsets.only(top: 20),
              height: 50,
              color: Color.fromARGB(255, 224, 158, 33),
              child: Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(
                                    data: widget.data,
                                    id: widget.id,
                                    choose: 1),
                              ));
                        },
                        child: Text(
                          'Add to cart',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  Expanded(
                      flex: 5,
                      child: TextButton(
                        onPressed: () {
                          widget.data[widget.id]["quantity"] > 0
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentScreen(
                                      data: widget.data,
                                      id: widget.id,
                                      choose: 0,
                                    ),
                                  ))
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('The product is out of stock, please come back later !!!'),
                                  ),
                                );
                        },
                        child: Text(
                          'Buy with coupon',
                          style: TextStyle(color: Colors.white),
                        ),
                      ))
                ],
              )),
        ));
  }
}
