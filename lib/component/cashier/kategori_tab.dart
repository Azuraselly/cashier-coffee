
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isActive
                ? ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.azura, AppColors.azura],
                    ).createShader(bounds),
                    child: Text(
                      kategori.label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, 
                      ),
                    ),
                  )
                : Text(
                    kategori.label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                      color: isActive ? AppColors.azura : Colors.white,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
