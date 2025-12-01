// lib/screens/stock/stock_history_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kasir/utils/constants.dart';

class StockHistoryScreen extends StatelessWidget {
  final String productName;
  const StockHistoryScreen({super.key, required this.productName});

  final List<Map<String, dynamic>> history = const [
    {
      "jumlah": -5,
      "alasan": "Penjualan",
      "user": "Kasir A",
      "tanggal": "2025-04-05T14:30:00",
      "old": 28,
      "new": 23
    },
    {
      "jumlah": 30,
      "alasan": "Restok",
      "user": "Admin",
      "tanggal": "2025-04-04T09:15:00",
      "old": 0,
      "new": 30
    },
    {
      "jumlah": -3,
      "alasan": "Rusak",
      "user": "Kasir B",
      "tanggal": "2025-04-03T16:45:00",
      "old": 30,
      "new": 27
    },
    {
      "jumlah": -2,
      "alasan": "Koreksi Stok",
      "user": "Owner",
      "tanggal": "2025-04-01T11:20:00",
      "old": 29,
      "new": 27
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF2D1B1B),
        leading: const CloseButton(),
        title: Text("Riwayat Stok", style: GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          // Header Produk
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.azura, AppColors.selly]),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: AppColors.selly.withOpacity(0.15), blurRadius: 4, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  const Icon(Icons.inventory_2_rounded, color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(productName,
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),

          // Daftar Riwayat — PAKAI SLIVERLIST = DIJAMIN TIDAK MERAH!
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final h = history[index];
                final isMinus = h['jumlah'] < 0;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor: isMinus ? Colors.red.shade50 : Colors.green.shade50,
                        child: Icon(
                          isMinus ? Icons.remove_rounded : Icons.add_rounded,
                          color: isMinus ? Colors.redAccent : Colors.green,
                          size: 32,
                        ),
                      ),
                      title: Text(
                        h['alasan'],
                        style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Oleh ${h['user']}", style: GoogleFonts.poppins(fontSize: 14, color: Colors.brown.shade600)),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('EEEE, dd MMMM yyyy • HH:mm', 'id_ID').format(DateTime.parse(h['tanggal'])),
                            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isMinus ? "${h['jumlah']}" : "+${h['jumlah']}",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isMinus ? Colors.redAccent : Colors.green,
                            ),
                          ),
                          Text(
                            "→ ${h['new']} stok",
                            style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: history.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }
}