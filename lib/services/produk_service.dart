// lib/services/produk_service.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kasir/models/produk.dart';

class ProdukService {
  final supabase = Supabase.instance.client;

  // ====================== GET ALL ======================
  Future<List<ProdukModel>> getAllProduk() async {
    final response = await supabase
        .from('produk')
        .select()
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((e) => ProdukModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // ====================== TAMBAH PRODUK ======================
  Future<void> tambahProduk({
    required String name,
    String? description,
    required double price,
    required int stock,
    int? minStock,
    required KategoriProduk kategori,
    XFile? imageFile,
  }) async {
    String? imageUrl;

    if (imageFile != null) {
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      if (kIsWeb) {
        final bytes = await imageFile.readAsBytes();
        await supabase.storage.from('produk_images').uploadBinary(fileName, bytes);
      } else {
        final file = File(imageFile.path);
        await supabase.storage.from('produk_images').upload(fileName, file);
      }

      imageUrl = supabase.storage.from('produk_images').getPublicUrl(fileName);
    }

    await supabase.from('produk').insert({
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'min_stock': minStock,
      'image_url': imageUrl,
      'kategori': kategori.toString().split('.').last, // <-- FIX DI SINI
    });
  }

  // ====================== UPDATE SIMPLE (hanya nama, harga, gambar) ======================
  Future<void> updateProdukSimple({
    required int idProduk,
    required String name,
    required double price,
    XFile? newImage,
    String? oldImageUrl,
  }) async {
    String? imageUrl = oldImageUrl;

    // Hapus gambar lama kalau ada gambar baru
    if (newImage != null && oldImageUrl != null) {
      final oldFileName = oldImageUrl.split('/').last;
      try {
        await supabase.storage.from('produk_images').remove([oldFileName]);
      } catch (_) {}
    }

    // Upload gambar baru
    if (newImage != null) {
      final ext = newImage.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';

      if (kIsWeb) {
        final bytes = await newImage.readAsBytes();
        await supabase.storage.from('produk_images').uploadBinary(fileName, bytes);
      } else {
        await supabase.storage.from('produk_images').upload(fileName, File(newImage.path));
      }

      imageUrl = supabase.storage.from('produk_images').getPublicUrl(fileName);
    }

    await supabase.from('produk').update({
      'name': name,
      'price': price,
      if (imageUrl != null) 'image_url': imageUrl,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id_produk', idProduk);
  }

  // ====================== HAPUS PRODUK ======================
  Future<void> hapusProduk(int idProduk, String? imageUrl) async {
    if (imageUrl != null) {
      final fileName = imageUrl.split('/').last;
      try {
        await supabase.storage.from('produk_images').remove([fileName]);
      } catch (_) {}
    }
    await supabase.from('produk').delete().eq('id_produk', idProduk);
  }

  Future<void> deleteProduk(int idProduk) async {}
}
