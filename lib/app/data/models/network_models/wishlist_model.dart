// ignore_for_file: avoid_bool_literals_in_conditional_expressions

class WishListModel {
  WishListModel({
    this.category,
    this.days,
    this.description,
    this.destination,
    this.exclusiveTour,
    this.id,
    this.image,
    this.itinerary,
    this.minAmount,
    this.name,
    this.nights,
    this.priority,
    this.region,
    this.tourCode,
    this.tourId,
    this.travelType,
    this.trending,
  });
  String? category;
  int? days;
  String? description;
  String? destination;
  String? exclusiveTour;
  int? id;
  String? image;
  String? itinerary;
  int? minAmount;
  String? name;
  int? nights;
  int? priority;
  String? region;
  String? tourCode;
  int? tourId;
  String? travelType;
  bool? trending;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'category': category,
        'days': days,
        'description': description,
        'destination': destination,
        'exclusive_tour': exclusiveTour,
        'id': id,
        'image': image,
        'itinerary': itinerary,
        'min_amount': minAmount,
        'name': name,
        'nights': nights,
        'priority': priority,
        'region': region,
        'tour_code': tourCode,
        'tour_id': tourId,
        'travel_type': travelType,
        'trending': trending,
      };
  static WishListModel fromJson(Map<String, dynamic> json) => WishListModel(
        category: json['category'] == null ? '' : json['category'] as String,
        days: json['days'] == null ? 0 : json['days'] as int,
        description:
            json['description'] == null ? '' : json['description'] as String,
        destination:
            json['destination'] == null ? '' : json['destination'] as String,
        exclusiveTour: json['exclusive_tour'] == null
            ? ''
            : json['exclusive_tour'] as String,
        id: json['id'] == null ? 0 : json['id'] as int,
        image: json['image'] == null ? '' : json['image'] as String,
        itinerary: json['itinerary'] == null ? '' : json['itinerary'] as String,
        minAmount: json['min_amount'] == null ? 0 : json['min_amount'] as int,
        name: json['name'] == null ? '' : json['name'] as String,
        nights: json['nights'] == null ? 0 : json['nights'] as int,
        priority: json['priority'] == null ? 0 : json['priority'] as int,
        region: json['region'] == null ? '' : json['region'] as String,
        tourCode: json['tour_code'] == null ? '' : json['tour_code'] as String,
        tourId: json['tour_id'] == null ? 0 : json['tour_id'] as int,
        travelType:
            json['travel_type'] == null ? '' : json['travel_type'] as String,
        trending: json['trending'] == null ? false : json['trending'] as bool,
      );
}
