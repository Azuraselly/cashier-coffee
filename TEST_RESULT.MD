# Test Results Documentation  
Project: POS App (Flutter + Supabase)  
Penguji: Sellyyy imuopp

## 1. Koneksi Supabase  
- URL dan Anon Key sudah dimasukkan di `supabase_client.dart`  
- Inisialisasi di `main.dart` berhasil  
- Bisa query tabel: `users`, `produk`, `pelanggan`  
Status: Berhasil  

## 2. Autentikasi  
| Fitur | Input | Hasil |  
|------|-------|-------|  
| Login Kasir | `kasir@pos.com` / `123456` | Masuk, role: `kasir` |  
| Login Admin | `admin@pos.com` / `admin123` | Masuk, role: `admin` |  
| Logout | - | Session hilang |  
| Register (Admin Only) | Email baru + password | Tersimpan di `auth.users` + tabel `users` |  
Status: Semua berhasil  

## 3. CRUD Produk  
| Operasi | Input | Hasil |  
|--------|-------|-------|  
| Tambah | "Teh Tarik", Rp10.000, stok 50 | Masuk ke tabel |  
| Cari | "Teh" | Muncul 1 item |  
| Filter | Kategori: "Minuman" | Hanya minuman |  
| Edit | Ganti nama jadi "Teh Tarik Gula Batu" | Berubah |  
| Hapus | ID: 1 | Data hilang |  
Status: Lengkap  

## 4. CRUD Pelanggan  
| Operasi | Input | Hasil |  
|--------|-------|-------|  
| Tambah | Budi, 08123456789, Jl. Sudirman | Tersimpan |  
| Lihat | - | Tampil semua |  
| Edit | Ganti nama jadi "Budi Santoso" | Berubah |  
| Hapus | ID: 1 | Dihapus |  
Status: Berhasil  

## 5. Real-time Update  
- Ubah stok di Supabase → UI langsung update  
- Transaksi baru → log masuk otomatis  
Status: Bekerja  
