import 'package:flutter/material.dart';
import 'package:kasir/models/produk.dart';
import 'package:kasir/utils/constants.dart';
import 'package:kasir/component/cashier/carousel_card.dart';
import 'package:kasir/screens/cashier/checkout_screen.dart';
import 'package:kasir/component/cashier/kategori_tab.dart';
import 'package:kasir/component/cashier/coffee_card.dart';
import 'package:kasir/component/sidebar_drawer.dart';

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
    ),
    ProdukModel(
      idProduk: 2,
      name: "Tiramisu Ice Drink",
      price: 28000,
      stock: 30,
      kategori: KategoriProduk.iced,
    ),
    ProdukModel(
      idProduk: 3,
      name: "Dark Cherry Ice Drink",
      price: 35000,
      stock: 20,
      kategori: KategoriProduk.iced,
    ),
    ProdukModel(
      idProduk: 4,
      name: "Miso Caramel Ice Drink",
      price: 30000,
      stock: 40,
      kategori: KategoriProduk.iced,
    ),
    ProdukModel(
      idProduk: 5,
      name: "Iced Latte",
      price: 28000,
      stock: 100,
      kategori: KategoriProduk.iced,
    ),
  ];

  // KERANJANG
  Map<int, int> cart = {};

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
      ),
    );
    return sum + (e.value * produk.price);
  });

  List<ProdukModel> get featured => allProduk.take(2).toList();
  List<ProdukModel> get spesial =>
      allProduk.where((p) => p.kategori == selectedKategori).toList();

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
            // HEADER UNGU
            Container(
              height: 370,
              decoration: const BoxDecoration(
                color: AppColors.azura,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(42),
                ),
              ),
            ),

            // KONTEN UTAMA
            Column(
              children: [
                // HEADER: Good Morning + Search + Tab
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () =>
                                _scaffoldKey.currentState?.openDrawer(),
                          ),
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Good Morning",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Grab a coffee, make life less bland",
                        style: TextStyle(fontSize: 15, color: Colors.white70),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: KategoriProduk.values
                              .map(
                                (kat) => KategoriTab(
                                  kategori: kat,
                                  isActive: selectedKategori == kat,
                                  onTap: () =>
                                      setState(() => selectedKategori = kat),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                // CAROUSEL
                SizedBox(
                  height: 300,
                  child: PageView.builder(
                    padEnds: false,
                    controller: PageController(viewportFraction: 0.58),
                    clipBehavior: Clip.none,
                    itemCount: featured.length,
                    itemBuilder: (context, index) {
                      return Transform.translate(
                        offset: const Offset(0, 10),
                        child: CarouselCard(
                          produk: featured[index],
                          cart: cart,
                          onCartChanged: () => setState(() {}),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // JUDUL SPESIAL COFFEE
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
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: spesial.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SpecialCoffeeCard(
                          produk: spesial[i],
                          cart: cart,
                          onCartChanged: () => setState(() {}),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // BOTTOM CHECKOUT BAR
            if (totalItems > 0)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.azura.withOpacity(0.98),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "$totalItems",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          if (totalItems == 0) return;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutScreen(
                                cart: cart,
                                allProduk: allProduk,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.azura,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text(
                          "Checkout",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
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
