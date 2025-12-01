// component/cashier/carousel_card.dart (dan SpecialCoffeeCard.dart juga sama)
import 'package:flutter/material.dart';
import 'package:kasir/models/produk.dart';
import 'package:kasir/utils/constants.dart';

class CarouselCard extends StatelessWidget {
  final ProdukModel produk;
  final Map<int, int> cart;
  final VoidCallback onCartChanged;

  const CarouselCard({
    super.key,
    required this.produk,
    required this.cart,
    required this.onCartChanged,
  });

  String get formattedPrice {
    final price = produk.price.toString();
    return "Rp. ${price.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    final int quantity = cart[produk.idProduk] ?? 0;

    Widget buildButton() {
      if (quantity == 0) {
        return GestureDetector(
          onTap: () { cart[produk.idProduk] = 1; onCartChanged(); },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: AppColors.azura, shape: BoxShape.circle),
            child: const Icon(Icons.add, color: Colors.white, size: 26),
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(color: AppColors.azura, borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(onTap: () { if (quantity == 1) cart.remove(produk.idProduk); else cart[produk.idProduk] = quantity - 1; onCartChanged(); }, child: const Icon(Icons.remove, color: Colors.white, size: 18)),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text("$quantity", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              GestureDetector(onTap: () { cart[produk.idProduk] = quantity + 1; onCartChanged(); }, child: const Icon(Icons.add, color: Colors.white, size: 18)),
            ],
          ),
        );
      }
    }

    return Container(
      width: 170,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 4, offset: const Offset(0, 4))]),
      child: Stack(
        children: [
          Column(
            children: [
              ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(28)), child: Image.network(produk.imageUrl ?? "assets/images/Matcha.png", height: 170, width: double.infinity, fit: BoxFit.cover)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(produk.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(produk.kategori.label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(height: 8),
                    Text(formattedPrice, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF6B4E3D))),
                  ]),
                ),
              ),
            ],
          ),
          Positioned(right: 16, top: 130, child: buildButton()),
        ],
      ),
    );
  }
}