class ExclusiveToursModel {
  ExclusiveToursModel({this.id, this.name, this.image});
  int? id;
  String? name;
  String? image;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'image': image,
      };

  static ExclusiveToursModel fromJson(Map<String, dynamic> json) =>
      ExclusiveToursModel(
        id: json['id'] as int,
        name:json['name']==null?'': json['name'] as String,
        image: json['image'] as String,
      );
}
