import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kasir/component/chekout/VoucherBottomSheet.dart';
import 'package:kasir/models/produk.dart';
import 'package:kasir/models/cart_item.dart';
import 'package:kasir/utils/constants.dart';
import 'package:kasir/component/chekout/customer_input.dart';
import 'package:kasir/component/chekout/order_item_card.dart';
import 'package:kasir/component/chekout/payment_method_bottomsheet.dart';
import 'package:kasir/component/chekout/total_summary_card.dart';
import 'package:kasir/component/chekout/payment_details_card.dart';
import 'package:kasir/component/chekout/receipt_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir/component/chekout/voucher_section.dart';
import 'package:kasir/models/voucher.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<int, int> cart;
  final List<ProdukModel> allProduk;

  const CheckoutScreen({
    super.key,
    required this.cart,
    required this.allProduk,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final noteCtrl = TextEditingController();
  final cashCtrl = TextEditingController();

  final TextEditingController _customerController = TextEditingController();
  int? _selectedCustomerId;

  String selectedPayment = "Select Payment Method";
  Voucher? selectedVoucher;
  int get discountAmount {
    if (selectedVoucher == null) return 0;
    if (subtotal < selectedVoucher!.minPurchase) return 0;

    if (selectedVoucher!.isPercentage) {
      int disc = (subtotal * selectedVoucher!.discountValue ~/ 100);
      return selectedVoucher!.maxDiscount != null
          ? disc.clamp(0, selectedVoucher!.maxDiscount!)
          : disc;
    } else {
      return selectedVoucher!.discountValue;
    }
  }

  late List<CartItem> cartItems;

  @override
  void initState() {
    super.initState();
    _updateCartItems();
    cashCtrl.text = "0";

    cashCtrl.addListener(() {
      setState(() {}); // update real-time saat ketik
    });
  }

  void _updateCartItems() {
    cartItems = widget.cart.entries.map((e) {
      final produk = widget.allProduk.firstWhere(
        (p) => p.idProduk == e.key,
        orElse: () => ProdukModel(
          idProduk: 0,
          name: "Unknown",
          price: 0,
          stock: 0,
          kategori: KategoriProduk.iced,
          imageUrl: "",
        ),
      );
      return CartItem(produk: produk, qty: e.value);
    }).toList();
  }

  void _updateQty(CartItem item, int newQty) {
    setState(() {
      if (newQty <= 0) {
        cartItems.remove(item);
        widget.cart.remove(item.produk.idProduk);
      } else {
        final index = cartItems.indexOf(item);
        if (index != -1) {
          cartItems[index] = CartItem(produk: item.produk, qty: newQty);
        }
        widget.cart[item.produk.idProduk] = newQty;
      }
    });
  }

  void _removeItem(CartItem item) {
    setState(() {
      cartItems.remove(item);
      widget.cart.remove(item.produk.idProduk);
    });
  }

  int get subtotal =>
      cartItems.fold(0, (sum, item) => sum + item.produk.price * item.qty);
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
      if (method == "Tunai") {
        cashCtrl.text = "0";
      } else {
        cashCtrl.clear();
      }
    });
  }

  Future<void> _showVoucherBottomSheet() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VoucherBottomSheet(
        onVoucherSelected: (voucher) {
          setState(() => selectedVoucher = voucher);
        },
        subtotal: subtotal,
      ),
    );
  }

  Future<void> _showPaymentBottomSheet() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PaymentMethodBottomSheet(),
    );
    if (result != null) {
      _onPaymentSelected(result);
    }
  }

  // VALIDASI UANG KURANG / BELUM ISI
  bool _isPaymentValid() {
    if (selectedPayment == "Select Payment Method") return false;

    if (selectedPayment == "Tunai") {
      final cleaned = cashCtrl.text.replaceAll('.', '').trim();
      if (cleaned.isEmpty || cleaned == "0") return false;
      final cash = int.tryParse(cleaned) ?? 0;
      return cash >= total; // HARUS cukup atau lebih
    }

    if (selectedPayment == "QRIS") return true;

    return false;
  }

  @override
  void dispose() {
    _customerController.dispose();
    noteCtrl.dispose();
    cashCtrl.dispose();
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
        title: Text(
          "Konfirmasi Pesanan",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomerInput(controller: _customerController),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Daftar Pesanan",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      label: Text(
                        "Tambah Menu",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.azura,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (cartItems.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 80),
                      child: Column(
                        children: [
                          Icon(
                            Icons.shopping_basket_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Keranjang kosong",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...cartItems.asMap().entries.map((e) {
                    final item = e.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: OrderItemCard(
                        item: item,
                        formatRupiah: formatRupiah,
                        onRemove: () => _removeItem(item),
                        onUpdateQty: (newQty) => _updateQty(item, newQty),
                      ),
                    );
                  }),

                const SizedBox(height: 10),
                SummaryCard(
                  noteController: noteCtrl,
                  itemCount: cartItems.fold(0, (sum, i) => sum + i.qty),
                  subtotal: subtotal,
                  formatRupiah: formatRupiah,
                ),

                const SizedBox(height: 10),
                VoucherSection(
                  selectedVoucher: selectedVoucher,
                  onSelectVoucher: _showVoucherBottomSheet,
                  subtotal: subtotal,
                ),
                const SizedBox(height: 10),

                _PaymentSection(
                  selected: selectedPayment,
                  onSelected: _showPaymentBottomSheet,
                  total: total,
                  cashCtrl: cashCtrl,
                  formatRupiah: formatRupiah,
                ),
                const SizedBox(height: 10),

                PaymentDetailsCard(
                  subtotal: subtotal,
                  discount: discountAmount,
                  total: total,
                  formatRupiah: formatRupiah,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: _isPaymentValid()
                    ? () {
                        final cleaned = cashCtrl.text.replaceAll('.', '');
                        final cashAmount = selectedPayment == "Tunai"
                            ? int.tryParse(cleaned) ?? 0
                            : null;
                        final changeAmount = selectedPayment == "Tunai"
                            ? cashAmount! - total
                            : null;

                        showDialog(
                          context: context,
                          builder: (_) => ReceiptDialog(
                            customerName:
                                _customerController.text.trim().isEmpty
                                ? "Umum"
                                : _customerController.text.trim(),
                            items: cartItems,
                            subtotal: subtotal,
                            discount: discountAmount,
                            total: total,
                            paymentMethod: selectedPayment,
                            note: noteCtrl.text,
                            cashAmount: cashAmount,
                            changeAmount: changeAmount,
                          ),
                        ).then((_) {
                          widget.cart.clear();
                          Navigator.pop(context);
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.azura,
                  disabledBackgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  elevation: 8,
                ),
                child: Text(
                  "Konfirmasi Pembayaran",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentSection extends StatelessWidget {
  final String selected;
  final VoidCallback onSelected;
  final int total;
  final TextEditingController cashCtrl;
  final String Function(int) formatRupiah;

  const _PaymentSection({
    required this.selected,
    required this.onSelected,
    required this.total,
    required this.cashCtrl,
    required this.formatRupiah,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Metode Pembayaran",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.grey[900],
          ),
        ),
        const SizedBox(height: 16),

        // Selector modern
        InkWell(
          onTap: onSelected,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  selected == "Tunai"
                      ? Icons.payments_rounded
                      : Icons.qr_code_scanner_rounded,
                  color: AppColors.azura,
                  size: 15,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    selected,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Tunai
        if (selected == "Tunai")
          _CashInputModern(
            controller: cashCtrl,
            total: total,
            formatRupiah: formatRupiah,
          ),

        // QRIS
        if (selected == "QRIS")
          Center(
            child: Column(
              children: [
                Text(
                  "Scan QRIS untuk membayar",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "images/kodeqr.jpg",
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.qr_code_2,
                              size: 140,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        "Total Tagihan",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Rp ${formatRupiah(total)}",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.azura,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Konfirmasi pembayaran setelah scan berhasil",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _CashInputModern extends StatelessWidget {
  final TextEditingController controller;
  final int total;
  final String Function(int) formatRupiah;

  const _CashInputModern({
    required this.controller,
    required this.total,
    required this.formatRupiah,
  });

  @override
  Widget build(BuildContext context) {
    final cleaned = controller.text.replaceAll('.', '').trim();
    final cash = cleaned.isEmpty ? 0 : (int.tryParse(cleaned) ?? 0);
    final change = cash >= total ? cash - total : 0;

    final bool isEmpty = cleaned.isEmpty || cleaned == "0";
    final bool isInsufficient = !isEmpty && cash < total;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Masukkan jumlah uang tunai",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),

          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              prefixText: "Rp ",
              prefixStyle: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              errorText: isInsufficient
                  ? "Uang tidak cukup"
                  : isEmpty
                  ? "Masukkan jumlah uang"
                  : null,
              errorStyle: GoogleFonts.poppins(
                color: Colors.red[600],
                fontSize: 14,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: AppColors.azura, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.red[400]!, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Tagihan",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                "Rp ${formatRupiah(total)}",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Kembalian",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Rp ${formatRupiah(change)}",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: cash >= total ? Colors.green[700] : Colors.grey[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
