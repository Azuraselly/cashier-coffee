import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir/utils/constants.dart';

class EmptyCustomerState extends StatelessWidget {
  final VoidCallback onAddPressed;
  const EmptyCustomerState({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_outline, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text('Belum ada pelanggan', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          Text('Tambahkan pelanggan pertama Anda', style: GoogleFonts.poppins(color: Colors.grey)),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: onAddPressed, // ← pakai callback
            icon: const Icon(Icons.person_add_alt_1, size: 30),
            label: Text(
              'Tambah Pelanggan Baru',
              style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.azura,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
              minimumSize: const Size(280, 64),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 12,
            ),
          ),
        ],
      ),
    );
  }
}