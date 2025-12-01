import 'package:flutter/material.dart';

class CustomerInput extends StatelessWidget {
  final TextEditingController controller;
  const CustomerInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        
        controller: controller,
        decoration: const InputDecoration(border: InputBorder.none, hintText: "customer"),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}