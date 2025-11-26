// lib/component/produk_card.dart
import 'package:flutter/material.dart';
import 'package:kasir/models/produk.dart';
import 'package:kasir/screens/produk/detail_produk_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ProdukCard extends StatelessWidget {
  final ProdukModel produk;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProdukCard({super.key, required this.produk, required this.onEdit, required this.onDelete});

  String formatRupiah(num amount) {
    return amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    final bool stokHabis = produk.stock <= (produk.minStock ?? 0);

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => DetailProdukScreen(produk: produk),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // GAMBAR
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                    child: Hero(
                      tag: 'produk_${produk.idProduk}',
                      child: produk.imageUrl != null
                          ? Image.network(produk.imageUrl!, width: double.infinity, fit: BoxFit.cover)
                          : Container(
                              color: const Color(0xFFFFF8F8),
                              child: Icon(Icons.local_cafe_rounded, size: 80, color: Colors.brown[300]),
                            ),
                    ),
                  ),
                ),

                // INFO BAWAH — AMAN TANPA Expanded(flex:3)
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              produk.name,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D2D2D),
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: onEdit,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(20)),
                              child: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF666666)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Rp ${formatRupiah(produk.price)}",
                        style: GoogleFonts.poppins(fontSize: 19, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A1A)),
                      ),
                      if (stokHabis) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(20)),
                          child: Text("Habis", style: TextStyle(color: Colors.red.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            // DELETE BUTTON — persis di gambar
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
                  ]),
                  child: const Icon(Icons.delete_outline, size: 24, color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}