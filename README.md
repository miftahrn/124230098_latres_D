# Latres Store

Aplikasi toko online Flutter untuk latihan responsi Praktikum Pemrograman
Aplikasi Mobile.

## Fitur

- Login menggunakan username bebas dan password NIM (`124230098`).
- Session username disimpan menggunakan `SharedPreferences`.
- Session tetap aktif setelah aplikasi ditutup sampai pengguna logout.
- Produk diambil dari `https://dummyjson.com/products`.
- Home menampilkan username, daftar produk, loading state, error state,
  empty state, dan tombol refresh.
- Detail produk menampilkan gambar, harga, diskon, deskripsi, rating, stok,
  kategori, brand, SKU, dimensi, pengiriman, garansi, return policy, tags,
  metadata, dan review.
- Quantity dibatasi dari 1 sampai stock produk.
- Produk disimpan ke Hive bersama username dan quantity.
- Cart dipisahkan berdasarkan username.
- Item cart dapat dihapus.
- Bottom Navigation hanya berisi Home dan Profile.
- Profile menyediakan tombol Logout.

## Menjalankan aplikasi

Pastikan Flutter dan Dart sesuai dengan constraint pada `pubspec.yaml`, lalu
jalankan:

```bash
flutter pub get
flutter run
```

Untuk memeriksa kualitas kode dan menjalankan test:

```bash
flutter analyze
flutter test
```

## Login

Username dapat diisi bebas. Password harus menggunakan:

```text
124230098
```

Nilai tersebut dikonfigurasi pada `lib/config/app_config.dart`.

## Isolasi cart

Setiap item cart menyimpan username pemiliknya. `CartService` hanya
mengembalikan item yang username-nya sama dengan session aktif. Key Hive juga
menggunakan kombinasi username dan product ID, sehingga user berbeda dapat
menyimpan produk yang sama tanpa saling menimpa.

## Struktur folder

```text
lib/
├── main.dart
├── config/
│   └── app_config.dart
├── models/
│   ├── product.dart
│   └── cart_item.dart
├── services/
│   ├── api_service.dart
│   ├── auth_service.dart
│   └── cart_service.dart
├── screens/
│   ├── login_screen.dart
│   ├── main_screen.dart
│   ├── home_screen.dart
│   ├── detail_screen.dart
│   ├── cart_screen.dart
│   └── profile_screen.dart
├── widgets/
│   ├── product_card.dart
│   └── quantity_selector.dart
└── utils/
    └── app_theme.dart
```

## Tanggung jawab komponen

- `main.dart`: inisialisasi SharedPreferences, Hive, adapter, dan route awal.
- `app_config.dart`: URL API, NIM, serta key penyimpanan.
- `product.dart`: model produk dan parsing response API.
- `cart_item.dart`: model cart dan Hive adapter.
- `auth_service.dart`: login, session, dan logout.
- `api_service.dart`: request dan validasi response DummyJSON.
- `cart_service.dart`: tambah/update, filter per user, dan hapus item cart.
- `screens/`: halaman login, home, detail, cart, profile, dan navigasi utama.
- `widgets/`: komponen kartu produk dan selector quantity.

## Skenario manual isolasi cart

1. Login sebagai user A dengan password `124230098`.
2. Buka detail dua produk dan tambahkan keduanya ke cart.
3. Logout melalui Profile.
4. Login sebagai user B.
5. Tambahkan satu produk ke cart, lalu logout.
6. Login kembali sebagai user A.
7. Buka Cart dan pastikan hanya dua produk milik user A yang terlihat.
8. Hapus salah satu item dan pastikan item tersebut hilang.
9. Tutup dan buka kembali aplikasi tanpa logout; session terakhir harus tetap aktif.
