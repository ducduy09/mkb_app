// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
// import 'package:mkb_technology/models/products.dart';
// import 'package:mkb_technology/helper/products.dart';
import 'package:mkb_technology/view/admin/screens/main/components/side_menu.dart';
import 'package:mkb_technology/view/admin/screens/manage/store/edit_pr_form.dart';
// import 'package:mkb_technology/view/product/product_details.dart';
import 'package:provider/provider.dart';

// class DetailProductState extends ChangeNotifier {
//   dynamic _isId = 0;
//   dynamic get isId => _isId;

//   void setInfoProduct(dynamic value1) {
//     _isId = value1;
//     notifyListeners();
//   }
// }


// ignore: non_constant_identifier_names
InkWell ProductList(BuildContext context, int index, List<Map<String, dynamic>> dataList) {
  return InkWell(
    onTap: () {
      // dynamic ID = ProductHelper.getId(index);
      // context.read<DetailProductState>().setInfoProduct(ID);
      context.read<ListData>().transmissionData(dataList);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => EditProduct(data: dataList, id: index)));
    },
    child: Container(
        margin: const EdgeInsets.all(10),
        //alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(255, 212, 236, 247),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 0, 0, 0),
                // offset: Offset(2, 4),
                blurRadius: 4,
                spreadRadius: 2)
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dataList[index]["sale"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                  const Icon(
                    Icons.favorite_outline,
                    color: Colors.red,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(dataList[index]["productImage"],
                    height: 100, width: 100),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataList[index]["productName"],
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "${dataList[index]["price"]}",
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          dataList[index]["prSale"],
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 13,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )),
  );
}

InkWell productWidgetSaleForPC(
    BuildContext context, int index, List<Map<String, dynamic>> dataList) {
  return InkWell(
    onTap: () {
      // dynamic ID = ProductHelper.getId(index);
      // context.read<DetailProductState>().setInfoProduct(ID);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => EditProduct(data: dataList,id: index)));
    },
    child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width / 4.5,
          //maximum width set to 100% of width
        ),
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(255, 212, 236, 247),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 0, 0, 0),
                // offset: Offset(2, 4),
                blurRadius: 4,
                spreadRadius: 2)
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dataList[index]["sale"],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const Icon(Icons.favorite_outline)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(dataList[index]["productImage"],
                    height: 100, width: 100),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataList[index]["productName"],
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          dataList[index]["price"],
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          dataList[index]["prSale"],
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 13,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )),
  );
}
