import 'package:flutter/material.dart';
import 'package:kasir/utils/constants.dart';

class PaymentMethodBottomSheet extends StatelessWidget {
  final List<Map<String, dynamic>> methods = const [
    {"title": "Tunai", "icon": Icons.attach_money},
    {"title": "QRIS", "icon": Icons.qr_code_scanner},
    {"title": "Kartu Debit/Kredit", "icon": Icons.credit_card},

  ];

  const PaymentMethodBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         
          Container(
            width: 80,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 32),

          // Judul
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Payment methods",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Daftar Metode Pembayaran
          ...methods.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context, m["title"] as String),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.azura, 
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            m["icon"] as IconData,
                            size: 24,
                            color: AppColors.azura,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            m["title"] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}