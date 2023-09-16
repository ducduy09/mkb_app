// ignore_for_file: non_constant_identifier_names

class Sliders {
  final String slideId;
  final String image_path;

  Sliders({
      required this.slideId, 
      required this.image_path, 
  });

  Sliders.fromMap(Map<String, dynamic> res)
      : slideId = res["slideId"],
        image_path = res["image_path"];

  Map<String, dynamic> toMap() {  
    return {  
      'slideId': slideId,  
      'image_path': image_path, 
    };  
  }  
}