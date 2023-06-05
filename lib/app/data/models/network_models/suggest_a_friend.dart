class ReferAFriend {
  ReferAFriend(
      {this.referralName,
      this.referralContact,
      this.referralAddress,
      this.referralDistrict,
      this.referralCountry,
      this.referralState});
  String? referralName;
  String? referralContact;
  String? referralAddress;
  String? referralDistrict;
  String? referralCountry;
  String? referralState;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'referral_name': referralName,
        'referral_contact': referralContact,
        'referral_address': referralAddress,
        'referral_district': referralDistrict,
        'referral_country': referralCountry,
        'referral_state': referralState,
      };
}
