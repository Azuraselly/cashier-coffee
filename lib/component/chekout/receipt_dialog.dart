import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir/models/cart_item.dart';
import 'package:kasir/utils/constants.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart'; 

class ReceiptDialog extends StatelessWidget {
  final String customerName, paymentMethod, note;
  final List<CartItem> items;
  final int subtotal, discount, total;
  final int? cashAmount;
  final int? changeAmount;

  const ReceiptDialog({
    super.key,
    required this.customerName,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.note,
    this.cashAmount,
    this.changeAmount,
  });

  String formatRupiah(int amount) {
    final sign = amount < 0 ? '-' : '';
    final absAmount = amount.abs().toString();
    return 'Rp${sign} ${absAmount.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  String get currentDateTime => DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now());

  Future<void> _generateAndPrintPdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  AppText.appName,
                  style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Center(child: pw.Text(currentDateTime, style: const pw.TextStyle(fontSize: 15 ))),
              pw.SizedBox(height: 10),

              pw.Text("Pelanggan: $customerName"),
              pw.Text("Metode: $paymentMethod"),
              if (note.isNotEmpty) pw.Text("Catatan: $note"),
              pw.SizedBox(height: 10),
              pw.Divider(),

              pw.Text("Pesanan:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15 )),
              pw.SizedBox(height: 10),
              ...items.map((item) => pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 6),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(child: pw.Text("${item.produk.name} × ${item.qty}")),
                        pw.Text(formatRupiah(item.produk.price * item.qty)),
                      ],
                    ),
                  )),

              pw.Divider(height: 15),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text("Subtotal"),
                pw.Text(formatRupiah(subtotal)),
              ]),
              if (discount > 0)
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Text("Diskon"),
                  pw.Text("-${formatRupiah(discount)}", style: const pw.TextStyle(color: PdfColors.green)),
                ]),
              pw.SizedBox(height: 8),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text("Total Bayar", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15 )),
                pw.Text(formatRupiah(total), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15 )),
              ]),

              if (cashAmount != null) ...[
                pw.SizedBox(height: 10),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Text("Tunai"),
                  pw.Text(formatRupiah(cashAmount!)),
                ]),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Text("Kembalian"),
                  pw.Text(formatRupiah(changeAmount ?? 0), style: const pw.TextStyle(color: PdfColors.green)),
                ]),
              ],

              pw.SizedBox(height: 30),
              pw.Center(child: pw.Text("Terima kasih atas kunjungan Anda ☕", style: const pw.TextStyle(fontSize: 15 ))),
              pw.Center(child: pw.Text("Selamat menikmati!", style: const pw.TextStyle(fontSize: 15 ))),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Struk_${AppText.appName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Success
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.azura,
                size: 80,
              ),
              const SizedBox(height: 10),
              Text(
                "Pembayaran Berhasil!",
                style: GoogleFonts.poppins(
                  fontSize: 18 ,
                  fontWeight: FontWeight.bold,
                  color: AppColors.azura,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                currentDateTime,
                style: GoogleFonts.poppins(fontSize: 15 , color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),

              // Info Ringkas
              _buildModernRow("Pelanggan", customerName.isEmpty ? "Umum" : customerName),
              _buildModernRow("Metode", paymentMethod),
              if (note.isNotEmpty) _buildModernRow("Catatan", note),

              const SizedBox(height: 15),
              Divider(color: Colors.grey.shade300, thickness: 1),

              // Daftar Pesanan
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Pesanan Anda",
                  style: GoogleFonts.poppins(fontSize: 15 , fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              ...items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.produk.name,
                            style: GoogleFonts.poppins(fontSize: 15 , fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          "×${item.qty}",
                          style: GoogleFonts.poppins(fontSize: 15 , color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          formatRupiah(item.produk.price * item.qty),
                          style: GoogleFonts.poppins(fontSize: 15 , fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )),

              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 10),

              // Ringkasan Harga
              _buildPriceRow("Subtotal", subtotal),
              if (discount > 0)
                _buildPriceRow("Diskon", discount, isDiscount: true),
              const SizedBox(height: 10),
              _buildPriceRow("Total Bayar", total, isTotal: true),

              if (cashAmount != null) ...[
                const SizedBox(height: 10),
                _buildPriceRow("Tunai Diterima", cashAmount!),
                _buildPriceRow("Kembalian", changeAmount ?? 0, isChange: true),
              ],

              const SizedBox(height: 30),

              // Tombol Aksi
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _generateAndPrintPdf(context),
                  icon: const Icon(Icons.print_rounded, size: 20),
                  label: Text(
                    "Cetak Struk",
                    style: GoogleFonts.poppins(fontSize: 15 , fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.azura,
                    side: BorderSide(color: AppColors.azura, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.azura,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 8,
                  ),
                  child: Text(
                    "Selesai",
                    style: GoogleFonts.poppins(fontSize: 15 , fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Terima kasih atas kunjungan Anda ☕",
                style: GoogleFonts.poppins(fontSize: 15 , color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 15 , color: Colors.grey[700]),
          ),
          Flexible(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 15 , fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, int amount, {bool isDiscount = false, bool isTotal = false, bool isChange = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 15 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? AppColors.azura : Colors.grey[800],
            ),
          ),
          Text(
            isDiscount ? "-${formatRupiah(amount)}" : formatRupiah(amount),
            style: GoogleFonts.poppins(
              fontSize:  isTotal ? 15 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isDiscount
                  ? Colors.green[700]
                  : isChange
                      ? Colors.green[700]
                      : isTotal
                          ? AppColors.azura
                          : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}