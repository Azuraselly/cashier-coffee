import 'package:flutter/material.dart';

class PaymentDetailsCard extends StatelessWidget {
  final int subtotal, discount, total;
  final String Function(int) formatRupiah;

  const PaymentDetailsCard({super.key, required this.subtotal, required this.discount, required this.total, required this.formatRupiah});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFD9C2C0).withOpacity(0.3), borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        _row("Subtotal", subtotal),
        if (discount > 0) _row("Discounts", discount, isDiscount: true),
        const Divider(color: Colors.white70),
        _row("Total Payment", total, isTotal: true),
      ]),
    );
  }

  Widget _row(String label, int amount, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontSize: isTotal ? 18 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.w500)),
        Text(
          isDiscount ? "-Rp. ${formatRupiah(amount)}" : "Rp. ${formatRupiah(amount)}",
          style: TextStyle(fontSize: isTotal ? 20 : 17, fontWeight: FontWeight.bold, color: isTotal ? const Color(0xFF9B7E9A) : (isDiscount ? Colors.red : Colors.black87)),
        ),
      ]),
    );
  }
}