// lib/screens/checkout/components/payment_method_bottomsheet.dart
import 'package:flutter/material.dart';

class PaymentMethodBottomSheet extends StatelessWidget {
  const PaymentMethodBottomSheet({super.key});

  final List<Map<String, dynamic>> methods = const [
    {"title": "Tunai", "icon": Icons.attach_money},
    {"title": "QRIS", "icon": Icons.qr_code_scanner},
    {"title": "Kartu Debit/Kredit", "icon": Icons.credit_card},
    {"title": "Transfer Bank", "icon": Icons.account_balance},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFFF5E6D3),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 80, height: 6, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(3))),
          const SizedBox(height: 32),
          const Text("Pilih Metode Pembayaran", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ...methods.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context, m["title"] as String),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                    ),
                    child: Row(
                      children: [
                        Icon(m["icon"] as IconData, size: 32, color: const Color(0xFFBCAAA4)),
                        const SizedBox(width: 20),
                        Text(m["title"] as String, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                        const Spacer(),
                        const Icon(Icons.check_circle, color: Colors.grey),
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