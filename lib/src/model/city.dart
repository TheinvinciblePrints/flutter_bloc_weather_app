class CityResponse {
  List<City> city;

  CityResponse({this.city});

  CityResponse.fromJson(List<dynamic> json) {
    city = json.map((posts) => City.fromJson(posts)).toList();
  }
}

class City {
  String city;
  String admin;
  String country;
  String populationProper;
  String iso2;
  String capital;
  String lat;
  String lng;
  String population;

  bool isSelected = false;

  City({
    this.city,
    this.admin,
    this.country,
    this.populationProper,
    this.iso2,
    this.capital,
    this.lat,
    this.lng,
    this.population,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        city: json["city"],
        admin: json["admin"],
        country: json["country"],
        populationProper: json["population_proper"],
        iso2: json["iso2"],
        capital: json["capital"],
        lat: json["lat"],
        lng: json["lng"],
        population: json["population"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "admin": admin,
        "country": country,
        "population_proper": populationProper,
        "iso2": iso2,
        "capital": capital,
        "lat": lat,
        "lng": lng,
        "population": population,
      };
}
