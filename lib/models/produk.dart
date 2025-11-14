class Produk {
  final int id;
  final String nama;
  final String? deskripsi;
  final String? kategori;
  final double harga;
  final String? gambarUrl;
  final int stokSaatIni;

  Produk({
    required this.id,
    required this.nama,
    this.deskripsi,
    this.kategori,
    required this.harga,
    this.gambarUrl,
    required this.stokSaatIni,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      kategori: json['kategori'],
      harga: double.parse(json['harga'].toString()),
      gambarUrl: json['gambar_url'],
      stokSaatIni: json['stok_saat_ini'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'harga': harga,
      'gambar_url': gambarUrl,
      'stok_saat_ini': stokSaatIni,
    };
  }
}