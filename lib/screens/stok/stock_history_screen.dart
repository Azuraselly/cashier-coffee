// lib/screens/stock_history_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StockHistoryScreen extends StatelessWidget {
  final String productName;
  const StockHistoryScreen({super.key, required this.productName});

  // Dummy riwayat stok
  final List<Map<String, dynamic>> dummyHistory = const [
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
      backgroundColor: const Color(0xFFFDFAFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDBB8C8),
        elevation: 0,
        leading: const CloseButton(color: Colors.white),
        title: Text(
          "Riwayat Stok",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Nama produk
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: const Color(0xFFDBB8C8).withOpacity(0.2),
            child: Text(
              productName,
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),

          // List riwayat
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: dummyHistory.length,
              itemBuilder: (context, i) {
                final h = dummyHistory[i];
                final isKurang = h['jumlah'] < 0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.transparent),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 6)),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: isKurang ? Colors.red.shade50 : Colors.green.shade50,
                        child: Icon(
                          isKurang ? Icons.remove : Icons.add,
                          color: isKurang ? Colors.redAccent : Colors.green,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              h['alasan'],
                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Oleh ${h['user']} • ${DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(h['tanggal']))}",
                              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text("${h['old']} → ", style: GoogleFonts.poppins(fontSize: 15)),
                                Text(
                                  "${h['new']}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isKurang ? Colors.redAccent : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isKurang ? Colors.red.shade50 : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          isKurang ? "${h['jumlah']}" : "+${h['jumlah']}",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isKurang ? Colors.redAccent : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}