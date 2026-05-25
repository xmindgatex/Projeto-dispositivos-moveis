// ================================================================
// Aluno   : Kaio Cesar de Sousa Pinheiro
// Curso   : DIM0524 - Desenvolvimento de Sistemas para Dispositivos Móveis
// Inst.   : Universidade Federal do Rio Grande do Norte (UFRN)
// ================================================================
// =============================================================
// ETAPA 3: Produtos carregados da API (async/await + FutureBuilder)
// ETAPA 4: Gerenciamento de carrinho com setState
// =============================================================
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'login_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _products = [];
  // Etapa 4: lista do carrinho gerenciada em memória via setState
  final List<CartItem> _cart = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Etapa 3: async/await para buscar produtos da API
  Future<void> _loadProducts() async {
    try {
      final products = await ApiService.getProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar produtos. Verifique sua conexão.';
        _isLoading = false;
      });
    }
  }

  // Etapa 4: adiciona produto ao carrinho (agrupa se já existir)
  void _addToCart(Product product) {
    setState(() {
      final index = _cart.indexWhere((i) => i.product.id == product.id);
      if (index >= 0) {
        _cart[index].quantity++;
      } else {
        _cart.add(CartItem(product: product));
      }
    });

    // Etapa 4: SnackBar confirmando inserção no carrinho
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} adicionado ao carrinho!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Etapa 3: logout — apaga sessão e volta à tela de login
  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  // Etapa 4: conta total de unidades no carrinho para o badge
  int get _cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Loja Online',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          // Etapa 4: badge com contagem + navegação para CartScreen
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () async {
                  // Etapa 4: passa o carrinho e recebe as alterações de volta
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartScreen(
                        cart: _cart,
                        onCartChanged: (updated) {
                          setState(() {
                            _cart.clear();
                            _cart.addAll(updated);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              if (_cartCount > 0)
                Positioned(
                  top: 8,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          // Etapa 3: logout com limpeza de sessão
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _loadProducts();
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    // Etapa 3: GridView com produtos vindos da API
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        return ProductCard(
          product: _products[index],
          onBuy: () => _addToCart(_products[index]),
        );
      },
    );
  }
}
