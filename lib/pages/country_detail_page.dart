import 'package:flutter/material.dart';
import '../models/country.dart';

class CountryDetailPage extends StatelessWidget {
  final Country country;

  const CountryDetailPage(this.country, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyleTitle = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey.shade900,
    );
    final textStyleSubtitle = TextStyle(
      fontSize: 18,
      color: Colors.blueGrey.shade700,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.blueGrey.shade900),
        title: Text(
          country.name,
          style: TextStyle(
            color: Colors.blueGrey.shade900,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                country.flagUrl,
                width: 280,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.flag, size: 100, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),
            Text(country.name, style: textStyleTitle),
            const SizedBox(height: 12),
            // Aqui você pode adicionar mais detalhes do país
            Text(
              'Capital: ${country.capital ?? "Desconhecida"}',
              style: textStyleSubtitle,
            ),
            const SizedBox(height: 8),
            Text(
              'Região: ${country.region ?? "Desconhecida"}',
              style: textStyleSubtitle,
            ),
            const SizedBox(height: 8),
            Text(
              'População: ${country.population?.toString() ?? "Desconhecida"}',
              style: textStyleSubtitle,
            ),
            const SizedBox(height: 8),
            Text(
              'Área: ${country.area != null ? "${country.area} km²" : "Desconhecida"}',
              style: textStyleSubtitle,
            ),
          ],
        ),
      ),
    );
  }
}
