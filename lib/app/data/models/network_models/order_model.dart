class OrderModel {
  OrderModel({
    this.noOfChildren,
    this.noOfAdults,
    this.packageID,
    this.orderID,
  });
  int? noOfChildren;
  int? noOfAdults;
  int? packageID;
  String? orderID;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'no_of_kids': noOfChildren,
        'no_of_adults': noOfAdults,
        'package_id': packageID,
      };
  static OrderModel fromJson(Map<String, dynamic> json) => OrderModel(
        orderID: json['ordr_id'] == null ? '' : json['ordr_id'] as String,
      );
}
