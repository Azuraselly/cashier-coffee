import 'package:kasir/models/produk.dart';

class CartItem {
  final ProdukModel produk;
  final int qty;

  const CartItem({
    required this.produk,
    required this.qty,
  });
}