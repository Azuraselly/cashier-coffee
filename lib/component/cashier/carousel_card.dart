// lib/component/cashier/carousel_card.dart
import 'package:flutter/material.dart';
import 'package:kasir/models/produk.dart';
import 'package:kasir/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return "Rp ${price.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}";
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
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.azura,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.azura,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  if (quantity == 1)
                    cart.remove(produk.idProduk);
                  else
                    cart[produk.idProduk] = quantity - 1;
                  onCartChanged();
                },
                child: const Icon(Icons.remove, color: Colors.white, size: 20),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "$quantity",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
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
      width: 190,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0XFFF2F2F2),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            children: [
              // GAMBAR
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(34),
                ),
                child: Hero(
                  tag: 'produk_${produk.idProduk}',
                  child: Image.network(
                    produk.imageUrl ?? "",
                    height: 190,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 18, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        produk.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          height: 1.2,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      Text(
                        produk.kategori.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.azura,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          formattedPrice,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Positioned(right: 16, top: 160, child: buildAddButton()),
        ],
      ),
    );
  }
}
