import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir/models/voucher.dart';

class VoucherBottomSheet extends StatelessWidget {
  final Function(Voucher?) onVoucherSelected;
  final int subtotal;

  const VoucherBottomSheet({
    super.key,
    required this.onVoucherSelected,
    required this.subtotal,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              "Pilih Voucher",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount:
                    availableVouchers.length +
                    1, // +1 untuk option tanpa voucher
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ListTile(
                      leading: const Icon(Icons.clear, color: Colors.red),
                      title: Text(
                        "Tanpa Voucher",
                        style: GoogleFonts.poppins(),
                      ),
                      onTap: () {
                        onVoucherSelected(null);
                        Navigator.pop(context);
                      },
                    );
                  }
                  final voucher = availableVouchers[index - 1];
                  final isEligible = subtotal >= voucher.minPurchase;
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color: isEligible
                        ? Colors.orange.shade50
                        : Colors.grey.shade200,
                    child: ListTile(
                      leading: Icon(
                        Icons.discount_rounded,
                        color: isEligible ? Colors.orange : Colors.grey,
                      ),
                      title: Text(
                        voucher.title,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(voucher.description),
                      trailing: ElevatedButton(
                        onPressed: isEligible
                            ? () {
                                onVoucherSelected(voucher);
                                Navigator.pop(context);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Pakai"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
