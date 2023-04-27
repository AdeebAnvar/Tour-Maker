class RazorPayModel {
  RazorPayModel(
      {this.amount,
      this.currency,
      this.name,
      this.email,
      this.contact,
      this.packageId,
      this.orderId});
  int? amount;
  String? currency;
  String? name;
  String? email;
  String? contact;
  String? packageId;
  String? orderId;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'currency': currency,
        'contact': contact,
        'name': name,
      };
  static RazorPayModel fromJson(Map<String, dynamic> json) => RazorPayModel(
        packageId: json['id'] as String,
      );
}

class OrderPaymentModel {
  OrderPaymentModel({this.currency, this.orderId, this.paymentID, this.id});
  String? currency;
  int? orderId;
  String? paymentID;
  String? id;
  static OrderPaymentModel fromJson(Map<String, dynamic> json) =>
      OrderPaymentModel(
        id: json['id'] as String,
        paymentID: json['payment_id'] as String,
      );
  Map<String, dynamic> toJson() => <String, dynamic>{
        'currency': currency,
        'order_id': orderId,
      };
}
