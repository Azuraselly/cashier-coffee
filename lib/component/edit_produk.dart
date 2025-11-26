// lib/component/edit_produk_dialog.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasir/models/produk.dart';
import 'package:kasir/services/produk_service.dart';
import 'package:kasir/utils/constants.dart';

class EditProdukDialog extends StatefulWidget {
  final ProdukModel produk;
  final VoidCallback onSuccess;

  const EditProdukDialog({Key? key, required this.produk, required this.onSuccess}) : super(key: key);

  @override
  State<EditProdukDialog> createState() => _EditProdukDialogState();
}

class _EditProdukDialogState extends State<EditProdukDialog> {
  late TextEditingController namaCtrl;
  late TextEditingController hargaCtrl;
  XFile? newImage;
  final picker = ImagePicker();
  final service = ProdukService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    namaCtrl = TextEditingController(text: widget.produk.name);
    hargaCtrl = TextEditingController(text: widget.produk.price.toStringAsFixed(0));
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) setState(() => newImage = picked);
  }

  Future<void> save() async {
    if (namaCtrl.text.isEmpty || hargaCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nama dan harga wajib diisi")));
      return;
    }

    setState(() => isLoading = true);
    try {
      await service.updateProdukSimple(
        idProduk: widget.produk.idProduk,
        name: namaCtrl.text.trim(),
        price: double.parse(hargaCtrl.text),
        newImage: newImage,
        oldImageUrl: widget.produk.imageUrl,
      );

      widget.onSuccess();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal update: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Edit Product", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            const Align(alignment: Alignment.centerLeft, child: Text("Name Product")),
            const SizedBox(height: 8),
            TextField(
              controller: namaCtrl,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),

            const Align(alignment: Alignment.centerLeft, child: Text("Price")),
            const SizedBox(height: 8),
            TextField(
              controller: hargaCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: "Rp. ",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.azura,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Save", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.azura),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text("Cancel", style: TextStyle(color: AppColors.azura)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    namaCtrl.dispose();
    hargaCtrl.dispose();
    super.dispose();
  }
}