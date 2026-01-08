import 'package:flutter/material.dart';
import 'package:kasir/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethodBottomSheet extends StatelessWidget {
  final List<Map<String, dynamic>> methods = const [
    {"title": "Tunai", "icon": Icons.attach_money},
    {"title": "QRIS", "icon": Icons.qr_code_scanner},
  ];

  const PaymentMethodBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(width: 80, height: 6, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(3))),
          const SizedBox(height: 32),

          Text("Pilih Metode Pembayaran", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),

          const SizedBox(height: 24),

          ...methods.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context, m["title"] as String),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: AppColors.azura,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4))],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Icon(m["icon"] as IconData, size: 28, color: AppColors.azura),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          m["title"] as String,
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}