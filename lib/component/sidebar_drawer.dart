import 'package:flutter/material.dart';
import 'package:kasir/screens/cashier/cashier_screen.dart';
import 'package:kasir/utils/constants.dart';
import 'package:kasir/screens/dashboard/dashboard_screen.dart';
import 'package:kasir/screens/produk/ProdukManagementScreen.dart';
import 'package:kasir/screens/laporan/laporan_penjualan_screen.dart';
import 'package:kasir/screens/customer/customer_screen.dart';
import 'package:kasir/screens/stok/stock_management_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  final Map<String, Widget> _routes = const {
    'Dashboard': DashboardScreen(),
    'Product Management': ProdukManagementScreen(),
    'Customer Management': CustomerManagementScreen(),
    'Cashier': CashierScreen(),
    'Stock Management': StockManagementScreen(),
    'Report and Print': LaporanPenjualanScreen(),
  };
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.azura.withOpacity(0.2),
                  child: Icon(Icons.person, size: 32, color: AppColors.azura),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                    Text('sellyyy', style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.search, color: AppColors.azura),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.azura, thickness: 1),

          _menuItem('Dashboard', Icons.dashboard, true, context),
          _menuItem('Product Management', Icons.inventory_2, false, context),
          _menuItem('Customer Management', Icons.people, false, context),
          _menuItem('Cashier', Icons.point_of_sale, false, context),
          _menuItem('Stock Management', Icons.bar_chart, false, context),
          _menuItem('Report and Print', Icons.print, false, context),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(20),
            child: _menuItem(
              'Log Out',
              Icons.logout,
              false,
              context,
              iconColor: Colors.redAccent,
              textColor: Colors.redAccent,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out!'), backgroundColor: Colors.red),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // FUNGSI MENU YANG BISA DIKLIK
  Widget _menuItem(String title, IconData icon, bool selected, BuildContext context, {Color? iconColor, Color? textColor, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? AppColors.azura : (iconColor ?? AppColors.azura.withOpacity(0.7)),
        size: 24,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: selected ? AppColors.azura : (textColor ?? Colors.black87),
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 14,
        ),
      ),
      selected: selected,
      selectedTileColor: AppColors.azura.withOpacity(0.1),
      selectedColor: AppColors.azura,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      onTap: onTap ??
          () {
            // Tutup drawer dulu
            Navigator.pop(context);

            // Cek apakah halaman tujuan ada
            if (_routes.containsKey(title)) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => _routes[title]!),
              );
            }
          },
    );
  }
}