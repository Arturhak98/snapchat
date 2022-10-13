
class Country {
  final String CountryName;
  final String CountryCode;
  final String CountryCodeString;
  
  Country({required this.CountryCode, required this.CountryName,required this.CountryCodeString});
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      CountryName: json['name'] as String,
      CountryCode: json['e164_cc'] as String,
      CountryCodeString: json['iso2_cc'] as String
    );
  }
    Map<String, dynamic> toMap() {
    final map = {
      'CountryName': CountryName,
      'CountryCode': CountryCode,
      'CountryCodeString': CountryCodeString,
    };
    return map;
  }

  factory Country.fromMap(Map<String, dynamic> country) {
    return Country(
     CountryName: country['CountryName'] as String,
      CountryCode: country['CountryCode'].toString(),
      CountryCodeString: country['CountryCodeString'] as String
    );
  }
}
