import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:core';

class IndexTasks {
  late String taskId;
  late String taskName;
  late int userId;
  late String note;
  String? createTime = DateTime.now().toString();
  int status;
  //final String warehourseCode;
  IndexTasks({
      required this.taskId, 
      required this.userId, 
      required this.taskName, 
      required this.note, 
      this.createTime,
      this.status = 0
      //required this.warehourseCode,
  });

  IndexTasks.fromMap(Map<String, dynamic> res)
      : taskId = res["taskId"],
        userId = res["userId"],
        taskName = res["taskName"],
        note = res["note"],
        createTime = res["createTime"],
        status = res["status"];
      //  warehourseCode = res["warehourseCode"];

  Map<String, dynamic> toMap() {  
    return {  
      'taskId': taskId,  
      'userId': userId,  
      'taskName': taskName,
      'note': note,  
      'createTime': createTime,
      'status': status,   
      //'warehourseCode': warehourseCode,
    };  
  }  
  DataGridRow getDataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell<String>(columnName: 'taskId', value: taskId),
      DataGridCell<int>(columnName: 'userId', value: userId),
      DataGridCell<String>(columnName: 'taskName', value: taskName),
      DataGridCell<String>(columnName: 'note', value: note),
      DataGridCell<String>(columnName: 'createTime', value: createTime),
      DataGridCell<int>(columnName: 'status', value: status),
    ]);
  }
}