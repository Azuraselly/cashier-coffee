import 'package:flutter/material.dart';
import 'package:kasir/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerInput extends StatelessWidget {
  final TextEditingController controller;
  const CustomerInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20), // Sesuaikan sudut agar lebih mirip
        border: Border.all(color: AppColors.card),
        boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
        ] 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label "Customer"
         Text(
            "Customer",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5), 
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.azura, width: 2), 
            ),
            child: TextField(
              controller: controller,
              decoration:  InputDecoration(
                border: InputBorder.none,
                hintText: "customer",
                hintStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
              ),
              style:  GoogleFonts.poppins(fontSize: 16, color: Colors.black),
            ),
          ),
           const SizedBox(height: 5), 
        ],
      ),
    );
  }
}