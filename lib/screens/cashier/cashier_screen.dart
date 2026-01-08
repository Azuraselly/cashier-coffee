import 'package:flutter/material.dart';
import 'package:kasir/models/produk.dart';
import 'package:kasir/utils/constants.dart';
import 'package:kasir/component/cashier/carousel_card.dart';
import 'package:kasir/screens/cashier/checkout_screen.dart';
import 'package:kasir/component/cashier/kategori_tab.dart';
import 'package:kasir/component/cashier/coffee_card.dart';
import 'package:kasir/component/sidebar_drawer.dart';
import 'package:kasir/services/produk_service.dart';
import 'package:google_fonts/google_fonts.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  final ProdukService _service = ProdukService();
  final TextEditingController _searchController = TextEditingController();

  // null = Semua kategori
  KategoriProduk? selectedKategori;

  List<ProdukModel> allProduk = [];
  bool isLoading = true;

  final Map<int, int> cart = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int get totalItems => cart.values.fold(0, (a, b) => a + b);

  int get totalPrice => cart.entries.fold(0, (sum, e) {
        final produk = allProduk.firstWhere(
          (p) => p.idProduk == e.key,
          orElse: () => ProdukModel(
            idProduk: 0,
            name: "",
            price: 0,
            stock: 0,
            kategori: KategoriProduk.iced,
            imageUrl: "",
          ),
        );
        return sum + (e.value * produk.price);
      });

  // Filter search dulu
  List<ProdukModel> get searchedProduk {
    if (_searchController.text.isEmpty) return allProduk;
    final query = _searchController.text.toLowerCase();
    return allProduk.where((p) => p.name.toLowerCase().contains(query)).toList();
  }

  // Carousel: ikut kategori + search
  List<ProdukModel> get featured {
    var list = searchedProduk;
    if (selectedKategori != null) {
      list = list.where((p) => p.kategori == selectedKategori).toList();
    }
    return list.take(5).toList();
  }

  // List scroll: hanya Spesial Coffee + ikut search
  List<ProdukModel> get spesialCoffee {
    final query = _searchController.text.toLowerCase();
    return searchedProduk.where((p) => p.name.toLowerCase().contains('coffee')).toList();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadProduk();
    // Pastikan search langsung responsif
    _searchController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _loadProduk() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      final data = await _service.getAllProduk();
      if (mounted) {
        setState(() {
          allProduk = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat produk: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarDrawer(),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Background biru atas
            Container(
              height: 420,
              decoration: const BoxDecoration(
                color: AppColors.azura,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(42)),
              ),
            ),

            Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                          ),
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Good Morning",
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Grab a coffee, make life less bland",
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 20),

                      // SEARCH - REAL-TIME
                      TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() {}), // Backup responsif
                        decoration: InputDecoration(
                          hintText: "Cari produk...",
                          hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                          prefixIcon: const Icon(Icons.search, color: AppColors.azura),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () => _searchController.clear(),
                                )
                              : null,
                          filled: true,
                          fillColor: const Color(0xFFF2F2F2),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // TAB KATEGORI + "SEMUA"
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            KategoriTab(
                              kategori: KategoriProduk.iced, // dummy
                              labelOverride: "Semua",
                              isActive: selectedKategori == null,
                              onTap: () => setState(() => selectedKategori = null),
                            ),
                            const SizedBox(width: 8),
                            ...KategoriProduk.values.map((kat) => KategoriTab(
                                  kategori: kat,
                                  isActive: selectedKategori == kat,
                                  onTap: () => setState(() => selectedKategori = kat),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // KONTEN SCROLLABLE
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadProduk,
                    color: AppColors.azura,
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator(color: AppColors.azura))
                        : ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              // CAROUSEL: ikut kategori + search
                              if (featured.isNotEmpty)
                                SizedBox(
                                  height: 320,
                                  child: PageView.builder(
                                    padEnds: false,
                                    controller: PageController(viewportFraction: 0.58),
                                    clipBehavior: Clip.none,
                                    itemCount: featured.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: CarouselCard(
                                          produk: featured[index],
                                          cart: cart,
                                          onCartChanged: () => setState(() {}),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              else
                                const SizedBox(
                                  height: 320,
                                  child: Center(
                                    child: Text(
                                      "Tidak ada produk di kategori ini",
                                      style: TextStyle(color: Colors.grey, fontSize: 16),
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 30),

                              // JUDUL SPESIAL COFFEE
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "Spesial Coffee",
                                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // LIST SPESIAL COFFEE SAJA (ikut search)
                              if (spesialCoffee.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                                  child: Center(
                                    child: Text(
                                      "Belum ada produk dengan nama 'coffee'",
                                      style: TextStyle(color: Colors.grey, fontSize: 16),
                                    ),
                                  ),
                                )
                              else
                                ...spesialCoffee.map((produk) => Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                      child: SpecialCoffeeCard(
                                        produk: produk,
                                        cart: cart,
                                        onCartChanged: () => setState(() {}),
                                      ),
                                    )),

                              const SizedBox(height: 120),
                            ],
                          ),
                  ),
                ),
              ],
            ),

            // TOMBOL CHECKOUT
            if (totalItems > 0)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  
                  decoration: BoxDecoration(
                    color: AppColors.azura.withOpacity(0.98),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, -5))],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 28),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: Text("$totalItems", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}",
                        style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CheckoutScreen(cart: cart, allProduk: allProduk)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.azura,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        child: const Text("Checkout", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}