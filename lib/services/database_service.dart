import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/produk.dart';
import 'supabase_client.dart';

class DatabaseService {
  final _client = SupabaseClientService.client;

  // === PRODUK ===
  Future<List<Produk>> getProduk({String? search, String? kategori}) async {
    var query = _client.from('produk').select();

    if (search != null && search.isNotEmpty) {
      query = query.ilike('nama', '%$search%');
    }
    if (kategori != null && kategori.isNotEmpty) {
      query = query.eq('kategori', kategori);
    }

    final response = await query;
    return (response as List).map((e) => Produk.fromJson(e)).toList();
  }

  Future<void> tambahProduk(Produk produk) async {
    await _client.from('produk').insert(produk.toJson());
  }

  Future<void> updateProduk(int id, Map<String, dynamic> data) async {
    await _client.from('produk').update(data).eq('id', id);
  }

  Future<void> hapusProduk(int id) async {
    await _client.from('produk').delete().eq('id', id);
  }

  // === PELANGGAN ===
  Future<List<Map<String, dynamic>>> getPelanggan() async {
    final response = await _client.from('pelanggan').select();
    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<void> tambahPelanggan(Map<String, dynamic> pelanggan) async {
    await _client.from('pelanggan').insert(pelanggan);
  }
}