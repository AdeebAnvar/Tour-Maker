class UserModel {
  UserModel({
    this.address,
    this.category,
    this.district,
    this.email,
    this.enterpriseName,
    this.gender,
    this.name,
    this.paymentId,
    this.paymentStatus,
    this.phoneNumber,
    this.state,
    this.tAndCStatus,
    this.profileImage,
    this.country,
  });
  String? address;
  String? category;
  String? district;
  String? email;
  String? enterpriseName;
  String? gender;
  String? name;
  String? paymentId;
  String? paymentStatus;
  String? phoneNumber;
  String? state;
  String? tAndCStatus;
  String? profileImage;
  String? country;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'address': address,
        'category': category,
        'district': district,
        'email': email,
        'enterprise_name': enterpriseName,
        'gender': gender,
        'name': name,
        'payment_id': paymentId,
        'payment_status': paymentStatus,
        'phone_number': phoneNumber,
        'state': state,
        't_and_c_status': tAndCStatus,
        'country': country,
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        address:json['address']==null?'': json['address'] as String,
        category:json['category']==null?'standard': json['category'] as String,
        district: json['district']==null?'':json['district'] as String,
        email:json['email'] ==null?'': json['email'] as String,
        enterpriseName:json['enterprise_name']==null?'': json['enterprise_name'] as String,
        gender:json['gender']==null?'': json['gender'] as String,
        name: json['name']==null?'': json['name'] as String,
        paymentId:
            json['payment_id'] == null ? '' : json['payment_id'] as String,
        paymentStatus: json['payment_status'] == null
            ? ''
            : json['payment_status'] as String,
        phoneNumber:json['phone_number']==null?'': json['phone_number'] as String,
        state:json['state']==null?'': json['state'] as String,
        tAndCStatus: json['t_and_c_status']==null?'':json['t_and_c_status'] as String,
        profileImage:json['profile_image']==null?'': json['profile_image'] as String,
        country: json['country'] ==null?'':json['country'] as String,
      );
}
