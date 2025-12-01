// lib/screens/checkout/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:kasir/models/produk.dart';
import 'package:kasir/models/cart_item.dart';
import 'package:kasir/utils/constants.dart';
import 'package:kasir/component/chekout/customer_input.dart';
import 'package:kasir/component/chekout/order_item_card.dart';
import 'package:kasir/component/chekout/payment_method_bottomsheet.dart';
import 'package:kasir/component/chekout/total_summary_card.dart';
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
  final cashCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final vaCtrl = TextEditingController();

  String selectedPayment = "Select Payment Method";
  int discountAmount = 1500;

  late List<CartItem> cartItems;

  @override
  void initState() {
    super.initState();
    _updateCartItems();
    cashCtrl.text = "0";
  }

  void _updateCartItems() {
    cartItems = widget.cart.entries.map((e) {
      final produk = widget.allProduk.firstWhere(
        (p) => p.idProduk == e.key,
        orElse: () => ProdukModel(idProduk: 0, name: "Unknown", price: 0, stock: 0, kategori: KategoriProduk.iced),
      );
      return CartItem(produk: produk, qty: e.value);
    }).toList();
  }

  int get subtotal => cartItems.fold(0, (sum, item) => sum + item.produk.price * item.qty);
  int get total => subtotal - discountAmount;

  String formatRupiah(int amount) {
    if (amount < 0) return "-${formatRupiah(amount.abs())}";
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  void _onPaymentSelected(String method) {
    setState(() {
      selectedPayment = method;
      passwordCtrl.clear();
      vaCtrl.clear();
      if (method == "Tunai") {
        cashCtrl.text = subtotal.toString();
      } else {
        cashCtrl.clear();
      }
    });
  }

  Future<void> _showPaymentBottomSheet() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const PaymentMethodBottomSheet(),
      ),
    );
    if (result != null) {
      _onPaymentSelected(result);
    }
  }

  // ✅ VALIDASI PEMBAYARAN
  bool _isPaymentValid() {
    if (selectedPayment == "Select Payment Method") return false;

    if (selectedPayment == "Tunai") {
      final cash = int.tryParse(cashCtrl.text) ?? 0;
      return cash >= subtotal && cash > 0;
    }

    if (selectedPayment == "QRIS") {
      return passwordCtrl.text.length >= 6; // Minimal 6 digit
    }

    if (selectedPayment == "Kartu Debit/Kredit") {
      return passwordCtrl.text.length >= 4; // Minimal 4 digit (PIN)
    }

    return true;
  }

  @override
  void dispose() {
    customerCtrl.dispose();
    noteCtrl.dispose();
    cashCtrl.dispose();
    passwordCtrl.dispose();
    vaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.azura,
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
                CustomerInput(controller: customerCtrl),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Enjoy Coffee", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBCAAA4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text("Add", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                if (cartItems.isEmpty)
                  const Center(child: Padding(padding: EdgeInsets.all(40), child: Text("Keranjang kosong", style: TextStyle(color: Colors.grey, fontSize: 16))))
                else
                  ...cartItems.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: OrderItemCard(item: item, formatRupiah: formatRupiah),
                      )),

                const SizedBox(height: 10),
                SummaryCard(
                  noteController: noteCtrl,
                  itemCount: cartItems.length,
                  subtotal: subtotal,
                  formatRupiah: formatRupiah,
                ),
                const SizedBox(height: 10),

                // ✅ PAYMENT SECTION DINAMIS — DIPERBAIKI
                _PaymentSection(
                  selected: selectedPayment,
                  onSelected: _showPaymentBottomSheet,
                  subtotal: subtotal,
                  cashCtrl: cashCtrl,
                  passwordCtrl: passwordCtrl,
                  vaCtrl: vaCtrl,
                  formatRupiah: formatRupiah,
                  isCashInsufficient: selectedPayment == "Tunai" &&
                      (int.tryParse(cashCtrl.text) ?? 0) > 0 &&
                      (int.tryParse(cashCtrl.text) ?? 0) < subtotal,
                  isPasswordTooShort: (selectedPayment == "QRIS" && passwordCtrl.text.length > 0 && passwordCtrl.text.length < 6) ||
                      (selectedPayment == "Kartu Debit/Kredit" && passwordCtrl.text.length > 0 && passwordCtrl.text.length < 4),
                ),

                const SizedBox(height: 10),
                PaymentDetailsCard(subtotal: subtotal, discount: discountAmount, total: total, formatRupiah: formatRupiah),
                const SizedBox(height: 100),
              ],
            ),
          ),

          // TOMBOL PAYMENT CONFIRMATION — VALIDASI DINAMIS
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isPaymentValid()
                    ? () {
                        final cashAmount = selectedPayment == "Tunai" ? int.tryParse(cashCtrl.text) ?? 0 : null;
                        final changeAmount = selectedPayment == "Tunai" ? (cashAmount ?? 0) - subtotal : null;

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
                            cashAmount: cashAmount,
                            changeAmount: changeAmount,
                            password: (selectedPayment == "QRIS" || selectedPayment == "Kartu Debit/Kredit")
                                ? passwordCtrl.text
                                : null,
                          ),
                        ).then((_) {
                          // ✅ Clear cart & back
                          widget.cart.clear();
                          Navigator.pop(context); // close checkout

                          // ✅ Opsional: Navigasi ke halaman detail receipt
                          // Uncomment jika ReceiptDetailScreen sudah dibuat
                          /*
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReceiptDetailScreen(
                                customerName: customerCtrl.text.trim().isNotEmpty ? customerCtrl.text.trim() : "customer",
                                items: cartItems,
                                subtotal: subtotal,
                                discount: discountAmount,
                                total: total,
                                paymentMethod: selectedPayment,
                                cashAmount: cashAmount,
                                changeAmount: changeAmount,
                                note: noteCtrl.text,
                                timestamp: DateTime.now(),
                              ),
                            ),
                          );
                          */
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.azura,
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

// ✅ WIDGET DINAMIS: PEMILIHAN + FORM — DIPERBAIKI DENGAN VALIDASI VISUAL
class _PaymentSection extends StatelessWidget {
  final String selected;
  final VoidCallback onSelected;
  final int subtotal;
  final TextEditingController cashCtrl, passwordCtrl, vaCtrl;
  final String Function(int) formatRupiah;
  final bool isCashInsufficient;
  final bool isPasswordTooShort;

  const _PaymentSection({
    required this.selected,
    required this.onSelected,
    required this.subtotal,
    required this.cashCtrl,
    required this.passwordCtrl,
    required this.vaCtrl,
    required this.formatRupiah,
    this.isCashInsufficient = false,
    this.isPasswordTooShort = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tombol Pemilihan
        GestureDetector(
          onTap: onSelected,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.payment, color: Color(0xFFBCAAA4)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selected,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Color(0xFFBCAAA4)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Form Dinamis
        if (selected == "Tunai") ...[
          _CashInput(
            controller: cashCtrl,
            subtotal: subtotal,
            formatRupiah: formatRupiah,
            isInsufficient: isCashInsufficient,
          ),
        ] else if (selected == "QRIS") ...[
          _InfoCard("Scan QR Code di kasir untuk menyelesaikan pembayaran."),
          const SizedBox(height: 12),
          _PasswordField(
            controller: passwordCtrl,
            label: "Konfirmasi Password",
            isTooShort: isPasswordTooShort,
            minLength: 6,
          ),
        ] else if (selected == "Kartu Debit/Kredit") ...[
          _InfoCard("Gesek kartu atau masukkan PIN pada mesin EDC."),
          const SizedBox(height: 12),
          _PasswordField(
            controller: passwordCtrl,
            label: "Masukkan PIN",
            isTooShort: isPasswordTooShort,
            minLength: 4,
          ),
        ],
      ],
    );
  }
}

class _CashInput extends StatelessWidget {
  final TextEditingController controller;
  final int subtotal;
  final String Function(int) formatRupiah;
  final bool isInsufficient;

  const _CashInput({
    required this.controller,
    required this.subtotal,
    required this.formatRupiah,
    this.isInsufficient = false,
  });

  @override
  Widget build(BuildContext context) {
    final cash = int.tryParse(controller.text) ?? 0;
    final change = cash - subtotal;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Jumlah Cash",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(color: isInsufficient ? Colors.red : null),
            decoration: InputDecoration(
              hintText: "Masukkan jumlah uang",
              prefixText: "Rp. ",
              errorText: isInsufficient ? "Uang kurang Rp. ${formatRupiah(subtotal - cash)}" : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isInsufficient ? Colors.red : const Color(0xFFBCAAA4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Kembalian: Rp. ${formatRupiah(change)}",
            style: TextStyle(
              color: change < 0 ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isTooShort;
  final int minLength;

  const _PasswordField({
    required this.controller,
    this.label = "Masukkan Password",
    this.isTooShort = false,
    this.minLength = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            obscureText: true,
            style: TextStyle(color: isTooShort ? Colors.red : null),
            decoration: InputDecoration(
              hintText: "••••••",
              errorText: isTooShort ? "Minimal $minLength digit" : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isTooShort ? Colors.red : const Color(0xFFBCAAA4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String message;

  const _InfoCard(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}