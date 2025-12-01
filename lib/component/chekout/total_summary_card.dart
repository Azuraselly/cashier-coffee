// lib/screens/checkout/components/summary_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir/utils/constants.dart';

class SummaryCard extends StatelessWidget {
  final TextEditingController noteController;
  final int itemCount;
  final int subtotal;
  final String Function(int) formatRupiah;

  const SummaryCard({
    super.key,
    required this.noteController,
    required this.itemCount,
    required this.subtotal,
    required this.formatRupiah,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Catatan Tambahan
          Row(
            children: [
              Text(
                "Catatan Tambahan :",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                
                  child: TextField(
                    controller: noteController,
                    decoration: InputDecoration(
                      hintText: "",
                      hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
            
            ],
          ),

          const SizedBox(height: 10), 

          // Garis pemisah tipis
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.white,
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total $itemCount menu :",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Text(
                "Rp. ${formatRupiah(subtotal)}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black, 
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}