import 'package:flutter/material.dart';
import 'package:kasir/models/cart_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir/utils/constants.dart';

class OrderItemCard extends StatelessWidget {
  final CartItem item;
  final String Function(int) formatRupiah;
  final VoidCallback onRemove;
  final Function(int) onUpdateQty;

  const OrderItemCard({
    super.key,
    required this.item,
    required this.formatRupiah,
    required this.onRemove,
    required this.onUpdateQty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar Produk
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                item.produk.imageUrl ?? "https://via.placeholder.com/300",
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.local_cafe, size: 40, color: Colors.brown[300]),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Detail Produk
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.produk.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.azura.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.produk.kategori.toString().split('.').last.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.azura,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        "Harga :",
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Rp ${formatRupiah(item.produk.price * item.qty)}",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.azura,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Qty Controller Elegan
            Container(
              decoration: BoxDecoration(
                color: AppColors.azura,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.azura.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tombol Kurang
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        if (item.qty > 1) {
                          onUpdateQty(item.qty - 1);
                        } else {
                          onRemove();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: const Icon(Icons.remove, color: Colors.white, size: 20),
                      ),
                    ),
                  ),

                  // Jumlah
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "${item.qty}",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Tombol Tambah
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () => onUpdateQty(item.qty + 1),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}