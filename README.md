# ShowTime – Latihan Responsi Pemrograman Aplikasi Mobile

Aplikasi Flutter untuk melihat katalog serial TV dari TVMaze. Fitur yang disiapkan mengikuti soal latihan responsi:

- Login menggunakan username/NIM `124240116` dan password `123`.
- Menyimpan sesi login dengan `SharedPreferences`.
- Home menampilkan daftar TV show dari `https://api.tvmaze.com/shows`, lengkap dengan gambar, judul, rating, loading indicator, pencarian lokal, dan navigasi ke detail.
- File service API dipisahkan dari UI di `lib/services/tvmaze_service.dart`.
- Detail mengambil data dari `https://api.tvmaze.com/shows/{id}` serta menampilkan gambar, judul, rating, genre, ringkasan, status, bahasa, dan durasi.
- Favorit disimpan secara lokal menggunakan Hive dan dapat dihapus dari halaman detail.
- Profile menampilkan username, kesan dan pesan praktikum, serta tombol logout yang menghapus session.
- BottomNavigationBar terdiri dari Home, Favorit, dan Profil.

## Menyiapkan project di Windows

Pastikan Flutter SDK dan Android Studio/VS Code sudah terpasang.

1. Ekstrak folder project ini.
2. Buka PowerShell pada folder `Latres_TVMaze_124240116`.
3. Jalankan perintah berikut untuk membuat file platform Flutter (Android, Web, dan Windows):

```powershell
flutter create . --platforms=android,web,windows
```

4. Ambil dependency:

```powershell
flutter pub get
```

5. Jalankan di Chrome:

```powershell
flutter run -d chrome
```

Atau jalankan pada emulator Android yang aktif:

```powershell
flutter run
```

## Struktur utama

```text
lib/
  main.dart
  screens/
    auth_gate.dart
    login_page.dart
    main_shell.dart
    home_page.dart
    show_detail_page.dart
    favorite_page.dart
    profile_page.dart
  services/
    tvmaze_service.dart
  utils/
    show_helpers.dart
  widgets/
    show_card.dart
```

## Catatan implementasi

- NIM pada validasi login diatur sebagai `124240116` dalam `lib/screens/login_page.dart`. Ubah nilai `_nim` jika NIM yang digunakan berbeda.
- Password sesuai soal adalah `123`.
- Session disimpan sebagai key `username` pada SharedPreferences.
- Hive menyimpan data favorit dalam box `favorites` sebagai JSON string dengan key berupa ID show. Penyimpanan ini tetap menggunakan Hive tanpa memerlukan generator adapter.
- Implementasi menggunakan `StatefulWidget`, `setState`, `FutureBuilder`, `ValueListenableBuilder`, `Navigator.push`, dan `BottomNavigationBar`. GetX tidak ditambahkan karena sifatnya opsional pada instruksi.
- Aplikasi membutuhkan koneksi internet untuk mengambil data serta gambar TVMaze.
- File `Pasted text.txt` yang dilampirkan berisi contoh payload JSON TVMaze; aplikasi ini mengambil data langsung dari endpoint API sesuai kriteria soal, bukan mengandalkan snapshot statis.

## Pengujian manual yang disarankan

1. Masuk menggunakan `124240116` dan `123`.
2. Tutup dan buka ulang aplikasi; session harus tetap aktif.
3. Pastikan halaman Home menampilkan daftar dan rating show.
4. Buka salah satu show dan periksa detailnya.
5. Tambahkan ke favorit, pindah ke tab Favorit, pastikan item tampil.
6. Hapus favorit melalui tombol hati pada detail, lalu periksa tab Favorit.
7. Buka Profil dan tekan Logout; session harus terhapus dan aplikasi kembali ke Login.

Referensi API: https://www.tvmaze.com/api
