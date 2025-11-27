import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'stock_history_screen.dart';

class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({super.key});
  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedKategori = "Semua";

  final List<String> kategoris = [
    "Semua", "Iced Drink", "Hot Drink", "Milkshake", "Tea", "Snack"
  ];

  final List<Map<String, dynamic>> dummyProducts = [
    {"id": 1, "nama": "Tiramisu Clod", "stok": 6, "kategori": "Iced Drink"},
    {"id": 2, "nama": "Matcha", "stok": 4, "kategori": "Iced Drink"},
    {"id": 3, "nama": "Cappuccino", "stok": 18, "kategori": "Hot Drink"},
    {"id": 4, "nama": "Dark Cherry", "stok": 14, "kategori": "Iced Drink"},
    {"id": 5, "nama": "Miso Caramel", "stok": 10, "kategori": "Milkshake"},
    {"id": 6, "nama": "Iced Latte", "stok": 20, "kategori": "Iced Drink"},
    {"id": 7, "nama": "Mocha Coffee", "stok": 17, "kategori": "Hot Drink"},
    {"id": 8, "nama": "Vanilla Milkshake", "stok": 8, "kategori": "Milkshake"},
  ];

  List<Map<String, dynamic>> get filteredProducts {
    return dummyProducts.where((p) {
      final matchSearch = p['nama']
          .toString()
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());
      final matchKategori = selectedKategori == "Semua" || p['kategori'] == selectedKategori;
      return matchSearch && matchKategori;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F0F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDBB8C8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Stock Management",
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
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: const Icon(Icons.qr_code_scanner, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: kategoris.map((kategori) {
                final isSelected = selectedKategori == kategori;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(
                      kategori,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => setState(() => selectedKategori = kategori),
                    selectedColor: const Color(0xFFDBB8C8),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: isSelected ? Colors.transparent : Colors.grey.shade300,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final p = filteredProducts[index];
                final lowStock = p['stok'] <= 10;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey[200],
                          child: const Icon(Icons.coffee, size: 30, color: Colors.brown),
                        ),
                        if (lowStock)
                          const Positioned(
                            top: -4,
                            right: -4,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.warning_amber_rounded, size: 14, color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      p['nama'],
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      "Stok: ${p['stok']}",
                      style: GoogleFonts.poppins(
                        color: lowStock ? Colors.red : Colors.grey[700],
                        fontWeight: lowStock ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.history, color: Color(0xFFDBB8C8), size: 28),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StockHistoryScreen(productName: p['nama']),
                          ),
                        );
                      },
                    ),
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