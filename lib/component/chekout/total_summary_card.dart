// lib/screens/checkout/components/total_summary_card.dart
import 'package:flutter/material.dart';

class TotalSummaryCard extends StatelessWidget {
  final int itemCount, subtotal;
  final String Function(int) formatRupiah;
  const TotalSummaryCard({super.key, required this.itemCount, required this.subtotal, required this.formatRupiah});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text("Total $itemCount menu :", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text("Rp. ${formatRupiah(subtotal)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF8D6E63))),
      ]),
    );
  }
}