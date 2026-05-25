// ================================================================
// Aluno   : Kaio Cesar de Sousa Pinheiro
// Curso   : DIM0524 - Desenvolvimento de Sistemas para Dispositivos Móveis
// Inst.   : Universidade Federal do Rio Grande do Norte (UFRN)
// ================================================================
// Etapa 4: modelo de item do carrinho com quantidade mutável
import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity;
}
