// lib/screens/cashier/cashier_screen.dart
import 'package:flutter/material.dart';
import 'package:kasir/models/produk.dart';
import 'package:kasir/utils/constants.dart';
import 'package:kasir/component/cashier/carousel_card.dart';
import 'package:kasir/screens/cashier/checkout_screen.dart';
import 'package:kasir/component/cashier/kategori_tab.dart';
import 'package:kasir/component/cashier/coffee_card.dart';
import 'package:kasir/component/sidebar_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  KategoriProduk selectedKategori = KategoriProduk.iced;

  final List<ProdukModel> allProduk = [
  ProdukModel(
    idProduk: 1,
    name: "Oreo Smootie",
    price: 32000,
    stock: 50,
    kategori: KategoriProduk.iced,
    imageUrl: "assets/images/Mocha_Coffee.png", // TAMBAH INI!
  ),
  ProdukModel(
    idProduk: 2,
    name: "Tiramisu ",
    price: 28000,
    stock: 30,
    kategori: KategoriProduk.iced,
    imageUrl: "assets/images/Tiramisu.png",
  ),
  ProdukModel(
    idProduk: 3,
    name: "Dark Cherry ",
    price: 35000,
    stock: 20,
    kategori: KategoriProduk.iced,
    imageUrl: "assets/images/Dark_Cherry.png",
  ),
  ProdukModel(
    idProduk: 4,
    name: "Miso Caramel ",
    price: 30000,
    stock: 40,
    kategori: KategoriProduk.iced,
    imageUrl: "assets/images/Miso_Caramel.png",
  ),
  ProdukModel(
    idProduk: 5,
    name: "Iced Latte",
    price: 28000,
    stock: 100,
    kategori: KategoriProduk.iced,
    imageUrl: "assets/images/Iced_Latte.png",
  ),
];
  final Map<int, int> cart = {};

  int get totalItems => cart.values.fold(0, (a, b) => a + b);
  int get totalPrice => cart.entries.fold(0, (sum, e) {
        final produk = allProduk.firstWhere((p) => p.idProduk == e.key,
            orElse: () => ProdukModel(idProduk: 0, name: "", price: 0, stock: 0, kategori: KategoriProduk.iced));
        return sum + (e.value * produk.price);
      });

  List<ProdukModel> get featured => allProduk.take(3).toList();
  List<ProdukModel> get spesial => allProduk.where((p) => p.kategori == selectedKategori).toList();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarDrawer(),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [

            Container(
              height: 420,
              decoration: const BoxDecoration(
                color: AppColors.azura,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(42)),
              ),
            ),

            // KONTEN UTAMA: HEADER TEXT + SEARCH + KATEGORI (FIXED)
            Column(
              children: [
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
                      Text("Good Morning", style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text("Grab a coffee, make life less bland", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                      const SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: GoogleFonts.poppins(color: AppColors.azura),
                          prefixIcon: const Icon(Icons.search, color: AppColors.azura),
                          filled: true,
                          fillColor: Color(0xFFF2F2F2),
                          contentPadding: const EdgeInsets.symmetric(vertical: 20),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: KategoriProduk.values
                              .map((kat) => KategoriTab(
                                    kategori: kat,
                                    isActive: selectedKategori == kat,
                                    onTap: () => setState(() => selectedKategori = kat),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // BAGIAN YANG BISA DISCROLL: CAROUSEL + LIST PRODUK
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // CAROUSEL (IKUT SCROLL!)
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
                      ),

                      const SizedBox(height: 30),

                      // JUDUL SPESIAL COFFEE — RATA KIRI
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Spesial Coffee",
                          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // LIST PRODUK
                      ...spesial.map((produk) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            child: SpecialCoffeeCard(
                              produk: produk,
                              cart: cart,
                              onCartChanged: () => setState(() {}),
                            ),
                          )),

                      const SizedBox(height: 120), // spasi buat tombol checkout
                    ],
                  ),
                ),
              ],
            ),

            // TOMBOL CHECKOUT NEMPL DI BAWAH
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