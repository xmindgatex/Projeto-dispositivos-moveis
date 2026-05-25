// ================================================================
// Aluno   : Kaio Cesar de Sousa Pinheiro
// Curso   : DIM0524 - Desenvolvimento de Sistemas para Dispositivos Móveis
// Inst.   : Universidade Federal do Rio Grande do Norte (UFRN)
// ================================================================
// =============================================================
// ETAPA 4: Tela do carrinho com gerenciamento de estado (setState)
// Permite alterar quantidade e remover itens
// =============================================================
import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cart;
  final void Function(List<CartItem>) onCartChanged;

  const CartScreen({
    super.key,
    required this.cart,
    required this.onCartChanged,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Etapa 4: cópia local do carrinho para mutações via setState
  late List<CartItem> _cart;

  @override
  void initState() {
    super.initState();
    _cart = List.from(widget.cart);
  }

  // Etapa 4: cálculo do total iterando sobre a coleção
  double get _total =>
      _cart.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  // Etapa 4: altera quantidade — remove o item se chegar a 0
  void _changeQuantity(int index, int delta) {
    setState(() {
      _cart[index].quantity += delta;
      if (_cart[index].quantity <= 0) {
        _cart.removeAt(index);
      }
    });
    widget.onCartChanged(_cart);
  }

  // Etapa 4: remove item diretamente pelo índice
  void _removeItem(int index) {
    setState(() => _cart.removeAt(index));
    widget.onCartChanged(_cart);
  }

  void _confirmPurchase() {
    setState(() => _cart.clear());
    widget.onCartChanged(_cart);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Compra confirmada! Obrigado.'),
        backgroundColor: Colors.deepPurple,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meu Carrinho',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _cart.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Carrinho vazio',
                      style: TextStyle(color: Colors.grey, fontSize: 18)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _cart.length,
              // Etapa 4: itera sobre a coleção para renderizar cada item
              itemBuilder: (context, index) {
                final item = _cart[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        // Imagem do produto
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 65,
                            height: 65,
                            child: Image.network(
                              item.product.image,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.image,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Informações + controles de quantidade
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'R\$ ${item.product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Etapa 4: controles − quantidade +
                              Row(
                                children: [
                                  _QuantityButton(
                                    icon: Icons.remove,
                                    onPressed: () => _changeQuantity(index, -1),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  _QuantityButton(
                                    icon: Icons.add,
                                    onPressed: () => _changeQuantity(index, 1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Botão de remover item
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeItem(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // Rodapé: total + botão confirmar
      bottomNavigationBar: _cart.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'R\$ ${_total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _confirmPurchase,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Confirmar Compra',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

/// Botão auxiliar para os controles de quantidade
class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple.shade50,
          foregroundColor: Colors.deepPurple,
          padding: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}
