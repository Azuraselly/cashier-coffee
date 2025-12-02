import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  State<BottomSheetTambahProduk> createState() => _BottomSheetTambahProdukState();
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
  bool _isLoading = false;

  // 🟢 Touched state tracking
  bool _namaTouched = false;
  bool _hargaTouched = false;
  bool _stokTouched = false;
  bool _minStokTouched = false;

  // ⏱ Untuk hindari spam popup
  DateTime? _lastNumberErrorShown;

  @override
  void initState() {
    super.initState();
    if (widget.produkEdit != null) {
      final p = widget.produkEdit!;
      namaCtrl.text = p.name;
      descCtrl.text = p.description ?? '';
      hargaCtrl.text = p.price.toStringAsFixed(0);
      stokCtrl.text = p.stock.toString();
      minStokCtrl.text = p.minStock?.toString() ?? '';
      kategori = p.kategori;
    }
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null && mounted) {
      setState(() => image = picked);
    }
  }

  // ===== VALIDASI REAL-TIME (hanya jika touched) =====
  String? get errorNama {
    if (!_namaTouched) return null;
    final text = namaCtrl.text.trim();
    return text.isEmpty ? 'Nama produk wajib diisi' : null;
  }

  String? get errorHarga {
    if (!_hargaTouched) return null;
    final text = hargaCtrl.text.trim();
    if (text.isEmpty) return 'Harga wajib diisi';
    final n = num.tryParse(text);
    if (n == null) return 'Harus berupa angka';
    if (n <= 0) return 'Harga harus lebih dari 0';
    return null;
  }

  String? get errorStok {
    if (!_stokTouched) return null;
    final text = stokCtrl.text.trim();
    if (text.isEmpty) return 'Stok wajib diisi';
    final n = int.tryParse(text);
    if (n == null) return 'Harus berupa angka';
    if (n < 0) return 'Stok tidak boleh negatif';
    return null;
  }

  String? get errorMinStok {
    if (!_minStokTouched) return null;
    final text = minStokCtrl.text.trim();
    if (text.isEmpty) return null;
    final n = int.tryParse(text);
    if (n == null) return 'Harus berupa angka';
    if (n < 0) return 'Min stok tidak boleh negatif';
    return null;
  }

  bool get _isFormValid =>
      errorNama == null && errorHarga == null && errorStok == null && errorMinStok == null;

  Future<void> _submit() async {
    // 🔴 Force semua field jadi "touched" saat submit
    setState(() {
      _namaTouched = true;
      _hargaTouched = true;
      _stokTouched = true;
      _minStokTouched = true;
    });

    if (!_isFormValid) {
      final errors = [
        if (errorNama != null) 'Nama',
        if (errorHarga != null) 'Harga',
        if (errorStok != null) 'Stok',
        if (errorMinStok != null) 'Min Stok',
      ];
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Perbaiki: ${errors.join(', ')}")),
        );
      }
      return;
    }

    FocusScope.of(context).unfocus();

    if (mounted) setState(() => _isLoading = true);

    try {
      final harga = num.parse(hargaCtrl.text.trim()).toDouble();
      final stok = int.parse(stokCtrl.text.trim());
      final minStok = minStokCtrl.text.trim().isEmpty
          ? null
          : int.parse(minStokCtrl.text.trim());

      if (widget.produkEdit == null) {
        await _service.tambahProduk(
          name: namaCtrl.text.trim(),
          description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
          price: harga,
          stock: stok,
          minStock: minStok,
          kategori: kategori!,
          imageFile: image,
        );
      } else {
        await _service.updateProduk(
          id: widget.produkEdit!.idProduk,
          name: namaCtrl.text.trim(),
          description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
          price: harga,
          stock: stok,
          minStock: minStok,
          kategori: kategori!,
          imageFile: image,
        );
      }

      widget.onSuccess();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Handles numeric input: strips non-digits & shows alert if invalid chars detected.
  void _handleNumericInput({
    required String text,
    required TextEditingController controller,
    required String fieldName,
  }) {
    // Cek apakah ada karakter non-digit (selain 0-9)
    if (text.contains(RegExp(r'[^0-9]'))) {
      // Bersihkan: hanya ambil angka
      final cleaned = text.replaceAll(RegExp(r'[^0-9]'), '');

      // Update field hanya jika berubah
      if (controller.text != cleaned) {
        controller.text = cleaned;
        // Set kursor ke akhir
        controller.selection = TextSelection.collapsed(offset: cleaned.length);
      }

      // Tampilkan popup warning (sekali per detik maksimal untuk hindari spam)
      final now = DateTime.now();
      if (_lastNumberErrorShown == null ||
          now.difference(_lastNumberErrorShown!) > const Duration(seconds: 1)) {
        _lastNumberErrorShown = now;

        // ⏳ Tunda sampai frame berikutnya agar context aman
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            showDialog(
              context: context,
              useRootNavigator: false, // 🔑 Penting: muncul di atas BottomSheet
              barrierDismissible: true,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                title: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
                    SizedBox(width: 12),
                    Text("Input Tidak Valid"),
                  ],
                ),
                content: Text("Hanya angka yang diizinkan pada field $fieldName!"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }
        });
      }
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
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              widget.produkEdit == null ? "Tambah Produk" : "Edit Produk",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // GAMBAR
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
                  child: _buildImagePreview(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // NAMA PRODUK
            TextField(
              controller: namaCtrl,
              onChanged: (_) => setState(() {
                if (!_namaTouched) _namaTouched = true;
              }),
              onEditingComplete: () => setState(() => _namaTouched = true),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF2F2F2),
                labelText: "Nama Produk *",
                errorText: errorNama,
                errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                labelStyle: const TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFF2F2F2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFB38686), width: 2.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
            ),
            const SizedBox(height: 12),

            // DESKRIPSI
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF2F2F2),
                labelText: "Deskripsi",
                labelStyle: const TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFF2F2F2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFB38686), width: 2.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
            ),
            const SizedBox(height: 12),

            // HARGA — ✅ Dengan POPUP saat huruf diketik
            TextField(
              controller: hargaCtrl,
              keyboardType: TextInputType.number,
              onChanged: (text) {
                _handleNumericInput(
                  text: text,
                  controller: hargaCtrl,
                  fieldName: "Harga",
                );
                if (!_hargaTouched) {
                  setState(() => _hargaTouched = true);
                }
              },
              onEditingComplete: () => setState(() => _hargaTouched = true),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF2F2F2),
                labelText: "Harga *",
                errorText: errorHarga,
                errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                labelStyle: const TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFF2F2F2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFB38686), width: 2.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
            ),
            const SizedBox(height: 12),

            // STOK — ✅ Dengan POPUP saat huruf diketik
            TextField(
              controller: stokCtrl,
              keyboardType: TextInputType.number,
              onChanged: (text) {
                _handleNumericInput(
                  text: text,
                  controller: stokCtrl,
                  fieldName: "Stok",
                );
                if (!_stokTouched) {
                  setState(() => _stokTouched = true);
                }
              },
              onEditingComplete: () => setState(() => _stokTouched = true),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF2F2F2),
                labelText: "Stok *",
                errorText: errorStok,
                errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                labelStyle: const TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFF2F2F2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFB38686), width: 2.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
            ),
            const SizedBox(height: 12),

            // MIN STOK — ✅ Dengan POPUP saat huruf diketik
            TextField(
              controller: minStokCtrl,
              keyboardType: TextInputType.number,
              onChanged: (text) {
                _handleNumericInput(
                  text: text,
                  controller: minStokCtrl,
                  fieldName: "Min Stok",
                );
                if (!_minStokTouched) {
                  setState(() => _minStokTouched = true);
                }
              },
              onEditingComplete: () => setState(() => _minStokTouched = true),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF2F2F2),
                labelText: "Min Stok",
                errorText: errorMinStok,
                errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                labelStyle: const TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFF2F2F2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFB38686), width: 2.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
            ),
            const SizedBox(height: 12),

            // KATEGORI
            DropdownButtonFormField<KategoriProduk>(
              value: kategori,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF2F2F2),
                labelText: "Kategori",
                labelStyle: const TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFF2F2F2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFB38686), width: 2.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
              items: KategoriProduk.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.label),
                      ))
                  .toList(),
              onChanged: (v) {
                if (mounted && v != null) {
                  setState(() => kategori = v);
                }
              },
            ),

            const SizedBox(height: 30),

            // TOMBOL SIMPAN / UPDATE
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.azura,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : Text(
                        widget.produkEdit == null ? "SIMPAN" : "UPDATE",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (image != null) {
      if (kIsWeb) {
        return FutureBuilder<Uint8List?>(
          future: image!.readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              return Image.memory(snapshot.data!, fit: BoxFit.cover);
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      } else {
        return Image.file(File(image!.path), fit: BoxFit.cover);
      }
    }

    final existingImageUrl = widget.produkEdit?.imageUrl;
    if (existingImageUrl != null && existingImageUrl.isNotEmpty) {
      return Image.network(existingImageUrl, fit: BoxFit.cover);
    }

    // 3. Placeholder
    return const Icon(Icons.add_a_photo, size: 50, color: Colors.grey);
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