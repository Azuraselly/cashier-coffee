// lib/screens/checkout/components/order_item_card.dart
import 'package:flutter/material.dart';
import 'package:kasir/models/cart_item.dart';

class OrderItemCard extends StatelessWidget {
  final CartItem item;
  final String Function(int) formatRupiah;
  const OrderItemCard({super.key, required this.item, required this.formatRupiah});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              item.produk.imageUrl ?? "https://via.placeholder.com/300",
              width: 90, height: 90, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.grey[300], child: const Icon(Icons.coffee, size: 40)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.produk.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("Rp. ${formatRupiah(item.produk.price)}", style: const TextStyle(color: Colors.brown)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFBCAAA4), borderRadius: BorderRadius.circular(30)),
            child: Text("− ${item.qty} +", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}