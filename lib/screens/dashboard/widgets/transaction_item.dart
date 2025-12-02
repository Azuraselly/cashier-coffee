import 'package:flutter/material.dart';
import 'package:kasir/utils/constants.dart';

class TransactionItem extends StatelessWidget {
  final String trx;
  final String name;
  final String amount;

  const TransactionItem({super.key, required this.trx, required this.name, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color:AppColors.azura.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.check, color: AppColors.azura, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trx, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(name, style: const TextStyle(fontSize: 12, color: Colors.black)),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
        ],
      ),
    );
  }
}