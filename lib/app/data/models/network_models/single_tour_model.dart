class SingleTourModel {
  SingleTourModel({this.tourData, this.packageData});

  TourData? tourData;
  List<PackageData>? packageData;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'tour_data': tourData!.toJson(),
        'package_data':
            packageData!.map((PackageData v) => v.toJson()).toList(),
      };

  static SingleTourModel fromJson(Map<String, dynamic> json) => SingleTourModel(
        tourData: json['tour_data'] != null
            ? TourData.fromJson(json['tour_data'] as Map<String, dynamic>)
            : null,
        packageData: json['package_data'] != null
            ? (json['package_data'] as List<dynamic>)
                .map((dynamic e) =>
                    PackageData.fromJson(e as Map<String, dynamic>))
                .toList()
            : <PackageData>[],
      );
}

class TourData {
  TourData(
      {this.iD,
      this.name,
      this.image,
      this.destination,
      this.description,
      this.days,
      this.nights,
      this.priority,
      this.trending,
      this.exclusiveTour,
      this.tourCode,
      this.category,
      this.itinerary,
      this.travelType,
      this.region});

  int? iD;
  String? name;
  String? image;
  String? destination;
  String? description;
  int? days;
  int? nights;
  int? priority;
  String? trending;
  String? exclusiveTour;
  String? tourCode;
  String? category;
  String? itinerary;
  String? travelType;
  String? region;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'ID': iD,
        'name': name,
        'image': image,
        'destination': destination,
        'description': description,
        'days': days,
        'nights': nights,
        'priority': priority,
        'trending': trending,
        'exclusive_tour': exclusiveTour,
        'tour_code': tourCode,
        'category': category,
        'itinerary': itinerary,
        'travel_type': travelType,
        'region': region,
      };

  static TourData fromJson(Map<String, dynamic> json) => TourData(
        iD: json['ID'] as int,
        name: json['name'] != null ? json['name'] as String : '',
        image: json['image'] != null
            ? json['image'] as String
            : 'assets/Background.png',
        destination:
            json['destination'] == null ? '' : json['destination'] as String,
        description:
            json['description'] == null ? '' : json['description'] as String,
        days: json['days'] == null ? 0 : json['days'] as int,
        nights: json['nights'] == null ? 0 : json['nights'] as int,
        priority: json['priority'] == null ? 0 : json['priority'] as int,
        trending: json['trending'] == null ? '' : json['trending'] as String,
        exclusiveTour: json['exclusive_tour'] == null
            ? ''
            : json['exclusive_tour'] as String,
        tourCode: json['tour_code'] == null ? '' : json['tour_code'] as String,
        category: json['category'] == null ? '' : json['category'] as String,
        itinerary: json['itinerary'] == null ? '' : json['itinerary'] as String,
        travelType:
            json['travel_type'] == null ? '' : json['travel_type'] as String,
        region: json['region'] == null ? '' : json['region'] as String,
      );
}

class PackageData {
  PackageData(
      {this.iD,
      this.tourId,
      this.dateOfTravel,
      this.totalSeats,
      this.availableSeats,
      this.amount,
      this.kidsAmount,
      this.offerAmount,
      this.kidsOfferAmount,
      this.extraOffer,
      this.lastAmount,
      this.advanceAmount,
      this.batchOrIndividual,
      this.transportationMode,
      this.agentCommission,
      this.gstPercent});
  int? iD;
  int? tourId;
  String? dateOfTravel;
  int? totalSeats;
  int? availableSeats;
  int? amount;
  int? kidsAmount;
  int? offerAmount;
  int? kidsOfferAmount;
  bool? extraOffer;
  int? lastAmount;
  int? advanceAmount;
  String? batchOrIndividual;
  String? transportationMode;
  int? agentCommission;
  int? gstPercent;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': iD,
        'tour_id': tourId,
        'date_of_travel': dateOfTravel,
        'total_seats': totalSeats,
        'available_seats': availableSeats,
        'amount': amount,
        'kids_amount': kidsAmount,
        'offer_amount': offerAmount,
        'kids_offer_amount': kidsOfferAmount,
        'extra_offer': extraOffer,
        'last_amount': lastAmount,
        'agent_commission': agentCommission,
        'advance_amount': advanceAmount,
        'batch_or_individual': batchOrIndividual,
        'transportation_mode': transportationMode,
        'gst_percent': gstPercent,
      };

  static PackageData fromJson(Map<String, dynamic> json) => PackageData(
        iD: json['id'] as int,
        tourId: json['tour_id'] as int,
        dateOfTravel: json['date_of_travel'] == null
            ? ''
            : json['date_of_travel'] as String,
        totalSeats:
            json['total_seats'] == null ? 0 : json['total_seats'] as int,
        availableSeats: json['available_seats'] == null
            ? 0
            : json['available_seats'] as int,
        agentCommission: json['agent_commission'] == null
            ? 0
            : json['agent_commission'] as int,
        amount: json['amount'] == null ? 0 : json['amount'] as int,
        kidsAmount:
            json['kids_amount'] == null ? 0 : json['kids_amount'] as int,
        offerAmount:
            json['offer_amount'] == null ? 0 : json['offer_amount'] as int,
        kidsOfferAmount: json['kids_offer_amount'] == null
            ? 0
            : json['kids_offer_amount'] as int,
        extraOffer:
            // ignore: avoid_bool_literals_in_conditional_expressions
            json['extra_offer'] == null ? false : json['extra_offer'] as bool,
        lastAmount:
            json['last_amount'] == null ? 0 : json['last_amount'] as int,
        advanceAmount:
            json['advance_amount'] == null ? 0 : json['advance_amount'] as int,
        batchOrIndividual: json['batch_or_individual'] == null
            ? ''
            : json['batch_or_individual'] as String,
        gstPercent:
            json['gst_percent'] == null ? 0 : json['gst_percent'] as int,
        transportationMode: json['transportation_mode'] == null
            ? ''
            : json['transportation_mode'] as String,
      );
}
