// lib/component/edit_produk_dialog.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasir/models/produk.dart';
import 'package:kasir/services/produk_service.dart';
import 'package:kasir/utils/constants.dart';

class EditProdukDialog extends StatefulWidget {
  final ProdukModel produk;
  final VoidCallback onSuccess;

  const EditProdukDialog({
    Key? key,
    required this.produk,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<EditProdukDialog> createState() => _EditProdukDialogState();
}

class _EditProdukDialogState extends State<EditProdukDialog> {
  late TextEditingController namaCtrl;
  late TextEditingController hargaCtrl;

  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  final service = ProdukService();

  XFile? newImage;
  bool isLoading = false;

  // Untuk menampilkan pesan error langsung di bawah field harga
  String? _hargaError;

  @override
  void initState() {
    super.initState();
    namaCtrl = TextEditingController(text: widget.produk.name);

    final price = widget.produk.price;
    final hargaText = price % 1 == 0
        ? price.toInt().toString()
        : price.toStringAsFixed(2).replaceAll(RegExp(r'\.?0*$'), '');
    hargaCtrl = TextEditingController(text: hargaText);

    // Listener untuk validasi real-time saat user ngetik
    hargaCtrl.addListener(_validateHargaOnTheFly);
  }

  void _validateHargaOnTheFly() {
    final text = hargaCtrl.text.trim();
    if (text.isEmpty) {
      setState(() => _hargaError = "Harga wajib diisi");
    } else {
      // Coba parse ke double
      final value = double.tryParse(text.replaceAll(',', ''));
      if (value == null) {
        setState(() => _hargaError = "Hanya boleh angka ");
      } else if (value <= 0) {
        setState(() => _hargaError = "Harga harus lebih dari 0");
      } else {
        setState(() => _hargaError = null); // valid
      }
    }
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) setState(() => newImage = picked);
  }

  Future<void> save() async {
    // Validasi nama
    if (namaCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama produk wajib diisi"), backgroundColor: Colors.red),
      );
      return;
    }

    // Validasi harga (cek dari listener)
    if (_hargaError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_hargaError!), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final double harga = double.parse(hargaCtrl.text.replaceAll(',', ''));

      await service.updateProdukSimple(
        idProduk: widget.produk.idProduk,
        name: namaCtrl.text.trim(),
        price: harga,
        newImage: newImage,
        oldImageUrl: widget.produk.imageUrl,
      );

      widget.onSuccess();
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal update: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Edit Produk", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // GAMBAR
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: newImage != null
                        ? (kIsWeb
                            ? Image.network(newImage!.path, fit: BoxFit.cover)
                            : Image.file(File(newImage!.path), fit: BoxFit.cover))
                        : widget.produk.imageUrl != null && widget.produk.imageUrl!.isNotEmpty
                            ? Image.network(widget.produk.imageUrl!, fit: BoxFit.cover)
                            : const Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.photo_library, size: 18),
                label: const Text("Ganti Gambar"),
              ),
              const SizedBox(height: 20),

              // NAMA
              const Align(alignment: Alignment.centerLeft, child: Text("Nama Produk")),
              const SizedBox(height: 8),
              TextFormField(
                controller: namaCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: "Masukkan nama produk",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.azura, width: 2)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),

              // HARGA + NOTIFIKASI LANGSUNG
              const Align(alignment: Alignment.centerLeft, child: Text("Harga")),
              const SizedBox(height: 8),
              TextField(
                controller: hargaCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                // Huruf boleh diketik → tapi langsung kasih notif error
                decoration: InputDecoration(
                  prefixText: "Rp ",
                  filled: true,
                  fillColor: Colors.grey[100],
             
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.azura, width: 2)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
                  errorText: _hargaError, // ← INI YANG MUNCUL LANGSUNG KALAU SALAH
                  errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 28),

              // TOMBOL
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.azura),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text("Batal", style: TextStyle(color: AppColors.azura)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.azura,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    hargaCtrl.removeListener(_validateHargaOnTheFly);
    namaCtrl.dispose();
    hargaCtrl.dispose();
    super.dispose();
  }
}