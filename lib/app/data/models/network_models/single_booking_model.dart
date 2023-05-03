// ignore_for_file: avoid_bool_literals_in_conditional_expressions

class SingleBookingModel {
  SingleBookingModel(
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
      this.orderStatus,
      this.packageId,
      this.payableAmount,
      this.reward,
      this.totalAmount,
      this.tourCode,
      this.tourName,
      this.userId});
  String? createdAt;
  num? amountPaid;
  int? customTourId;
  String? dateOfTravel;
  num? gst;
  num? gstAmount;
  int? id;
  bool? isCustom;
  int? noOfAdults;
  int? noOfKids;
  bool? offerApplied;
  String? orderConfirmed;
  String? orderStatus;
  int? packageId;
  num? payableAmount;
  num? reward;
  num? totalAmount;
  String? tourCode;
  String? tourName;
  String? userId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'created_at': createdAt,
        'amount_paid': amountPaid,
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
        'order_status': orderStatus,
        'package_id': packageId,
        'payable_amount': payableAmount,
        'reward': reward,
        'total_amount': totalAmount,
        'tour_code': tourCode,
        'tour_name': tourName,
        'user_id': userId,
      };

  static SingleBookingModel fromJson(Map<String, dynamic> json) =>
      SingleBookingModel(
        createdAt:
            json['created_at'] == null ? '' : json['created_at'] as String,
        amountPaid:
            json['amount_paid'] == null ? 0.0 : json['amount_paid'] as num,
        customTourId:
            json['custom_tour_id'] == null ? 0 : json['custom_tour_id'] as int,
        dateOfTravel: json['date_of_travel'] == null
            ? ''
            : json['date_of_travel'] as String,
        gst: json['gst'] == null ? 0.0 : json['gst'] as num,
        gstAmount: json['gst_amount'] == null ? 0.0 : json['gst_amount'] as num,
        id: json['id'] as int,
        isCustom: json['is_custom'] == null ? false : json['is_custom'] as bool,
        noOfAdults:
            json['no_of_adults'] == null ? 0 : json['no_of_adults'] as int,
        noOfKids: json['no_of_kids'] == null ? 0 : json['no_of_kids'] as int,
        offerApplied: json['offer_applied'] == null
            ? false
            : json['offer_applied'] as bool,
        orderConfirmed: json['order_confirmed'] == null
            ? ''
            : json['order_confirmed'] as String,
        orderStatus:
            json['order_status'] == null ? '' : json['order_status'] as String,
        packageId: json['package_id'] == null ? 0 : json['package_id'] as int,
        payableAmount: json['payable_amount'] == null
            ? 0.0
            : json['payable_amount'] as num,
        reward: json['reward'] == null ? 0 : json['reward'] as int,
        totalAmount:
            json['total_amount'] == null ? 0.0 : json['total_amount'] as num,
        tourCode: json['tour_code'] == null ? '' : json['tour_code'] as String,
        tourName: json['tour_name'] == null ? '' : json['tour_name'] as String,
        userId: json['user_id'] == null ? '' : json['user_id'] as String,
      );
}
