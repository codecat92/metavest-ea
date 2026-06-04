# Metavest EA — Strategy Documentation

## Untuk Siapa Dokumen Ini?
Dokumen ini menjelaskan cara kerja Metavest EA dalam bahasa
yang mudah dipahami, tanpa perlu latar belakang teknis.

---

## Apa Itu Metavest EA?

Metavest EA adalah sebuah bot trading otomatis yang berjalan
di dalam platform MetaTrader 4 (MT4). Bot ini bekerja seperti
seorang trader profesional yang duduk di depan layar 24 jam —
memantau pergerakan harga dan mengambil keputusan beli/jual
secara otomatis berdasarkan aturan yang sudah ditetapkan.

Perbedaan utama bot dengan trader manusia:
- Bot tidak pernah lelah atau emosi
- Bot selalu disiplin mengikuti strategi
- Bot bisa bereaksi dalam milidetik
- Bot tidak pernah melewatkan sinyal karena sedang tidur

---

## Masalah yang Dipecahkan

Seorang trader yang melakukan trading manual menghadapi
beberapa tantangan:

1. Tidak bisa memantau layar 24 jam penuh
2. Keputusan sering dipengaruhi emosi (takut rugi, serakah)
3. Tidak konsisten dalam menerapkan strategi
4. Mudah panik saat harga bergerak tidak sesuai harapan

Metavest EA hadir untuk menyelesaikan semua tantangan ini
dengan mengotomatisasi seluruh proses pengambilan keputusan.

---

## Strategi yang Digunakan: Moving Average Crossover

### Apa Itu Moving Average?

Moving Average (MA) adalah rata-rata harga dalam periode
waktu tertentu yang terus diperbarui setiap candle baru
terbentuk.

Contoh sederhana:
Bayangkan nilai ujian seorang siswa selama 5 hari:
- Senin   : 60
- Selasa  : 70
- Rabu    : 80
- Kamis   : 90
- Jumat   : 100

Rata-rata 5 hari = (60+70+80+90+100) ÷ 5 = 80

Moving Average bekerja persis seperti itu, tapi untuk
harga forex — dihitung ulang setiap menit mengikuti
data terbaru.

Fungsinya: **menghaluskan pergerakan harga yang naik
turun tidak karuan**, sehingga arah tren besar bisa
terlihat dengan jelas.

---

### Mengapa Menggunakan 2 Moving Average?

Metavest EA menggunakan DUA Moving Average sekaligus:
MA Fast (periode 20) → sensitif, cepat bereaksi terhadap
perubahan harga terkini
MA Slow (periode 50) → lambat, mencerminkan tren jangka
lebih panjang

Mengapa tidak cukup satu saja?

Satu MA hanya bisa memberitahu "harga sekarang di atas
atau di bawah rata-rata." Tapi itu belum cukup untuk
mengambil keputusan — karena tidak ada konfirmasi.

Dengan dua MA, kita bisa mendeteksi momen yang jauh
lebih powerful: **perpotongan dua garis** (crossover).

Analoginya seperti dua orang analis:
- Analis A memantau pergerakan harga 1-2 jam terakhir
- Analis B memantau pergerakan harga 4-5 jam terakhir

Ketika keduanya sepakat bahwa tren sedang berubah —
barulah keputusan diambil. Satu analis saja tidak cukup.

---

### Sinyal Beli (Golden Cross)
Kondisi  : MA Fast memotong MA Slow dari bawah ke atas
Artinya  : Tren jangka pendek mulai mengalahkan tren
jangka panjang — momentum naik sedang terjadi
Aksi Bot : Buka posisi BUY (beli)

### Sinyal Jual (Death Cross)
Kondisi  : MA Fast memotong MA Slow dari atas ke bawah
Artinya  : Tren jangka pendek mulai melemah di bawah
tren jangka panjang — momentum turun terjadi
Aksi Bot : Buka posisi SELL (jual)


---

## Manajemen Risiko

Setiap posisi yang dibuka bot **selalu** dilengkapi dengan:

**Stop Loss (SL)**
Batas kerugian maksimal per trade. Jika harga bergerak
berlawanan sejauh X pips, posisi otomatis ditutup untuk
mencegah kerugian lebih besar.

**Take Profit (TP)**
Target keuntungan per trade. Jika harga bergerak sesuai
prediksi sejauh X pips, posisi otomatis ditutup untuk
mengamankan keuntungan.

Default setting:
Stop Loss  : 20 pips
Take Profit: 40 pips
Risk/Reward: 1:2


Artinya: untuk setiap $1 yang dirisiko, bot menargetkan
$2 keuntungan. Dengan ratio ini, bot hanya perlu benar
4 dari 10 trade untuk tetap profit secara keseluruhan.

---

## Parameter yang Bisa Disesuaikan

Semua parameter berikut bisa diubah langsung dari tampilan
MT4 tanpa perlu menyentuh kode:

| Parameter      | Default | Keterangan                    |
|----------------|---------|-------------------------------|
| MA Fast Period | 20      | Sensitivitas MA cepat         |
| MA Slow Period | 50      | Sensitivitas MA lambat        |
| Lot Size       | 0.01    | Ukuran posisi per trade       |
| Stop Loss      | 20      | Batas kerugian (dalam pips)   |
| Take Profit    | 40      | Target keuntungan (dalam pips)|

---

## Keterbatasan yang Perlu Dipahami

1. **Tidak ada strategi yang sempurna**
   Bot ini akan mengalami loss — itu normal. Yang penting
   profit secara keseluruhan dalam jangka panjang.

2. **False breakout bisa terjadi**
   Kadang MA crossover terjadi tapi harga langsung berbalik.
   Ini adalah risiko inheren dari strategi MA crossover.

3. **Perlu testing sebelum digunakan di akun live**
   Bot harus diuji di akun demo terlebih dahulu untuk
   memvalidasi performanya sebelum digunakan dengan
   uang nyata.

---

## Status Pengembangan

| Tahap          | Status      |
|----------------|-------------|
| Penulisan kode | ✅ Selesai  |
| Kompilasi      | ⏳ Pending  |
| Testing demo   | ⏳ Pending  |
| Backtest       | ⏳ Pending  |
| Live trading   | ⏳ Pending  |

---

*Dokumentasi ini akan diperbarui seiring perkembangan project.*