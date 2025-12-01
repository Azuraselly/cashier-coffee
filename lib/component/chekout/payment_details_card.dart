// lib/component/checkout/payment_details_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir/utils/constants.dart';

class PaymentDetailsCard extends StatelessWidget {
  final int subtotal, discount, total;
  final String Function(int) formatRupiah;

  const PaymentDetailsCard({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.formatRupiah,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0,4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Payment Details",
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // Subtotal
          _buildDetailRow(
            label: "Subtotal",
            value: "Rp. ${formatRupiah(subtotal)}",
            icon: Icons.receipt_outlined,
            iconColor: Colors.grey[600]!,
          ),

          // Discount (jika ada)
          if (discount > 0)
            _buildDetailRow(
              label: "Discount",
              value: "-Rp. ${formatRupiah(discount)}",
              icon: Icons.discount_outlined,
              iconColor: Colors.red,
              isNegative: true,
            ),

          // Garis pemisah
          const SizedBox(height: 12),
          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
          const SizedBox(height: 12),

          // Total Payment — highlight!
          _buildDetailRow(
            label: "Total Payment",
            value: "Rp. ${formatRupiah(total)}",
            icon: Icons.attach_money,
            iconColor: AppColors.azura, // coklat tua elegan
            isTotal: true,
            boldLabel: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    bool isNegative = false,
    bool isTotal = false,
    bool boldLabel = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: boldLabel ? FontWeight.w600 : FontWeight.w500,
              color: isTotal ? AppColors.azura : Colors.black,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 19 : 17,
              fontWeight: FontWeight.bold,
              color: isTotal
                  ? AppColors.azura
                  : isNegative
                      ? Colors.red
                      : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}