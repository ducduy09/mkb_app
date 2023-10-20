
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ListJson{
  int? code;
  int? quantity;
  int? idMfrPart;
  String? mfrPartName;
  int? idBrand;
  String? brandName;
  String? description;
  int? idMkbPart;
  ListJson({
      this.code,
      this.quantity,
      this.idMfrPart,
      this.mfrPartName,
      this.idBrand,
      this.brandName,
      this.description,
      this.idMkbPart});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['quantity'] = quantity;
    data['idMfrPart'] = idMfrPart;
    data['mfrPartName'] = mfrPartName;
    data['idBrand'] = idBrand;
    data['brandName'] = brandName;
    data['description'] = description;
    data['idMkbPart'] = idMkbPart;
    return data;
  }

  ListJson.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        quantity = json['quantity'],
        idMfrPart = json['idMfrPart'],
        mfrPartName = json['mfrPartName'],
        idBrand = json['idBrand'],
        brandName = json['brandName'],
        description = json['description'],
        idMkbPart = json['idMkbPart'];
  DataGridRow getDataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell<int>(columnName: 'code', value: code),
      DataGridCell<int>(columnName: 'quantity', value: quantity ?? 0),
      DataGridCell<int>(columnName: 'idMfrPart', value: idMfrPart ?? 0),
      DataGridCell<String>(columnName: 'mfrPartName', value: mfrPartName ?? " "),
      DataGridCell<int>(columnName: 'idBrand', value: idBrand ?? 0),
      DataGridCell<String>(columnName: 'brandName', value: brandName ?? ""),
      DataGridCell<String>(columnName: 'description', value: description ?? ""),
      DataGridCell<int>(columnName: 'idMkbPart', value: idMkbPart ?? 0),
    ]);
  }
}
