// lib/screens/checkout/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:kasir/models/produk.dart';
import 'package:kasir/component/chekout/customer_input.dart';
import 'package:kasir/component/chekout/order_item_card.dart';
import 'package:kasir/component/chekout/note_input.dart';
import 'package:kasir/component/chekout/total_summary_card.dart';
import 'package:kasir/component/chekout/payment_method_selector.dart';
import 'package:kasir/models/cart_item.dart';
import 'package:kasir/component/chekout/payment_details_card.dart';
import 'package:kasir/component/chekout/receipt_dialog.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<int, int> cart;
  final List<ProdukModel> allProduk;

  const CheckoutScreen({super.key, required this.cart, required this.allProduk});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final customerCtrl = TextEditingController(text: "customer");
  final noteCtrl = TextEditingController();
  String selectedPayment = "Select Payment Method";
  int discountAmount = 1500; // sesuai gambar

  late final List<CartItem> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = widget.cart.entries.map((e) {
      final produk = widget.allProduk.firstWhere(
        (p) => p.idProduk == e.key,
        orElse: () => ProdukModel(idProduk: 0, name: "Unknown", price: 0, stock: 0, kategori: KategoriProduk.iced),
      );
      return CartItem(produk: produk, qty: e.value);
    }).toList();
  }

  int get subtotal => cartItems.fold(0, (s, i) => s + i.produk.price * i.qty);
  int get total => subtotal - discountAmount;

  String formatRupiah(int amount) =>
      amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

  @override
  void dispose() {
    customerCtrl.dispose();
    noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFBCAAA4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Order Confirmation", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Konfirmasi pembayaran", style: TextStyle(fontSize: 16, color: Colors.brown)),
                const SizedBox(height: 16),

                // Customer Input
                CustomerInput(controller: customerCtrl),

                const SizedBox(height: 20),

                // Enjoy Coffee + Add Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Enjoy Coffee", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      onPressed: () {}, // nanti buat add menu lagi
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBCAAA4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text("Add", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Daftar Pesanan
                ...cartItems.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OrderItemCard(item: item, formatRupiah: formatRupiah),
                    )),

                const SizedBox(height: 20),

                // Catatan Tambahan
                NoteInput(controller: noteCtrl),

                const SizedBox(height: 20),

                // Total Menu
                TotalSummaryCard(itemCount: cartItems.length, subtotal: subtotal, formatRupiah: formatRupiah),

                const SizedBox(height: 30),

                // Payment Method
                PaymentMethodSelector(selected: selectedPayment, onSelected: (v) => setState(() => selectedPayment = v)),

                const SizedBox(height: 20),

                // Payment Details
                PaymentDetailsCard(subtotal: subtotal, discount: discountAmount, total: total, formatRupiah: formatRupiah),

                const SizedBox(height: 100),
              ],
            ),
          ),

          // Tombol Payment Confirmation
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: selectedPayment == "Select Payment Method"
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (_) => ReceiptDialog(
                            customerName: customerCtrl.text.trim().isEmpty ? "customer" : customerCtrl.text.trim(),
                            items: cartItems,
                            subtotal: subtotal,
                            discount: discountAmount,
                            total: total,
                            paymentMethod: selectedPayment,
                            note: noteCtrl.text,
                          ),
                        ).then((_) {
                          widget.cart.clear();
                          Navigator.pop(context);
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBCAAA4),
                  disabledBackgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 10,
                ),
                child: const Text("Payment Confirmation", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

PaymentMethodSelector({required String selected, required void Function(dynamic v) onSelected}) {
}

