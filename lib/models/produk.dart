import 'package:flutter/material.dart';

enum KategoriProduk {
  iced,
  hot,
  milkshake,
  tea,
  snack;

  String get label {
    switch (this) {
      case KategoriProduk.iced: return "Iced Drink";
      case KategoriProduk.hot: return "Hot Drink";
      case KategoriProduk.milkshake: return "Milkshake";
      case KategoriProduk.tea: return "Tea";
      case KategoriProduk.snack: return "Snack";
    }
  }

  static KategoriProduk fromString(String value) {
    return KategoriProduk.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => KategoriProduk.iced,
    );
  }
}

class ProdukModel {
  final int idProduk;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final int? minStock;
  final String? imageUrl;
  final KategoriProduk kategori;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProdukModel({
    required this.idProduk,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.minStock,
    this.imageUrl,
    required this.kategori,
    this.createdAt,
    this.updatedAt,
  });

  factory ProdukModel.fromMap(Map<String, dynamic> map) {
    return ProdukModel(
      idProduk: map['id_produk'],
      name: map['name'] ?? '',
      description: map['description'],
      price: double.tryParse(map['price'].toString()) ?? 0.0,
      stock: map['stock'] ?? 0,
      minStock: map['min_stock'],
      imageUrl: map['image_url'],
      kategori: KategoriProduk.fromString(map['kategori'] ?? 'lainnya'),
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_produk': idProduk,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'min_stock': minStock,
      'image_url': imageUrl,
      'kategori': kategori.toString().split('.').last,
    };
  }
}