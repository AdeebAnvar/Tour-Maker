class TravellersModel {
  TravellersModel(
      {this.id,
      this.orderId,
      this.userId,
      this.name,
      this.phoneNumber,
      this.dateOfBirth,
      this.address});
  int? id;
  int? orderId;
  String? userId;
  String? name;
  String? phoneNumber;
  String? dateOfBirth;
  String? address;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'order_id': orderId,
        'user_id': userId,
        'name': name,
        'phone_number': phoneNumber,
        'date_of_birth': dateOfBirth,
        'address': address,
      };

  static TravellersModel fromJson(Map<String, dynamic> json) => TravellersModel(
        id: json['id'] as int,
        orderId: json['order_id'] == null ? 0 : json['order_id'] as int,
        userId: json['user_id'] == null ? '' : json['user_id'] as String,
        name: json['name'] == null ? '' : json['name'] as String,
        phoneNumber:
            json['phone_number'] == null ? '' : json['phone_number'] as String,
        dateOfBirth: json['date_of_birth'] == null
            ? ''
            : json['date_of_birth'] as String,
        address: json['address'] == null ? '' : json['address'] as String,
      );
}
