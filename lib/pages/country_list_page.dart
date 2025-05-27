import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/country.dart';
import 'country_detail_page.dart';

class CountryListPage extends StatefulWidget {
  @override
  _CountryListPageState createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  List<Country> _allCountries = [];
  int _currentPage = 0;
  final int _perPage = 10;

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    final response =
        await http.get(Uri.parse('https://restcountries.com/v3.1/all'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _allCountries = jsonData
            .map((countryJson) => Country.fromJson(countryJson))
            .toList();
        _allCountries.sort((a, b) => a.name.compareTo(b.name));
      });
    }
  }

  List<Country> get _pagedCountries {
    final start = _currentPage * _perPage;
    final end = (_currentPage + 1) * _perPage;
    return _allCountries.sublist(
      start,
      end > _allCountries.length ? _allCountries.length : end,
    );
  }

  void _nextPage() {
    if ((_currentPage + 1) * _perPage < _allCountries.length) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: Text(
          '🌍 Países do Mundo',
          style: TextStyle(
            color: Colors.blueGrey.shade900,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: _allCountries.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    itemCount: _pagedCountries.length,
                    itemBuilder: (context, index) {
                      final country = _pagedCountries[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                CountryDetailPage(country),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.easeOutQuad;

                              final tween =
                                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                          shadowColor: Colors.blueGrey.shade100,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    country.flagUrl,
                                    width: 80,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(Icons.flag, size: 50, color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Text(
                                    country.name,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blueGrey.shade900,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.blueGrey.shade400,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _previousPage,
                        icon: Icon(Icons.arrow_back, color: Colors.blueGrey),
                        label: Text(
                          'Anteriores',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.blueGrey),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                        ),
                      ),
                      Text(
                        'Página ${_currentPage + 1}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey.shade800),
                      ),
                      OutlinedButton.icon(
                        onPressed: _nextPage,
                        icon: Icon(Icons.arrow_forward, color: Colors.blueGrey),
                        label: Text(
                          'Próximos',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.blueGrey),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
