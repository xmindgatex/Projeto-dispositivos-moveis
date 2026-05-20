// ================================================================
// Aluno   : Kaio Cesar de Sousa Pinheiro
// Curso   : DIM0524 - Desenvolvimento de Sistemas para Dispositivos Móveis
// Inst.   : Universidade Federal do Rio Grande do Norte (UFRN)
// ================================================================
// =============================================================
// ETAPA 3: Serviço HTTP — requisições à fakestoreapi.com
// =============================================================
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  /// Etapa 3: POST /auth/login → retorna token JWT ou null
  static Future<String?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Etapa 3: jsonDecode para converter resposta JSON em Map
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['token'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Etapa 3: GET /products → lista de produtos desserializados
  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // Etapa 3: mapeia cada JSON para um objeto Product via fromJson
      return data.map((json) => Product.fromJson(json)).toList();
    }

    throw Exception('Falha ao carregar produtos (${response.statusCode})');
  }
}
