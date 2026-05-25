// ================================================================
// Aluno   : Kaio Cesar de Sousa Pinheiro
// Curso   : DIM0524 - Desenvolvimento de Sistemas para Dispositivos Móveis
// Inst.   : Universidade Federal do Rio Grande do Norte (UFRN)
// ================================================================
// Etapa 3: modelo com factory fromJson para desserialização da API
class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String image;
  final String category;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
  });

  /// Etapa 3: converte JSON da API → objeto Dart
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      category: json['category'] as String,
    );
  }
}
