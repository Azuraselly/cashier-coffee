import 'package:flutter/material.dart';
import 'package:kasir/utils/constants.dart';
import 'payment_method_bottomsheet.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selected;
  final Function(String) onSelected;

  const PaymentMethodSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await showModalBottomSheet<String>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) => const PaymentMethodBottomSheet(),
        );
        if (result != null && result.isNotEmpty) {
          onSelected(result);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Row(
          children: [
            const Icon(Icons.payment_rounded, color: Color(0xFFB38686), size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                selected,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}