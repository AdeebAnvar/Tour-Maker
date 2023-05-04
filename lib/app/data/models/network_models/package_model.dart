class PackageModel {
  PackageModel({
    this.amount,
    this.category,
    this.days,
    this.description,
    this.destination,
    this.exclusiveTour,
    this.id,
    this.image,
    this.itinerary,
    this.name,
    this.nights,
    this.priority,
    this.region,
    this.tourCode,
    this.travelType,
    this.trending,
  });
  num? amount;
  String? category;
  int? days;
  String? description;
  String? destination;
  String? exclusiveTour;
  int? id;
  String? image;
  String? itinerary;
  String? name;
  int? nights;
  int? priority;
  String? region;
  String? tourCode;
  String? travelType;
  bool? trending;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'amount': amount,
        'category': category,
        'days': days,
        'description': description,
        'destination': destination,
        'exclusive_tour': exclusiveTour,
        'id': id,
        'image': image,
        'itinerary': itinerary,
        'name': name,
        'nights': nights,
        'priority': priority,
        'region': region,
        'tour_code': tourCode,
        'travel_type': travelType,
        'trending': trending,
      };

  static PackageModel fromJson(Map<String, dynamic> json) => PackageModel(
        amount: json['amount'] as int,
        category: json['category'] as String,
        days: json['days'] as int,
        description: json['description'] as String,
        destination: json['destination'] as String,
        exclusiveTour: json['exclusive_tour'] as String,
        id: json['id'] as int,
        image: json['image'] as String,
        itinerary: json['itinerary'] as String,
        name: json['name'] as String,
        nights: json['nights'] as int,
        priority: json['priority'] != null ? json['priority'] as int : 0,
        region: json['region'] as String,
        tourCode: json['tour_code'] as String,
        travelType: json['travel_type'] as String,
        trending: json['trending'] as bool,
      );
}
