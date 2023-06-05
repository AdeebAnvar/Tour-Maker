class TravelTypesModel {
  TravelTypesModel({this.id, this.name, this.image});
  int? id;
  String? name;
  String? image;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'image': image,
      };

  static TravelTypesModel fromJson(Map<String, dynamic> json) =>
      TravelTypesModel(
        id: json['id'] as int,
        name: json['name'] == null ? '' : json['name'] as String,
        image: json['image'] == null ? '' : json['image'] as String,
      );
}
