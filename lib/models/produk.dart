enum KategoriProduk {
  iced,
  hot,
  milkshake,
  tea,
  snack;

  String get label {
    switch (this) {
      case KategoriProduk.iced:
        return "Iced Drink";
      case KategoriProduk.hot:
        return "Hot Drink";
      case KategoriProduk.milkshake:
        return "Milkshake";
      case KategoriProduk.tea:
        return "Tea";
      case KategoriProduk.snack:
        return "Snack";
    }
  }

  static KategoriProduk fromString(String value) {
    return values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => KategoriProduk.iced,
    );
  }
}

class ProdukModel {
  final int idProduk;
  final String name;
  final String? description;
  final int price;
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
      idProduk: map['id_produk'] as int,
      name: map['name'] ?? '',
      description: map['description'] as String?,
      price: (map['price'] is num) ? (map['price'] as num).round() : 0,

      stock: map['stock'] ?? 0,
      minStock: map['min_stock'] as int?,
      imageUrl: map['image_url'] as String?,
      kategori: KategoriProduk.fromString(
        map['kategori']?.toString() ?? 'iced',
      ),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }

  String get formattedPrice =>
      "Rp. ${price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}";

  Map<String, dynamic> toMap() => {
    'id_produk': idProduk,
    'name': name,
    'description': description,
    'price': price,
    'stock': stock,
    'min_stock': minStock,
    'image_url': imageUrl,
    'kategori': kategori.name,
  };
}
