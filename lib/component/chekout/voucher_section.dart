import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir/models/voucher.dart';
import 'package:kasir/utils/constants.dart';

class VoucherSection extends StatelessWidget {
  final Voucher? selectedVoucher;
  final VoidCallback onSelectVoucher;
  final int subtotal; // Untuk cek eligibility

  const VoucherSection({
    super.key,
    this.selectedVoucher,
    required this.onSelectVoucher,
    required this.subtotal,
  });

  @override
  Widget build(BuildContext context) {
    final isEligible = selectedVoucher == null || subtotal >= selectedVoucher!.minPurchase;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.selly, AppColors.azura], // Warna orange ala Shopee
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.selly.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_offer_rounded, // Icon voucher ala Shopee
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedVoucher?.title ?? "Gunakan Voucher Diskon",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedVoucher?.description ?? "Pilih voucher untuk hemat lebih banyak!",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                if (!isEligible) 
                  Text(
                    "Belanja min Rp ${formatRupiah(selectedVoucher!.minPurchase)} untuk pakai voucher ini",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.red.shade100,
                    ),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onSelectVoucher,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.selly,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(selectedVoucher == null ? "Pilih" : "Ganti"),
          ),
        ],
      ),
    );
  }
}

formatRupiah(int minPurchase) {
}