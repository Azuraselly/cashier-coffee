import 'package:flutter/material.dart';
import 'package:kasir/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0XFFFFFFFF),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            child: Row(
              children: [
                const CircleAvatar(radius: 28, backgroundColor: AppColors.azura, child: Icon(Icons.person, size: 32, color: AppColors.azura)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16)),
                    Text('sellyyy', style: GoogleFonts.poppins(color: Colors.black, fontSize: 12)),
                  ],
                ),
                const Spacer(),
                IconButton(icon: const Icon(Icons.search, color: AppColors.azura), onPressed: () {}),
              ],
            ),
          ),
          const Divider(color: AppColors.azura),

          // Menu
          _item(Icons.dashboard, 'Dashboard', true, context),
          _item(Icons.inventory_2, 'Product Management', false, context),
          _item(Icons.people, 'Customer Management', false, context),
          _item(Icons.person, 'Cashier', false, context),
          _item(Icons.bar_chart, 'Stock Management', false, context),
          _item(Icons.print, 'Report and Print', false, context),

          const Spacer(),

          // Log Out
          Padding(
            padding: const EdgeInsets.all(20),
            child: _item(Icons.logout, 'Log Out', false, context, color: Colors.redAccent, iconColor: Colors.redAccent),
          ),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String title, bool selected, BuildContext context, {Color? color, Color? iconColor}) {
    return ListTile(
      leading: Icon(icon, color: selected ? AppColors.azura : (iconColor ?? AppColors.azura.withOpacity(0.8)), size: 22),
      title: Text(title, style: GoogleFonts.poppins(
        color: selected ? AppColors.azura : (color ?? AppColors.azura.withOpacity(0.8)),
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        fontSize: 14,
      )),
      selected: selected,
      selectedTileColor: AppColors.azura.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      onTap: () {
        if (title == 'Log Out') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out!')));
        }
        Navigator.pop(context);
      },
    );
  }
}