import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Products {
  late String productId;
  late String productName;
  late String productImage;
  late int price;
  int quantity; // số lượng hàng được đặt còn lại
  late String sale;
  late int? prSale;
  late int? quantityTemp; // số lượng hàng còn lại trong kho
  int status;
  //final String warehourseCode;

  Products({
      required this.productId, 
      required this.productName, 
      required this.productImage, 
      required this.price, 
      this.quantity = 0,
      this.sale = "0%",
      this.prSale,
      this.quantityTemp = 0,
      this.status = 0
      //required this.warehourseCode,
  });

  Products.fromMap(Map<String, dynamic> res)
      : productId = res["productId"],
        productName = res["productName"],
        productImage = res["productImage"],
        price = res["price"],
        quantity = res["quantity"],
        sale = res["sale"],
        prSale = res["prSale"],
        quantityTemp = res["quantityTemp"],
        status = res["status"];
      //  warehourseCode = res["warehourseCode"];

  Map<String, dynamic> toMap() {  
    return {  
      'productId': productId,  
      'productName': productName,  
      'productImage': productImage,
      'price': price,  
      'quantity': quantity,
      'sale': sale,  
      'prSale': prSale,
      'quantityTemp': quantityTemp, 
      'status': status,   
      //'warehourseCode': warehourseCode,
    };  
  }  
  DataGridRow getDataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell<String>(columnName: 'productId', value: productId),
      DataGridCell<String>(columnName: 'productName', value: productName),
      DataGridCell<String>(columnName: 'productImage', value: productImage),
      DataGridCell<int>(columnName: 'price', value: price),
      DataGridCell<int>(columnName: 'quantity', value: quantity),
      DataGridCell<String>(columnName: 'sale', value: sale),
      DataGridCell<int>(columnName: 'prSale', value: prSale),
      DataGridCell<int>(columnName: 'quantityTemp', value: quantityTemp),
      DataGridCell<int>(columnName: 'status', value: status),
    ]);
  }
}