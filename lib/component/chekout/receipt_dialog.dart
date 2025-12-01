// lib/screens/checkout/components/receipt_dialog.dart
import 'package:flutter/material.dart';
import 'package:kasir/models/cart_item.dart';

class ReceiptDialog extends StatelessWidget {
  final String customerName, paymentMethod, note;
  final List<CartItem> items;
  final int subtotal, discount, total;

  const ReceiptDialog({
    super.key,
    required this.customerName,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.note,
  });

  String formatRupiah(int amount) => amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.receipt_long, size: 70, color: Color(0xFFD9C2C0)),
          const SizedBox(height: 16),
          const Text("Pembayaran Berhasil!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6B4E3D))),
          const SizedBox(height: 20),
          Text("Customer: $customerName", style: const TextStyle(fontSize: 18)),
          const Divider(height: 30),
          ...items.map((i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("${i.produk.name} ×${i.qty}"),
                  Text("Rp. ${formatRupiah(i.produk.price * i.qty)}"),
                ]),
              )),
          const Divider(height: 30),
          _row("Subtotal", subtotal),
          if (discount > 0) _row("Discount", discount, isDiscount: true),
          _row("Total", total, isTotal: true),
          const SizedBox(height: 10),
          Text("Metode: $paymentMethod", style: const TextStyle(fontWeight: FontWeight.bold)),
          if (note.isNotEmpty) Text("Catatan: $note", style: const TextStyle(fontStyle: FontStyle.italic)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD9C2C0), padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
            child: const Text("Selesai", style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ]),
      ),
    );
  }

  Widget _row(String label, int amount, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.w500, fontSize: isTotal ? 18 : 16)),
        Text(
          isDiscount ? "-Rp. ${formatRupiah(amount)}" : "Rp. ${formatRupiah(amount)}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTotal ? 22 : 17, color: isTotal ? const Color(0xFF9B7E9A) : Colors.black87),
        ),
      ]),
    );
  }
}
