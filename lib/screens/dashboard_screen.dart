import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'qr_scanner_screen.dart';

// Model Data untuk Koleksi
class Koleksi {
  final String nama;
  final String imagePath;
  final String deskripsiSingkat;

  Koleksi({
    required this.nama,
    required this.imagePath,
    required this.deskripsiSingkat,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AppinioSwiperController _swiperController = AppinioSwiperController();
  final TextEditingController _searchController = TextEditingController();

  Key _swiperKey = UniqueKey();

  // Ini adalah "Database Lokal" (Array) Anda
  // Ini adalah "Database Lokal" (Array) berisi 15 koleksi berbeda
  final List<Koleksi> _daftarKoleksi = [
    Koleksi(
      nama: "Topeng Panji",
      imagePath: 'assets/images/koleksi_1.jpg',
      deskripsiSingkat: "Topeng tradisional yang melambangkan kelembutan.",
    ),
    Koleksi(
      nama: "Keris Pusaka",
      imagePath: 'assets/images/koleksi_2.jpg',
      deskripsiSingkat:
          "Senjata tikam golongan belati dengan bentuk asimetris.",
    ),
    Koleksi(
      nama: "Gong Gamelan",
      imagePath: 'assets/images/koleksi_3.jpg',
      deskripsiSingkat:
          "Instrumen musik pukul tradisional yang terbuat dari perunggu.",
    ),
    Koleksi(
      nama: "Wayang Kulit Arjuna",
      imagePath: 'assets/images/koleksi_4.jpg',
      deskripsiSingkat: "Tokoh pewayangan berparas tampan dan berhati lembut.",
    ),
    Koleksi(
      nama: "Wayang Golek Cepot",
      imagePath: 'assets/images/koleksi_5.jpg',
      deskripsiSingkat: "Karakter punakawan khas Sunda yang jenaka.",
    ),
    Koleksi(
      nama: "Batik Megamendung",
      imagePath: 'assets/images/koleksi_6.png',
      deskripsiSingkat: "Motif kain batik khas Cirebon berbentuk awan.",
    ),
    Koleksi(
      nama: "Mahkota Binokasih",
      imagePath: 'assets/images/koleksi_7.png',
      deskripsiSingkat: "Mahkota peninggalan Kerajaan Pajajaran.",
    ),
    Koleksi(
      nama: "Kuda Lumping",
      imagePath: 'assets/images/koleksi_8.png',
      deskripsiSingkat: "Properti tari tradisional berbentuk tiruan kuda.",
    ),
    Koleksi(
      nama: "Angklung Buhun",
      imagePath: 'assets/images/koleksi_9.png',
      deskripsiSingkat: "Alat musik bambu kuno khas masyarakat Baduy.",
    ),
    Koleksi(
      nama: "Wayang Beber",
      imagePath: 'assets/images/koleksi_10.png',
      deskripsiSingkat: "Wayang berbentuk lembaran cerita bergambar.",
    ),
    Koleksi(
      nama: "Tombak Trisula",
      imagePath: 'assets/images/koleksi_11.png',
      deskripsiSingkat: "Senjata tradisional bermata tiga.",
    ),
    Koleksi(
      nama: "Topeng Kelana",
      imagePath: 'assets/images/koleksi_12.png',
      deskripsiSingkat: "Topeng berwarna merah melambangkan kemarahan.",
    ),
    Koleksi(
      nama: "Gamelan Kenong",
      imagePath: 'assets/images/koleksi_13.png',
      deskripsiSingkat: "Alat musik pukul yang menjadi penegas irama.",
    ),
    Koleksi(
      nama: "Arca Ganesha",
      imagePath: 'assets/images/koleksi_14.png',
      deskripsiSingkat: "Patung dewa pelindung dan lambang pengetahuan.",
    ),
    Koleksi(
      nama: "Blencong",
      imagePath: 'assets/images/koleksi_15.png',
      deskripsiSingkat: "Lampu minyak gantung khusus pertunjukan wayang kulit.",
    ),
  ];

  // List kartu yang akan dirender oleh Swiper
  List<Widget> _cards = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  void _loadCards() {
    // Membangun widget kartu berdasarkan data koleksi
    _cards = _daftarKoleksi.map((koleksi) {
      return _buildCard(koleksi);
    }).toList();
  }

  // --- FUNGSI BARU: LOMPAT KE KARTU PENCARIAN ---
  void _jumpToCard(Koleksi targetKoleksi) {
    int targetIndex = _daftarKoleksi.indexOf(targetKoleksi);

    if (targetIndex != -1 && targetIndex != 0) {
      setState(() {
        // 1. Potong dan gabung array agar item yang dicari pindah ke urutan pertama (index 0)
        List<Koleksi> reorderedList = [
          ..._daftarKoleksi.sublist(targetIndex),
          ..._daftarKoleksi.sublist(0, targetIndex),
        ];

        // 2. Terapkan susunan baru ke database lokal kita
        _daftarKoleksi.clear();
        _daftarKoleksi.addAll(reorderedList);

        // 3. Render ulang desain kartunya
        _loadCards();

        // 4. Reset teks deskripsi ke index 0 (karena item target sekarang ada di atas)
        _currentIndex = 0;

        // 5. Ubah kunci Swiper agar Flutter merender ulang tumpukannya dengan mulus
        _swiperKey = UniqueKey();
      });
    }
  }

  // Fungsi untuk menangani saat kartu diswipe
  // --- KODE BARU UNTUK FUNGSI SWIPE ---
  void _onSwipeEnd(
    int previousIndex,
    int targetIndex,
    SwiperActivity activity,
  ) {
    if (activity is Swipe) {
      setState(() {
        // Karena loop: true, targetIndex akan terus bertambah (15, 16, 17, dst).
        // Modulus (%) memastikan index selalu kembali ke rentang 0 sampai panjang array dikurangi 1.
        _currentIndex = targetIndex % _daftarKoleksi.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Mencegah keyboard mendorong UI ke atas
      body: Stack(
        children: [
          // 1. BACKGROUND GRADIENT (Mengikuti desain Onboarding)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1B2342), // Biru gelap atas
                  Color(0xFF2C392A), // Kehijauan/Kuning tengah
                  Color(0xFF141318), // Gelap bawah
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 2. HEADER (Logo, Search Bar, Profil)
                _buildHeader(),

                // 3. JUDUL "KOLEKSI GUBUG WAYANG"
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'KOLEKSI GUBUG WAYANG',
                    style: TextStyle(
                      fontFamily:
                          'Inter', // Atau font serif jika sesuai desain (misal: 'Playfair Display')
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2.0,
                      color: Colors.white,
                    ),
                  ),
                ),

                // 4. AREA SWIPER (Album Animasi)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    // --- KODE BARU UNTUK WIDGET SWIPER ---
                    child: AppinioSwiper(
                      key: _swiperKey,
                      controller: _swiperController,
                      cardCount:
                          _cards.length, // cardsCount diubah menjadi cardCount
                      onSwipeEnd:
                          _onSwipeEnd, // onSwipe diubah menjadi onSwipeEnd
                      backgroundCardCount: 2,
                      backgroundCardScale: 0.9,
                      backgroundCardOffset: const Offset(0, -30),
                      loop: true,
                      cardBuilder: (BuildContext context, int index) {
                        // cardsBuilder diubah menjadi cardBuilder
                        return _cards[index];
                      },
                    ),
                  ),
                ),

                // 5. TEKS DESKRIPSI DI BAWAH KARTU
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    _daftarKoleksi[_currentIndex].deskripsiSingkat,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ),

                // 6. BOTTOM NAVIGATION / ACTION BUTTONS
                _buildBottomActions(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: HEADER DENGAN SEARCH AUTOCOMPLETE ---
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          // Logo Kiri
          ClipOval(
            // Tambahkan ClipOval agar gambar dari internet terpotong bulat rapi
            child: Image.asset(
              'assets/images/polinema.png', // MASUKKAN URL GAMBARMU DI SINI
              height: 40,
              width: 40,
              fit: BoxFit.cover, // Memastikan gambar memenuhi area lingkaran
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.school, color: Colors.white, size: 40),
            ),
          ),
          const SizedBox(width: 12),

          // Search Bar Autocomplete
          Expanded(
            child: RawAutocomplete<Koleksi>(
              textEditingController: _searchController,
              focusNode: FocusNode(),
              displayStringForOption: (Koleksi option) => option.nama,
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<Koleksi>.empty();
                }
                return _daftarKoleksi.where((Koleksi option) {
                  return option.nama.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  );
                });
              },
              onSelected: (Koleksi selection) {
                // --- PANGGIL FUNGSI LOMPAT KARTU & TUTUP KEYBOARD ---
                _jumpToCard(selection);
                FocusScope.of(context).unfocus();
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Cari koleksi...',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(color: Colors.white30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(color: Colors.white30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    );
                  },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFF2C392A), // Sesuaikan warna dropdown
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 200,
                        maxWidth: 250,
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Koleksi option = options.elementAt(index);
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                option.imagePath,
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.image, size: 30),
                              ),
                            ),
                            title: Text(
                              option.nama,
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              onSelected(option);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),

          // Logo Kanan
          Container(
            height: 40,
            width: 40,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                'assets/images/Logo_gubugwayang.png', // Ganti dengan logo Wayang Anda
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.museum, color: Colors.black, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: DESAIN KARTU/ALBUM ---
  Widget _buildCard(Koleksi koleksi) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          // MENGGUNAKAN STACK AGAR BISA DITUMPUK
          fit: StackFit
              .expand, // Memaksa isi tumpukan memenuhi seluruh layar kartu
          children: [
            // 1. GAMBAR LATAR BELAKANG
            Image.asset(
              koleksi.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            // 2. KOTAK JUDUL (ROUNDED 30)
            Positioned(
              bottom: 20, // Jarak kotak dari ujung bawah kartu
              left: 20, // Jarak kotak dari ujung kiri kartu
              child: ClipRRect(
                // Menambahkan efek blur sedikit ala iOS/Figma agar lebih premium (Opsional)
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(
                        0.5,
                      ), // Latar hitam semi-transparan
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // Efek melengkung
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ), // Garis tepi tipis
                    ),
                    child: Text(
                      koleksi.nama, // Menampilkan judul koleksi secara dinamis
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER: TOMBOL BOTTOM (Menu, Kamera/AR, Info) ---
  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tombol Grid
          _buildCircleButton(
            icon: Icons.grid_view_rounded,
            onTap: () {
              // Aksi lihat semua koleksi
            },
          ),

          // Tombol Kamera/AR Tengah
          Container(
            height: 60,
            width: 140,
            decoration: BoxDecoration(
              color: const Color(0xFF1B233A), // Warna biru gelap tombol AR
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.filter_center_focus,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // --- KODE BARU: NAVIGASI KE QR SCANNER ---
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QRScannerScreen(),
                      ),
                    );
                  },
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white30,
                ), // Garis pemisah
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "AR",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tombol Info
          _buildCircleButton(
            icon: Icons.info_outline_rounded,
            onTap: () {
              // Aksi lihat info
            },
          ),
        ],
      ),
    );
  }

  // Helper untuk membuat tombol lingkaran
  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
