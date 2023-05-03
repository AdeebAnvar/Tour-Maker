// ignore_for_file: avoid_bool_literals_in_conditional_expressions

class PaymentModel {
  PaymentModel(
      {this.amountPaid,
      this.customTourId,
      this.dateOfTravel,
      this.id,
      this.isCustom,
      this.noOfAdults,
      this.noOfChildren,
      this.offerApplied,
      this.orderConfirmed,
      this.orderDate,
      this.orderId,
      this.orderStatus,
      this.packageId,
      this.payableAmount,
      this.paymentStatus,
      this.totalAmount,
      this.tourName,
      this.userId});
  num? amountPaid;
  int? customTourId;
  String? dateOfTravel;
  int? id;
  bool? isCustom;
  int? noOfAdults;
  int? noOfChildren;
  bool? offerApplied;
  String? orderConfirmed;
  String? orderDate;
  int? orderId;
  String? orderStatus;
  int? packageId;
  num? payableAmount;
  String? paymentStatus;
  num? totalAmount;
  String? tourName;
  String? userId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'amount_paid': amountPaid,
        'custom_tour_id': customTourId,
        'date_of_travel': dateOfTravel,
        'id': id,
        'is_custom': isCustom,
        'no_of_adults': noOfAdults,
        'no_of_children': noOfChildren,
        'offer_applied': offerApplied,
        'order_confirmed': orderConfirmed,
        'order_date': orderDate,
        'order_id': orderId,
        'order_status': orderStatus,
        'package_id': packageId,
        'payable_amount': payableAmount,
        'payment_status': paymentStatus,
        'total_amount': totalAmount,
        'tour_name': tourName,
        'user_id': userId,
      };

  static PaymentModel fromJson(Map<String, dynamic> json) => PaymentModel(
        amountPaid:
            json['amount_paid'] == null ? 0 : json['amount_paid'] as num,
        customTourId:
            json['custom_tour_id'] == null ? 0 : json['custom_tour_id'] as int,
        dateOfTravel: json['date_of_travel'] == null
            ? ''
            : json['date_of_travel'] as String,
        id: json['id'] as int,
        isCustom: json['is_custom'] == null ? false : json['is_custom'] as bool,
        noOfAdults:
            json['no_of_adults'] == null ? 0 : json['no_of_adults'] as int,
        noOfChildren:
            json['no_of_children'] == null ? 0 : json['no_of_children'] as int,
        offerApplied: json['offer_applied'] == null
            ? false
            : json['offer_applied'] as bool,
        orderConfirmed: json['order_confirmed'] == null
            ? ''
            : json['order_confirmed'] as String,
        orderDate:
            json['order_date'] == null ? '' : json['order_date'] as String,
        orderId: json['order_id'] == null ? 0 : json['order_id'] as int,
        orderStatus:
            json['order_status'] == null ? '' : json['order_status'] as String,
        packageId: json['package_id'] as int,
        payableAmount:
            json['payable_amount'] == null ? 0 : json['payable_amount'] as num,
        paymentStatus: json['payment_status'] == null
            ? ''
            : json['payment_status'] as String,
        totalAmount:
            json['total_amount'] == null ? 0 : json['total_amount'] as num,
        tourName: json['tour_name'] == null ? '' : json['tour_name'] as String,
        userId: json['user_id'] as String,
      );
}
