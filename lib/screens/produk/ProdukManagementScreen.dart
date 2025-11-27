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
      _applyFilters();
      isLoading = false;
    });
  }

  void _applyFilters() {
    List<ProdukModel> temp = allProduk;

    if (searchQuery.isNotEmpty) {
      temp = temp
          .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    if (filterKategori != null) {
      temp = temp.where((p) => p.kategori == filterKategori).toList();
    }

    setState(() => filteredProduk = temp);
  }


 @override
Widget build(BuildContext context) {
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
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
                          builder: (_) => BottomSheetTambahProduk(
                            onSuccess: loadProduk,
                            produkEdit: null,
                          ),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.add, color: AppColors.azura, size: 32),
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
                      _applyFilters();
                    },
                    decoration: InputDecoration(
                      hintText: "Cari produk...",
                      hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
                      prefixIcon: const Icon(Icons.search, color: AppColors.azura),
                      prefixIconConstraints: const BoxConstraints(minWidth: 40),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(top: 16, bottom: 16, left: 10),
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

    body: Column(
      children: [

        Container(
          width: double.infinity,
          color: AppColors.background,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [

                _buildCategoryPill("Semua", isAll: true),
                const SizedBox(width: 12),
                ...KategoriProduk.values.map((kategori) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _buildCategoryPill(kategori.label, kategori: kategori),
                    )),
              ],
            ),
          ),
        ),

        // Produk Grid
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.azura))
              : RefreshIndicator(
                  onRefresh: loadProduk,
                  child: filteredProduk.isEmpty
                      ? Center(
                          child: Text(
                            filterKategori == null && searchQuery.isEmpty
                                ? "Belum ada produk"
                                : "Tidak ditemukan produk",
                            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
                          ),
                        )
                      : GridView.builder(
                          padding: EdgeInsets.all(screenWidth > 600 ? 24 : 16),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossCount,
                            childAspectRatio: 0.78,
                            crossAxisSpacing: screenWidth > 600 ? 24 : 16,
                            mainAxisSpacing: screenWidth > 600 ? 24 : 16,
                          ),
                          itemCount: filteredProduk.length,
                          itemBuilder: (ctx, i) {
                            final p = filteredProduk[i];
                            return ProdukCard(
                              produk: p,
                              onEdit: () {},
                              onDelete: () async {
                                final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("Hapus Produk"),
                                        content: Text("Yakin ingin menghapus ${p.name}?"),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    ) ??
                                    false;

                                if (confirm) {
                                  await _service.deleteProduk(p.idProduk);
                                  loadProduk();
                                }
                              },
                            );
                          },
                        ),
                ),
        ),
      ],
  ),
  );
}

Widget _buildCategoryPill(String label, {KategoriProduk? kategori, bool isAll = false}) {
  final bool isSelected = isAll ? filterKategori == null : filterKategori == kategori;

  return GestureDetector(
    onTap: () {
      setState(() {
        filterKategori = isAll ? null : kategori;
        _applyFilters();
      });
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.azura : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.azura, width: 1.8),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : AppColors.azura,
        ),
      ),
    ),
  );
}
}