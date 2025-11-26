// lib/screens/produk/produk_management_screen.dart
import 'package:flutter/material.dart';
import 'package:kasir/component/Tambahproduk.dart';
import 'package:kasir/models/produk.dart';
import 'package:kasir/services/produk_service.dart';
import 'package:kasir/component/produk_card.dart';
import 'package:kasir/component/sidebar_drawer.dart';
import 'package:kasir/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class ProdukManagementScreen extends StatefulWidget {
  const ProdukManagementScreen({super.key});

  @override
  State<ProdukManagementScreen> createState() => _ProdukManagementScreenState();
}

class _ProdukManagementScreenState extends State<ProdukManagementScreen> {
  final ProdukService _service = ProdukService();
  List<ProdukModel> allProduk = [];
  List<ProdukModel> filteredProduk = [];
  bool isLoading = true;

  String searchQuery = '';
  KategoriProduk? filterKategori;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loadProduk();
  }

  Future<void> loadProduk() async {
    setState(() => isLoading = true);
    final data = await _service.getAllProduk();
    setState(() {
      allProduk = data;
      filteredProduk = data;
      isLoading = false;
    });
  }

  void filterProduk() {
    List<ProdukModel> temp = allProduk;

    if (searchQuery.isNotEmpty) {
      temp = temp
          .where(
            (p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }
    if (filterKategori != null) {
      temp = temp.where((p) => p.kategori == filterKategori).toList();
    }

    setState(() => filteredProduk = temp);
  }

  @override
  Widget build(BuildContext context) {
    // Responsif crossAxisCount
    final screenWidth = MediaQuery.of(context).size.width;
    int crossCount = 2;
    if (screenWidth > 600) crossCount = 3;
    if (screenWidth > 900) crossCount = 4;
    if (screenWidth > 1200) crossCount = 5;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarDrawer(),
      backgroundColor: AppColors.background,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(170),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.azura,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(80)),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () =>
                            _scaffoldKey.currentState?.openDrawer(),
                      ),
                      Text(
                        'PRODUCT',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => BottomSheetTambahProduk(
                              onSuccess: loadProduk,
                              produkEdit: null,
                            ),
                          );
                        },
                        child: const CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.add,
                            color: AppColors.azura,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (v) {
                        searchQuery = v;
                        filterProduk();
                      },
                      decoration: InputDecoration(
                        hintText: "Cari produk...",
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.azura,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.azura),
            )
          : RefreshIndicator(
              onRefresh: loadProduk,
              child: GridView.builder(
                padding: EdgeInsets.all(screenWidth > 600 ? 24 : 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  childAspectRatio: 0.78, // rasio terbaik untuk semua ukuran
                  crossAxisSpacing: screenWidth > 600 ? 24 : 16,
                  mainAxisSpacing: screenWidth > 600 ? 24 : 16,
                ),
                itemCount: filteredProduk.length,
                itemBuilder: (ctx, i) {
                  final p = filteredProduk[i];
                  return ProdukCard(
                    produk: p,
                    onEdit: () {}, // _showEditDialog(p)
                    onDelete: () {}, // _showDeleteDialog(p)
                  );
                },
              ),
            ),
    );
  }
}
