import 'package:flutter/material.dart';
import 'package:kasir/models/produk.dart';
import 'package:kasir/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailProdukScreen extends StatelessWidget {
  final ProdukModel produk;

  const DetailProdukScreen({Key? key, required this.produk}) : super(key: key);

  String formatRupiah(num amount) {
    final str = amount.toInt().toString();
    return str.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    final bool tersedia = produk.stock > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Hero(
            tag: 'produk_${produk.idProduk}',
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: double.infinity,
                  child: produk.imageUrl != null
                      ? Image.network(produk.imageUrl!, fit: BoxFit.cover)
                      : Container(
                          color: Colors.brown[100],
                          child: Icon(Icons.local_cafe_rounded,
                              size: 120, color: Colors.brown[400]),
                        ),
                ),

                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.15),
                        Colors.black.withOpacity(0.30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child:
                    const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.58,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 18,
                    offset: Offset(0, -4),
                  )
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(30, 35, 30, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produk.name,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        color: const Color(0xFF2D1B3D),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Text(
                          "Rp ${formatRupiah(produk.price)}",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.azura,
                          ),
                        ),
                        const Spacer(),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: tersedia
                                ? const Color(0xFFE8F5E8)
                                : const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                tersedia
                                    ? Icons.check_circle
                                    : Icons.error_outline_rounded,
                                size: 18,
                                color: tersedia
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                tersedia
                                    ? "${produk.stock} tersedia"
                                    : "Stok Habis",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: tersedia
                                      ? Colors.green.shade800
                                      : Colors.red.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    Row(
                      children: [
                        Icon(Icons.category_outlined,
                            color: Colors.grey[600], size: 22),
                        const SizedBox(width: 12),
                        Text(
                          produk.kategori.label,
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    Text(
                      "Deskripsi Produk",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D1B3D),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      produk.description ??
                          "Minuman premium dengan rasa yang seimbang, dibuat dari bahan berkualitas, cocok dinikmati kapan saja.",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        height: 1.7,
                        color: Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 45),

                    SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: ElevatedButton(
                        onPressed: tersedia
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "${produk.name} ditambahkan!")),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tersedia
                              ? AppColors.azura
                              : Colors.grey[400],
                          foregroundColor: Colors.white,
                          elevation: 10,
                          shadowColor: AppColors.azura.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(33),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_shopping_cart_rounded,
                                size: 26),
                            const SizedBox(width: 10),
                            Text(
                              tersedia
                                  ? "Tambah ke Keranjang"
                                  : "Stok Habis",
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
