// lib/screens/checkout/components/note_input.dart
import 'package:flutter/material.dart';

class NoteInput extends StatelessWidget {
  final TextEditingController controller;
  const NoteInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: Row(children: [
        const Text("Catatan Tambahan :", style: TextStyle(fontSize: 15)),
        const SizedBox(width: 12),
        Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: "", border: InputBorder.none))),
      ]),
    );
  }
}