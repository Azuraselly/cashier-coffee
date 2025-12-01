import 'package:flutter/material.dart';
import 'package:kasir/models/produk.dart';
import 'package:kasir/utils/constants.dart';

class KategoriTab extends StatelessWidget {
  final KategoriProduk kategori;
  final bool isActive;
  final VoidCallback onTap;

  const KategoriTab({
    super.key,
    required this.kategori,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          kategori.label,
          style: TextStyle(
            color: isActive ? AppColors.azura : Colors.white,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}