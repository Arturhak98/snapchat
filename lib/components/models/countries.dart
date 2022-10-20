import 'country_code.dart';

class Countries {
  Countries({required this.countries});
  List<Country> countries;
  factory Countries.fromJson(Map<String, dynamic> json) {
    return Countries(
        countries: (json['countries'] as List<dynamic>)
            .map((dynamic e) => Country.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}
