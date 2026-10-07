# IF4073 Pemrosesan Citra Digital
## Tugas 2: Pemrosesan Citra dalam Ranah Frekuensi

Untuk tugas 2 ini kami bikin aplikasi MATLAB berbasis GUI untuk pemrosesan citra di ranah frekuensi, yaitu
smoothing (LPF), high-pass filtering (HPF), peningkatan kecerahan, restorasi
derau periodik (bandreject/notch), dan restorasi motion blur (inverse &
Wiener filtering.

## Dependensi
- MATLAB
- Image Processing Toolbox (cm buat `imshow`/`imread` kok, metode utama dibikin sendiri dengan `fft2`, `ifft2`, `fftshift`, `ifftshift`)

## Cara Menjalankan
```matlab
cd src
frequencyGUI
```
1. **Load Image** untuk memuat citra masukan (opsional **Load Reference**).
2. Pilih tab bagian (B-F), atur parameter, tekan **Apply**.
3. **Save Result** menyimpan hasil tab aktif.

Citra uji resmi diletakkan di `img/citra_uji/<bagian>/{input,reference}`.

## Struktur
| Berkas | Isi |
|---|---|
| `src/frequencyGUI.m` | GUI utama (tab B-F), tampilan spektrum, alur data |
| `src/lowPassFilter.m` | B: ILPF, GLPF, BLPF |
| `src/highPassFilter.m` | C: IHPF, GHPF, BHPF |
| `src/brightnessFilter.m` | D: penapis peningkat kecerahan |
| `src/bandRejectFilter.m`, `src/notchRejectFilter.m` | E: bandreject & notch reject |
| `src/motionBlurPSF.m`, `src/inverseFilter.m`, `src/wienerFilter.m` | F: PSF, inverse, Wiener |
| `src/freqGrid.m`, `src/logSpectrum.m`, `src/applyFreqFilter.m`, `src/psf2otf_.m` | utilitas bersama (sudah jadi) |
| `src/mk*.m`, `src/applyPerChannel.m`, `src/rgb2gray.m` | helper GUI dari Tugas 1 |

Konvensi: ngikutin PPT di kelas aja sih, jadi semua `H(u,v)` dan spektrum terpusat (`fftshift`), pusat di indeks `(floor(M/2)+1, floor(N/2)+1)`.

## Kontributor
- Muhammad Luqman Hakim (13523044)
- Z. Nayaka Athadiansyah (13523094)
