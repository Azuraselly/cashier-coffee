// component/cashier/coffee_card.dart  →  GANTI NAMA JADI SpecialCoffeeCard
import 'package:flutter/material.dart';
import 'package:kasir/models/produk.dart';
import 'package:kasir/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecialCoffeeCard extends StatelessWidget {
  final ProdukModel produk;
  final Map<int, int> cart;
  final VoidCallback onCartChanged;

  const SpecialCoffeeCard({
    super.key,
    required this.produk,
    required this.cart,
    required this.onCartChanged,
  });

  // Format Rupiah
  String get formattedPrice {
    final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return "Rp. ${produk.price.toString().replaceAllMapped(formatter, (m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    final int quantity = cart[produk.idProduk] ?? 0;

    Widget buildAddButton() {
      if (quantity == 0) {
        return GestureDetector(
          onTap: () {
            cart[produk.idProduk] = 1;
            onCartChanged();
          },
          child: const CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.azura,
            child: Icon(Icons.add, color: Colors.white, size: 26),
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.azura,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  if (quantity == 1) {
                    cart.remove(produk.idProduk);
                  } else {
                    cart[produk.idProduk] = quantity - 1;
                  }
                  onCartChanged();
                },
                child: const Icon(Icons.remove, color: Colors.white, size: 20),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  "$quantity",
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              GestureDetector(
                onTap: () {
                  cart[produk.idProduk] = quantity + 1;
                  onCartChanged();
                },
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ],
          ),
        );
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // GAMBAR KIRI
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
            child: Image.network(
              produk.imageUrl ?? "asstes/images/Matcha.png",
              width: 140,
              height: 140,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 140,
                height: 140,
                color: Colors.grey[300],
                child: const Icon(Icons.coffee, size: 50, color: Colors.grey),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 35, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    produk.name,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    produk.kategori.label,
                    style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[600]),
                  ),
                  Text(
                    formattedPrice,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF6B4E3D)),
                  ),
                ],
              ),
            ),
          ),

          // TOMBOL + / − 1 + DI KANAN
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: buildAddButton(),
          ),
        ],
      ),
    );
  }
}