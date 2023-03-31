class SingleBookingModel {
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
  num? orderConfirmed;
  String? orderStatus;
  int? packageId;
  num? payableAmount;
  num? reward;
  num? totalAmount;
  String? tourCode;
  String? tourName;
  String? userId;

  SingleBookingModel(
      {this.amountPaid,
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

  Map<String, dynamic> toJson() => <String, dynamic>{
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
        amountPaid: json['amount_paid'] as num,
        customTourId: json['custom_tour_id'] as int,
        dateOfTravel: json['date_of_travel'] as String,
        gst: json['gst'] as num,
        gstAmount: json['gst_amount'] as num,
        id: json['id'] as int,
        isCustom: json['is_custom'] as bool,
        noOfAdults: json['no_of_adults'] as int,
        noOfKids: json['no_of_kids'] as int,
        offerApplied: json['offer_applied'] as bool,
        orderConfirmed: json['order_confirmed'] as num,
        orderStatus: json['order_status'] as String,
        packageId: json['package_id'] as int,
        payableAmount: json['payable_amount'] as num,
        reward: json['reward'] as int,
        totalAmount: json['total_amount'] as num,
        tourCode: json['tour_code'] as String,
        tourName: json['tour_name'] as String,
        userId: json['user_id'] as String,
      );
}
