import 'dart:io';
import 'package:flutter/foundation.dart';          // Tambah ini untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasir/models/produk.dart';
import 'package:kasir/services/produk_service.dart';
import 'package:kasir/utils/constants.dart';

class BottomSheetTambahProduk extends StatefulWidget {
  final VoidCallback onSuccess;
  final ProdukModel? produkEdit;

  const BottomSheetTambahProduk({
  Key? key,
  required this.onSuccess,
  this.produkEdit,
}) : super(key: key);


  @override
  State<BottomSheetTambahProduk> createState() =>
      _BottomSheetTambahProdukState();
}

class _BottomSheetTambahProdukState extends State<BottomSheetTambahProduk> {
  final _service = ProdukService();
  final _picker = ImagePicker();

  XFile? image;

  final namaCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final hargaCtrl = TextEditingController();
  final stokCtrl = TextEditingController();
  final minStokCtrl = TextEditingController();

  KategoriProduk? kategori = KategoriProduk.iced;

  // Fungsi untuk memilih gambar (gallery atau camera)
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => image = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20, // keyboard safe
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle atas bottom sheet
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              "Tambah Produk",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // ================== PREVIEW GAMBAR (Support Web + Mobile) ==================
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: image != null
                      ? (kIsWeb
                          // Web: pakai Image.network dengan object URL dari XFile
                          ? Image.network(
                              image!.path,
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                            )
                          // Mobile: pakai Image.file
                          : Image.file(
                              File(image!.path),
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                            ))
                      : const Icon(Icons.add_a_photo,
                          size: 50, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ================== FORM INPUT ==================
            TextField(
              controller: namaCtrl,
              decoration: const InputDecoration(
                labelText: "Nama Produk *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(
                labelText: "Deskripsi",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: hargaCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Harga *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: stokCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Stok *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: minStokCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Min Stok",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<KategoriProduk>(
              value: kategori,
              decoration: const InputDecoration(
                labelText: "Kategori",
                border: OutlineInputBorder(),
              ),
              items: KategoriProduk.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.label),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => kategori = v),
            ),

            const SizedBox(height: 30),

            // ================== TOMBOL SIMPAN ==================
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.azura,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  // Validasi wajib
                  if (namaCtrl.text.isEmpty ||
                      hargaCtrl.text.isEmpty ||
                      stokCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Nama, Harga, dan Stok wajib diisi")),
                    );
                    return;
                  }

                  try {
                    await _service.tambahProduk(
                      name: namaCtrl.text.trim(),
                      description: descCtrl.text.isEmpty
                          ? null
                          : descCtrl.text.trim(),
                      price: double.parse(hargaCtrl.text),
                      stock: int.parse(stokCtrl.text),
                      minStock: minStokCtrl.text.isEmpty
                          ? null
                          : int.parse(minStokCtrl.text),
                      kategori: kategori!,
                      imageFile: image, // tetap kirim XFile, service harus handle web juga
                    );

                    widget.onSuccess();
                    if (mounted) Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal menambah produk: $e")),
                    );
                  }
                },
                child: const Text(
                  "SIMPAN",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    namaCtrl.dispose();
    descCtrl.dispose();
    hargaCtrl.dispose();
    stokCtrl.dispose();
    minStokCtrl.dispose();
    super.dispose();
  }
}