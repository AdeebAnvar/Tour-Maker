class TrendingToursModel {
  TrendingToursModel({this.destination, this.image, this.minAmount});
  String? destination;
  String? image;
  num? minAmount;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'destination': destination,
        'image': image,
        'min_amount': minAmount,
      };
  static TrendingToursModel fromJson(Map<String, dynamic> json) =>
      TrendingToursModel(
        destination:
            json['destination'] == null ? '' : json['destination'] as String,
        image: json['image'] == null ? '' : json['image'] as String,
        minAmount: json['min_amount'] == null ? 0 : json['min_amount'] as int,
      );
}
