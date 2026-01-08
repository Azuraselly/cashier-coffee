class Voucher {
  final String code;
  final String title;
  final String description;
  final int discountValue; // Nilai diskon (rupiah atau persen)
  final bool isPercentage; // True jika persen
  final int? maxDiscount;  // Batas max untuk persen
  final int minPurchase;   // Minimal belanja

  const Voucher({
    required this.code,
    required this.title,
    required this.description,
    required this.discountValue,
    required this.isPercentage,
    this.maxDiscount,
    required this.minPurchase,
  });
}

// Contoh data voucher (bisa dari API nanti, taruh di constants atau provider)
const List<Voucher> availableVouchers = [
  Voucher(
    code: "NEWUSER",
    title: "Diskon Pelanggan Baru",
    description: "Potongan Rp 10.000 untuk belanja min Rp 30.000",
    discountValue: 10000,
    isPercentage: false,
    minPurchase: 30000,
  ),
  Voucher(
    code: "COFFEE10",
    title: "Hemat 10%",
    description: "Diskon 10% maksimal Rp 15.000 untuk belanja min Rp 50.000",
    discountValue: 10,
    isPercentage: true,
    maxDiscount: 15000,
    minPurchase: 50000,
  ),
  Voucher(
    code: "FREEDRINK",
    title: "Beli 5 Gratis 1",
    description: "Gratis 1 minuman termurah untuk belanja min Rp 100.000 (implementasi sederhana: diskon fixed Rp 10.000)",
    discountValue: 10000,
    isPercentage: false,
    minPurchase: 100000,
  ),
];