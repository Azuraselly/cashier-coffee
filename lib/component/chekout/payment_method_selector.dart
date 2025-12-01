// lib/screens/checkout/widgets/payment_method_bottomsheet.dart
import 'package:flutter/material.dart';

class PaymentMethodBottomSheet extends StatelessWidget {
  const PaymentMethodBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final methods = ["Tunai", "QRIS", "Kartu Debit/Kredit", "Transfer Bank"];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: Color(0xFFF8F0E8), borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 80, height: 6, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(3))),
        const SizedBox(height: 32),
        ...methods.map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () => Navigator.pop(context, m),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]),
                  child: Row(children: [Text(m, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)), const Spacer(), const Icon(Icons.check_circle, color: Colors.grey)]),
                ),
              ),
            )),
        const SizedBox(height: 20),
      ]),
    );
  }
}