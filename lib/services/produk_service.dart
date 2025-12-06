import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kasir/models/produk.dart';

class ProdukService {
  final supabase = Supabase.instance.client;

  Future<List<ProdukModel>> getAllProduk() async {
    final response = await supabase
        .from('produk')
        .select()
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((e) => ProdukModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

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
      'kategori': kategori.toString().split('.').last,
    });
  }


Future<void> updateProdukSimple({
  required int idProduk,
  required String name,
  required double price,
  XFile? newImage,
  String? oldImageUrl,
}) async {
  String? imageUrl = oldImageUrl;

  if (newImage != null && oldImageUrl != null) {
    final oldFileName = oldImageUrl.split('/').last;
    try {
      await supabase.storage.from('produk_images').remove([oldFileName]);
    } catch (_) {}
  }

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

  Future<void> hapusProduk(int idProduk, String? imageUrl) async {
    if (imageUrl != null) {
      final fileName = imageUrl.split('/').last;
      try {
        await supabase.storage.from('produk_images').remove([fileName]);
      } catch (_) {}
    }
    await supabase.from('produk').delete().eq('id_produk', idProduk);
  }

  // ✅ PERBAIKI INI: ambil imageUrl dulu, lalu hapus
  Future<void> deleteProduk(int idProduk) async {
    final response = await supabase
        .from('produk')
        .select('image_url')
        .eq('id_produk', idProduk)
        .single();

    final imageUrl = response?['image_url'] as String?;
    await hapusProduk(idProduk, imageUrl);
  }

  Future<void> updateProduk({required id, required String name, String? description, required double price, required int stock, int? minStock, required KategoriProduk kategori, XFile? imageFile}) async {}

  Future<void> updateStokWithHistory({required int idProduk, required int newStock, required String reason}) async {}
}


Future<void> updateStokWithHistory({
  required int idProduk,
  required int newStock,
  required String reason,
  String? userId, 
}) async {
  final supabase = Supabase.instance.client;

  final oldResponse = await supabase
      .from('produk')
      .select('stock')
      .eq('id_produk', idProduk)
      .single();

  final int oldStock = oldResponse['stock'] as int;
  final int changeAmount = newStock - oldStock;

  await supabase
      .from('produk')
      .update({'stock': newStock, 'updated_at': DateTime.now().toIso8601String()})
      .eq('id_produk', idProduk);

  await supabase.from('stock_history').insert({
    'id_product': idProduk,
    'change_amount': changeAmount,
    'reason': reason,
    'user_id': userId,
    'old_stock': oldStock,
    'new_stock': newStock,
  });
}