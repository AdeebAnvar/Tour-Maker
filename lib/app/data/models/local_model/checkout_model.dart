class CheckOutModel {
  CheckOutModel({
    this.tourName,
    this.tourID,
    this.tourCode,
    this.tourItinerary,
    this.dateOfTravel,
    this.amount,
    this.kidsAmount,
    this.offerAmount,
    this.kidsOfferAmount,
    this.adultCount,
    this.childrenCount,
    this.gst,
    this.commission,
    this.orderID,
    this.transportationMode,
    this.advanceAmount,
  });
  int? tourID;
  String? tourName;
  String? tourCode;
  String? tourItinerary;
  String? dateOfTravel;
  num? amount;
  num? kidsAmount;
  num? offerAmount;
  num? kidsOfferAmount;
  int? adultCount;
  int? childrenCount;
  int? gst;
  num? commission;
  int? orderID;
  String? transportationMode;
  num? advanceAmount;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'tourName': tourName,
        'tourCode': tourCode,
        'tourItinerary': tourItinerary,
        'dateOfTravel': dateOfTravel,
        'amount': amount,
        'kidsAmount': kidsAmount,
        'offerAmount': offerAmount,
        'kidsOfferAmount': kidsOfferAmount,
        'adultCount': adultCount,
        'childrenCount': childrenCount,
        'gst': gst,
        'commission': commission,
        'orderID': orderID,
        'transportationMode': transportationMode,
        'advanceAmount': advanceAmount,
        'tourID': tourID,
      };

  static CheckOutModel fromMap(Map<String, dynamic> map) => CheckOutModel(
        tourName: map['tourName'] as String,
        tourID: map['tourID'] as int,
        tourCode: map['tourCode'] as String,
        tourItinerary: map['tourItinerary'] as String,
        dateOfTravel: map['dateOfTravel'] as String,
        amount: map['amount'] as int,
        kidsAmount: map['kidsAmount'] as int,
        offerAmount: map['offerAmount'] as int,
        kidsOfferAmount: map['kidsOfferAmount'] as int,
        adultCount: map['adultCount'] as int,
        childrenCount: map['childrenCount'] as int,
        gst: map['gst'] as int,
        commission: map['commission'] as int,
        orderID: map['orderID'] as int,
        transportationMode: map['transportationMode'] as String,
        advanceAmount: map['advanceAmount'] as int,
      );
}
