import 'package:flutter/material.dart';
import 'package:kasir/models/produk.dart';
import 'package:kasir/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class KategoriTab extends StatelessWidget {
  final KategoriProduk kategori;
  final String? labelOverride; 
  final bool isActive;
  final VoidCallback onTap;

  const KategoriTab({
    super.key,
    required this.kategori,
    this.labelOverride,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
          border: isActive ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Text(
          labelOverride ?? kategori.label,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isActive ? AppColors.azura : Colors.white,
          ),
        ),
      ),
    );
  }
}