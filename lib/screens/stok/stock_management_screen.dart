// lib/screens/stok/stock_management_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir/utils/constants.dart';
import 'stock_history_screen.dart';
import 'package:kasir/component/sidebar_drawer.dart';

class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({super.key});
  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedKategori = "Semua";

  final List<String> kategoris = [
    "Semua",
    "Iced Drink",
    "Hot Drink",
    "Milkshake",
    "Tea",
    "Snack",
  ];

  final List<Map<String, dynamic>> dummyProducts = [
    {
      "id": 1,
      "nama": "Tiramisu Clod",
      "stok": 6,
      "kategori": "Iced Drink",
      "image": "Tiramisu",
    },
    {
      "id": 2,
      "nama": "Matcha",
      "stok": 4,
      "kategori": "Iced Drink",
      "image": "Matcha",
    },
    {
      "id": 3,
      "nama": "Cappuccino",
      "stok": 18,
      "kategori": "Hot Drink",
      "image": "Cappuccino",
    },
    {
      "id": 4,
      "nama": "Dark Cherry",
      "stok": 14,
      "kategori": "Iced Drink",
      "image": "Dark_Cherry",
    },
    {
      "id": 5,
      "nama": "Miso Caramel",
      "stok": 10,
      "kategori": "Milkshake",
      "image": "Miso_Caramel",
    },
    {
      "id": 6,
      "nama": "Iced Latte",
      "stok": 20,
      "kategori": "Iced Drink",
      "image": "Iced_Latte",
    },
    {
      "id": 7,
      "nama": "Mocha Coffee",
      "stok": 17,
      "kategori": "Hot Drink",
      "image": "Mocha_Coffee",
    },
    {
      "id": 8,
      "nama": "Vanilla Milkshake",
      "stok": 8,
      "kategori": "Milkshake",
      "image": "Vanilla_Milkshake",
    },
  ];

  List<Map<String, dynamic>> get filteredProducts {
    return dummyProducts.where((p) {
      final matchSearch = p['nama'].toString().toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );
      final matchKategori =
          selectedKategori == "Semua" || p['kategori'] == selectedKategori;
      return matchSearch && matchKategori;
    }).toList();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // POP UP EDIT STOK (tetap ada)
  void _editStokDialog(Map<String, dynamic> product) {
    final TextEditingController stokController = TextEditingController(
      text: product['stok'].toString(),
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        maxChildSize: 0.6,
        minChildSize: 0.3,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Edit Stok",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product['nama'],
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 30),

              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      int val = int.tryParse(stokController.text) ?? 0;
                      if (val > 0) stokController.text = (val - 1).toString();
                    },
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Colors.redAccent,
                      size: 38,
                    ),
                  ),

                  Expanded(
                    child: TextField(
                      controller: stokController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      int val = int.tryParse(stokController.text) ?? 0;
                      stokController.text = (val + 1).toString();
                    },
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.green,
                      size: 38,
                    ),
                  ),
                ],
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.azura,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      product['stok'] =
                          int.tryParse(stokController.text) ?? product['stok'];
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Simpan Perubahan",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarDrawer(),
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.azura,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 30),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
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
                hintText: "Cari produk...",
                hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: const Color(0xfff2f2f2),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Kategori Chips
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
                    onSelected: (_) =>
                        setState(() => selectedKategori = kategori),
                    selectedColor: AppColors.azura,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : AppColors.azura,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Daftar Produk dengan GAMBAR CANTIK
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final p = filteredProducts[index];
                final lowStock = p['stok'] <= 10;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/images/${p['image']}.png", // GAMBAR PRODUK
                        width: 110,
                        height: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 110,
                          height: 160,
                          color: Colors.brown[100],
                          child: const Icon(
                            Icons.coffee,
                            size: 40,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      p['nama'],
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['kategori'],
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.brown[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 18,
                              color: lowStock ? Colors.redAccent : Colors.green,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Stok: ${p['stok']}",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: lowStock
                                    ? Colors.redAccent
                                    : Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (lowStock)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                          ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _editStokDialog(p),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.history,
                            color: AppColors.azura,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    StockHistoryScreen(productName: p['nama']),
                              ),
                            );
                          },
                        ),
                      ],
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
