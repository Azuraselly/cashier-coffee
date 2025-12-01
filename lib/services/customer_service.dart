import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerService {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchAll() async {
    final response = await _client
        .from('pelanggan')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<void> add({
    required String name,
    String? phone,
    String? address,
  }) async {
    await _client.from('pelanggan').insert({
      'name': name.trim(),
      'phone': phone?.trim().isNotEmpty == true ? phone!.trim() : null,
      'address': address?.trim().isNotEmpty == true ? address!.trim() : null,
    });
  }

  Future<void> update({
    required int id,
    required String name,
    String? phone,
    String? address,
  }) async {
    await _client.from('pelanggan').update({
      'name': name.trim(),
      'phone': phone?.trim().isNotEmpty == true ? phone!.trim() : null,
      'address': address?.trim().isNotEmpty == true ? address!.trim() : null,
    }).eq('id_pelanggan', id);
  }

  Future<void> delete(int id) async {
    await _client.from('pelanggan').delete().eq('id_pelanggan', id);
  }
}