// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mkb_technology/view/user/product/product_details.dart';
import 'about_us.dart';
import 'product/products.dart';
import '../auth/loginPage.dart';
import '../../main.dart';
//Hàm tạo ô bán sản phẩm
//List<Map<String, dynamic>> dataList = [];
ConstrainedBox list_product(String linkProduct, BuildContext context, int check, int id, List<Map<String, dynamic>> dataList) {
  //dataList = context.watch<ListData>().dataProduct;
  return ConstrainedBox(
    constraints: const BoxConstraints(
      maxHeight: 285, 
      minHeight: 55,
      maxWidth: 200,
      minWidth: 20
    ), child: Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 20),
        child: Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
              ), child: Image.asset(linkProduct),
            ),
            TextButton(
              onPressed: (){
                if(check == 0) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                } 
                if(check == 1) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(data: dataList, id: id-1,)));
                }
              }, 
              child: const Column(
                children: [
                  Text('Sản phẩm uy tín chất lượng cao\n', textAlign: TextAlign.center,),
                  Text('100.000 VND')
            ],)
            ),
          ],
        )
    )
  );
}
Container containerProduct(String linkImage){
  return Container(
  //width: MediaQuery.of(context).size.width * 0.45,
  decoration: BoxDecoration(
    boxShadow: const [
      BoxShadow(
        blurRadius: 4,
        color: Color(0x3600000F),
        offset: Offset(0, 2),
      )
    ],
    borderRadius: BorderRadius.circular(8),
  ),
  child: Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Image.network(
                  linkImage,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 4, 0, 0),
                child: Text(
                  'Sản phẩm uy tín chất lượng cao',
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 4, 0, 0),
                child: Text(
                  '100.000 VND',
                 // '\$${product.price}',
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);
}

ConstrainedBox listProduct(String linkProduct, BuildContext context, int check, int id, List<Map<String, dynamic>> dataList) {
  //dataList = context.watch<ListData>().dataProduct;
  return ConstrainedBox(
    constraints: const BoxConstraints(
      maxHeight: 285, 
      minHeight: 55,
      maxWidth: 150,
      minWidth: 30
    ), child: Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 0, 94, 255))
      ),
        child: Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
              ), child: Image.network(linkProduct),
            ),
            TextButton(
              onPressed: (){
                if(check == 0) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                } 
                if(check == 1) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(data: dataList, id: id,)));
                }   
              }, 
              child: const Column(
                children: [
                  Text('Sản phẩm uy tín chất lượng cao\n', textAlign: TextAlign.center,),
                  Text('100.000 VND')
            ],)
            ),
          ],
        )
    )
  );
}
// tạo menu
Row menuTop(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TextButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));  
        },
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 51, 122, 245)),
                ),
        child: const Text('HOME'),
      ),
      TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductPage()));  
          },
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 51, 122, 245)),
                  ),
          child: const Text('PRODUCTS'),
      ),
      TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsPage()));  
          },
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 51, 122, 245)),
              padding:
                  MaterialStateProperty.all(const EdgeInsets.all(20))
                  ),
          child: const Text('ABOUT US'),
      ),
    ],

  );
}

  //Hàm tạo Grid View
    // GridView(
    //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //       crossAxisCount: 6, // gioi han anh theo so luong cot
    //       crossAxisSpacing: 10, //gian cach theo chieu tren xuong duoi
    //       mainAxisSpacing: 10
    //     ),
    //     //scrollDirection: Axis.horizontal, // Cuon theo chieu ngang. Mac dinh la doc
    //     children: [
    //       for(int i = 1; i < 7; i ++)
    //       list_product('assets/images/product_$i.jpg'),
    //     ],
    //   ),

//Hàm tạo box shadow
// Container(
//   margin: const EdgeInsets.only(top: 20),
//   child:  Row(
//     children: <Widget>[
//       Expanded(
//         flex: 4, // 60%
//         child: Container(
//           height: 220.0,
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.deepPurple,
//                 blurRadius: 20.0, // Soften the shaodw
//                 spreadRadius: 2.0,
//                 offset: Offset(0.0, 0.0),
//               )
//             ],
//           ),
//           child: FittedBox(
//                   fit: BoxFit.fill,
//                   child: Image.asset('assets/images/banner.jpg'),
//                 ),
//         ),
//       ),
//       Expanded(
//         flex: 6, // 20%
//         child:  Container(
//           height: 220.0,
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             color: Color.fromARGB(255, 32, 122, 224),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.deepPurple,
//                 blurRadius: 20.0, // Soften the shaodw
//                 spreadRadius: 2.0,
//                 offset: Offset(0.0, 0.0),
//               )
//             ],
//           ),
//           child: const Text('data', style: TextStyle(color: Colors.white),)
//         ),
//       ),
//     ],
//   ),
// ),

// Ham dem so lan nhan
// Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Column(
//         children: [
//           const Text(
//             'You have pushed the button this many times:',
//           ),
//           Text(
//             '$_counter',
//             style: Theme.of(context).textTheme.headlineMedium,
//           ),
//         ],
//       )
//     ],
//   ),
double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

Transform stylepadding() {
    return Transform.translate(
      offset: const Offset(0, -10),
      child: const Padding(
        padding: EdgeInsets.only(top: 10),
       // child: YourChildWidget(),
      ),
    );
  }