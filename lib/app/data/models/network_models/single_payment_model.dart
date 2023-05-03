class SinglePaymentModel {
  SinglePaymentModel(
      {this.amountPaid,
      this.createdAt,
      this.customTourId,
      this.dateOfTravel,
      this.gst,
      this.gstAmount,
      this.id,
      this.isCustom,
      this.noOfAdults,
      this.noOfKids,
      this.offerApplied,
      this.orderConfirmed,
      this.orderDate,
      this.orderId,
      this.orderStatus,
      this.packageId,
      this.payableAmount,
      this.paymentStatus,
      this.reward,
      this.totalAmount,
      this.tourCode,
      this.tourName,
      this.userId});
  num? amountPaid;
  String? createdAt;
  int? customTourId;
  String? dateOfTravel;
  int? gst;
  num? gstAmount;
  int? id;
  bool? isCustom;
  int? noOfAdults;
  int? noOfKids;
  bool? offerApplied;
  String? orderConfirmed;
  String? orderDate;
  int? orderId;
  String? orderStatus;
  int? packageId;
  num? payableAmount;
  String? paymentStatus;
  num? reward;
  num? totalAmount;
  String? tourCode;
  String? tourName;
  String? userId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'amount_paid': amountPaid,
        'created_at': createdAt,
        'custom_tour_id': customTourId,
        'date_of_travel': dateOfTravel,
        'gst': gst,
        'gst_amount': gstAmount,
        'id': id,
        'is_custom': isCustom,
        'no_of_adults': noOfAdults,
        'no_of_kids': noOfKids,
        'offer_applied': offerApplied,
        'order_confirmed': orderConfirmed,
        'order_date': orderDate,
        'order_id': orderId,
        'order_status': orderStatus,
        'package_id': packageId,
        'payable_amount': payableAmount,
        'payment_status': paymentStatus,
        'reward': reward,
        'total_amount': totalAmount,
        'tour_code': tourCode,
        'tour_name': tourName,
        'user_id': userId,
      };

  static SinglePaymentModel fromJson(Map<String, dynamic> json) =>
      SinglePaymentModel(
        amountPaid:
            json['amount_paid'] == null ? 0 : json['amount_paid'] as num,
        createdAt:
            json['created_at'] == null ? '' : json['created_at'] as String,
        customTourId:
            json['custom_tour_id'] == null ? 0 : json['custom_tour_id'] as int,
        dateOfTravel: json['date_of_travel'] == null
            ? ''
            : json['date_of_travel'] as String,
        gst: json['gst'] == null ? 0 : json['gst'] as int,
        gstAmount: json['gst_amount'] == null ? 0 : json['gst_amount'] as num,
        id: json['id'] as int,
        isCustom: json['is_custom'] as bool,
        noOfAdults:
            json['no_of_adults'] == null ? 0 : json['no_of_adults'] as int,
        noOfKids: json['no_of_kids'] == null ? 0 : json['no_of_kids'] as int,
        offerApplied: json['offer_applied'] as bool,
        orderConfirmed: json['order_confirmed'] == null
            ? ''
            : json['order_confirmed'] as String,
        orderDate:
            json['order_date'] == null ? '' : json['order_date'] as String,
        orderId: json['order_id'] as int,
        orderStatus:
            json['order_status'] == null ? '' : json['order_status'] as String,
        packageId: json['package_id'] as int,
        payableAmount:
            json['payable_amount'] == null ? 0 : json['payable_amount'] as num,
        paymentStatus: json['payment_status'] == null
            ? ''
            : json['payment_status'] as String,
        reward: json['reward'] == null ? 0 : json['reward'] as num,
        totalAmount:
            json['total_amount'] == null ? 0 : json['total_amount'] as num,
        tourCode: json['tour_code'] == null ? '' : json['tour_code'] as String,
        tourName: json['tour_name'] == null ? '' : json['tour_name'] as String,
        userId: json['user_id'] as String,
      );
}
