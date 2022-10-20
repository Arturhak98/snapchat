class Country {
  String CountryName;
  String CountryCode;
  String CountryCodeString;

  Country(
      {this.CountryCode = '',
      this.CountryName = '',
      this.CountryCodeString = ''});
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
        CountryName: json['name'] as String,
        CountryCode: json['e164_cc'] as String,
        CountryCodeString: json['iso2_cc'] as String);
  }
  Map<String, dynamic> toMap() {
    final map = {
      'Name': CountryName,
      'Code': CountryCode,
      'CodeString': CountryCodeString,
    };
    return map;
  }

  factory Country.fromMap(Map<String, dynamic> country) {
    return Country(
        CountryName: country['Name'] as String,
        CountryCode: country['Code'].toString(),
        CountryCodeString: country['CodeString'] as String);
  }
}
