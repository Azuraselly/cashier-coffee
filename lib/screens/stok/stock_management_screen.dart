import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir/services/produk_service.dart';
import 'package:kasir/utils/constants.dart';
import 'package:kasir/models/produk.dart';
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

  late Future<List<ProdukModel>> _produkFuture;
  final ProdukService _produkService = ProdukService();

  @override
  void initState() {
    super.initState();
    _produkFuture = _produkService.getAllProduk();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshData() {
    setState(() {
      _produkFuture = _produkService.getAllProduk();
    });
  }

 void _editStokDialog(ProdukModel produk) {
  final controller = TextEditingController(text: produk.stock.toString());
  final messenger = ScaffoldMessenger.of(context);
  String selectedReason = "Koreksi Manual";

  final List<String> reasons = [
    "Restok",
    "Rusak/Hilang",
    "Koreksi Manual",
    "Lain-lain",
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.7,
      minChildSize: 0.55,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: EdgeInsets.only(
          left: 28,
          right: 28,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle (lebih tipis & modern)
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Header
            Text(
              "Edit Stok",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              produk.name,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),

            // Stock Input – besar, bersih, fokus
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Minus
                    IconButton(
                      onPressed: () {
                        final val = int.tryParse(controller.text) ?? 0;
                        if (val > 0) controller.text = (val - 1).toString();
                      },
                      icon: Icon(Icons.remove_rounded, size: 32, color: Colors.grey.shade700),
                    ),
                    const SizedBox(width: 20),

                    // Angka besar
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: controller,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.poppins(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Plus
                    IconButton(
                      onPressed: () {
                        final val = int.tryParse(controller.text) ?? 0;
                        controller.text = (val + 1).toString();
                      },
                      icon: Icon(Icons.add_rounded, size: 32, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Alasan – chip super minimalis
            Text(
              "Alasan perubahan",
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: reasons.map((reason) {
                final bool isSelected = selectedReason == reason;
                return GestureDetector(
                  onTap: () => setState(() => selectedReason = reason),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.azura : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected ? AppColors.azura : Colors.grey.shade300,
                        width: isSelected ? 0 : 1.5,
                      ),
                    ),
                    child: Text(
                      reason,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const Spacer(),

            // Tombol Simpan – full width, bold, elegan
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: () async {
                  final newStock = int.tryParse(controller.text) ?? produk.stock;
                  if (newStock == produk.stock) {
                    Navigator.pop(context);
                    return;
                  }

                  try {
                    await ProdukService().updateStokWithHistory(
                      idProduk: produk.idProduk,
                      newStock: newStock,
                      reason: selectedReason,
                    );

                    if (mounted) {
                      Navigator.pop(context);
                      _refreshData();
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text("Stok berhasil diperbarui • $selectedReason"),
                          backgroundColor: Colors.green.shade600,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    }
                  } catch (e) {
                    messenger.showSnackBar(
                      SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red.shade600),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.azura,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  "Simpan Perubahan",
                  style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.azura,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.menu, color: Colors.white), onPressed: () => Scaffold.of(context).openDrawer()),
        title: Text("Stock Management", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _refreshData)],
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))),
      ),
      drawer: const SidebarDrawer(),

      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Cari produk...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
              ),
            ),
          ),

          // Kategori — VERSI SUPER CANTIK & MENARIK
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: kategoris.map((kategori) {
        final bool isSelected = selectedKategori == kategori;

        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            child: FilterChip(
              label: Text(
                kategori,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.azura,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => setState(() => selectedKategori = kategori),

              backgroundColor: Colors.white,
              selectedColor: AppColors.azura,
              showCheckmark: false, 
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected ? AppColors.azura : AppColors.azura.withOpacity(0.4),
                  width: isSelected ? 2.2 : 1.8,
                ),
              ),

              elevation: isSelected ? 6 : 1,
              pressElevation: 8,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        );
      }).toList(),
    ),
  ),
),

          const SizedBox(height: 16),

          // List Produk
          Expanded(
            child: FutureBuilder<List<ProdukModel>>(
              future: _produkFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("Belum ada produk", style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey)));
                }

                final filtered = snapshot.data!.where((p) {
                  final matchSearch = p.name.toLowerCase().contains(_searchController.text.toLowerCase());
                  final matchKat = selectedKategori == "Semua" || p.kategori.label == selectedKategori;
                  return matchSearch && matchKat;
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final p = filtered[i];
                    final lowStock = p.stock <= (p.minStock ?? 10);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        children: [
                          // Gambar
                          ClipRRect(
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                            child: p.imageUrl != null
                                ? Image.network(p.imageUrl!, width: 140, height: double.infinity, fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => _placeholder())
                                : _placeholder(),
                          ),

                          // Info
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(p.name, style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  Text(p.kategori.label, style: GoogleFonts.poppins(fontSize: 13, color: Colors.brown[600])),
                                  Row(
                                    children: [
                                      Icon(Icons.inventory_2_outlined, size: 18, color: lowStock ? Colors.redAccent : Colors.green[700]),
                                      const SizedBox(width: 6),
                                      Text("Stok: ${p.stock}", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: lowStock ? Colors.redAccent : Colors.green[700])),
                                      if (lowStock) ...[
                                        const SizedBox(width: 8),
                                        Icon(Icons.warning_amber_rounded, size: 18, color: Colors.orange[700]),
                                      ]
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Tombol
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.grey), onPressed: () => _editStokDialog(p)),
                                IconButton(icon: const Icon(Icons.history_outlined, color: AppColors.azura), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StockHistoryScreen(productName: p.name)))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 140,
      color: const Color(0xFFF5E6D3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.coffee, size: 40, color: Colors.brown[600]),
          const SizedBox(height: 8),
          Text("No Image", style: GoogleFonts.poppins(fontSize: 11, color: Colors.brown[600])),
        ],
      ),
    );
  }
} 

