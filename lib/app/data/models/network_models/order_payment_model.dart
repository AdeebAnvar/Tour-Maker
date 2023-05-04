class OrderPaymentModel {
  OrderPaymentModel({this.currency, this.orderId, this.paymentID, this.id});
  String? currency;
  int? orderId;
  String? paymentID;
  String? id;
  static OrderPaymentModel fromJson(Map<String, dynamic> json) =>
      OrderPaymentModel(
        id: json['id'] == null ? '' : json['id'] as String,
        paymentID:
            json['payment_id'] == null ? '' : json['payment_id'] as String,
      );
  Map<String, dynamic> toJson() => <String, dynamic>{
        'currency': currency,
        'order_id': orderId,
      };
}
