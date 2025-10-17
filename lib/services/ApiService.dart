import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  static const baseUrl = "https://bb3-api.ashwinsrivastava.com/store";
  //static const baseUrl = "https://api.stryce.com/store";
  static Future<List<ProductModel>> fetchProducts({
    int? page,
    int? limit,
    String? sort,
    String? searchFields,
    String? search,
  }) async {
    try {
      // ✅ Base API endpoint
      final uri = Uri.parse("$baseUrl/product").replace(
        queryParameters: {
          if (page != null) 'page': page.toString(),
           'limit': "20",
          if (sort != null && sort.isNotEmpty) 'sort': sort,
          if (searchFields != null && searchFields.isNotEmpty)
            'searchFields': searchFields,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        // ✅ Handle both list and single product responses
        if (body['data'] is List) {
          return (body['data'] as List)
              .map((e) => ProductModel.fromJson(e))
              .toList();
        } else if (body['data'] is Map) {
          return [ProductModel.fromJson(body['data'])];
        }
      } else {
        print("❌ Error: ${response.statusCode} - ${response.body}");
      }

      return [];
    } catch (e) {
      print("❌ Error fetching products: $e");
      return [];
    }
  }

  // 🟢 Fetch all products
  // static Future<List<ProductModel>> fetchProducts({String? search}) async {
  //   try {
  //     final uri = search == null || search.isEmpty
  //         ? Uri.parse("$baseUrl/product?sort=createdAt:desc")
  //         : Uri.parse("$baseUrl/product/$search");
  //
  //     final response = await http.get(uri);
  //
  //     if (response.statusCode == 200) {
  //       final body = json.decode(response.body);
  //
  //       if (body['data'] is List) {
  //         // product list
  //         return (body['data'] as List)
  //             .map((e) => ProductModel.fromJson(e))
  //             .toList();
  //       } else if (body['data'] is Map) {
  //         // single product (search)
  //         return [ProductModel.fromJson(body['data'])];
  //       }
  //     }
  //     return [];
  //   } catch (e) {
  //     print("Error fetching products: $e");
  //     return [];
  //   }
  // }
}
