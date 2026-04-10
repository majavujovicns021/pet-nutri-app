import 'dart:convert';
import 'package:http/http.dart' as http;

class PetFoodProduct {
  final String name;
  final String brand;
  final String? imageUrl;
  final String? ingredients;
  final Map<String, dynamic>? nutriments;
  final String barcode;

  PetFoodProduct({
    required this.name,
    required this.brand,
    this.imageUrl,
    this.ingredients,
    this.nutriments,
    required this.barcode,
  });

  /// URL ka stranici proizvoda na Open Pet Food Facts
  String get productUrl => 'https://world.openpetfoodfacts.org/product/$barcode';

  factory PetFoodProduct.fromJson(Map<String, dynamic> json) {
    return PetFoodProduct(
      name: json['product_name'] ?? json['product_name_en'] ?? 'Nepoznat proizvod',
      brand: json['brands'] ?? 'Nepoznat brend',
      imageUrl: json['image_front_small_url'] ?? json['image_url'],
      ingredients: json['ingredients_text'] ?? json['ingredients_text_en'],
      nutriments: json['nutriments'] as Map<String, dynamic>?,
      barcode: json['code'] ?? '',
    );
  }

  double? get fatPer100g => _getNum('fat_100g');
  double? get proteinPer100g => _getNum('proteins_100g');
  double? get carbsPer100g => _getNum('carbohydrates_100g');
  double? get fiberPer100g => _getNum('fiber_100g');
  double? get saltPer100g => _getNum('salt_100g');
  double? get energyKcal => _getNum('energy-kcal_100g');

  double? _getNum(String key) {
    final v = nutriments?[key];
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }
}

class PetFoodApi {
  static const _baseUrl = 'https://world.openpetfoodfacts.org';

  static Future<List<PetFoodProduct>> search(String query, {int page = 1}) async {
    final uri = Uri.parse(
      '$_baseUrl/cgi/search.pl?search_terms=${Uri.encodeComponent(query)}'
      '&search_simple=1&action=process&json=1&page=$page&page_size=20',
    );

    final response = await http.get(uri).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode != 200) return [];

    final data = json.decode(response.body);
    final products = data['products'] as List<dynamic>? ?? [];

    return products
        .map((p) => PetFoodProduct.fromJson(p as Map<String, dynamic>))
        .where((p) => p.name.isNotEmpty && p.name != 'Nepoznat proizvod')
        .toList();
  }
}
