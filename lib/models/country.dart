class Country {
  final String name;
  final String flagUrl;
  final String capital;
  final int population;
  final String region;
  final String currency;
  final double? area;

  Country({
    required this.name,
    required this.flagUrl,
    required this.capital,
    required this.population,
    required this.region,
    required this.currency,
    this.area,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    String getCurrencyName(Map<String, dynamic> currenciesJson) {
      if (currenciesJson.isEmpty) return 'N/A';
      final firstKey = currenciesJson.keys.first;
      final currencyData = currenciesJson[firstKey];
      if (currencyData is Map<String, dynamic> && currencyData.containsKey('name')) {
        return currencyData['name'] ?? 'N/A';
      }
      return 'N/A';
    }

    double? parseArea(dynamic areaValue) {
      if (areaValue == null) return null;
      if (areaValue is int) return areaValue.toDouble();
      if (areaValue is double) return areaValue;
      return null;
    }

    return Country(
      name: (json['name'] != null && json['name']['common'] != null) ? json['name']['common'] as String : 'N/A',
      flagUrl: (json['flags'] != null && json['flags']['png'] != null) ? json['flags']['png'] as String : '',
      capital: (json['capital'] != null && json['capital'] is List && json['capital'].isNotEmpty)
          ? json['capital'][0] as String
          : 'N/A',
      population: (json['population'] != null) ? json['population'] as int : 0,
      region: (json['region'] != null) ? json['region'] as String : 'N/A',
      currency: (json['currencies'] != null)
          ? getCurrencyName(Map<String, dynamic>.from(json['currencies']))
          : 'N/A',
      area: parseArea(json['area']),
    );
  }
}
