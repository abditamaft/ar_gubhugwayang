import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../provider/language_provider.dart';

class InfoMuseumScreen extends StatefulWidget {
  const InfoMuseumScreen({super.key});

  @override
  State<InfoMuseumScreen> createState() => _InfoMuseumScreenState();
}

class _InfoMuseumScreenState extends State<InfoMuseumScreen>
    with LanguageAware {
  @override
  Widget build(BuildContext context) {
    final im = AppStrings.infoMuseum; // shortcut

    return Scaffold(
      backgroundColor: const Color(0xFF1A1F3A),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A1F3A),
                  Color(0xFF1E2D4A),
                  Color(0xFF162235),
                ],
              ),
            ),
          ),

          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD4A24C).withOpacity(0.07),
              ),
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildAppBar(im)),
                SliverToBoxAdapter(child: _buildHeroSection(im)),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.1,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                    delegate: SliverChildListDelegate([
                      _buildMenuCard(
                        title: lp.s(im, 'menu_tentang_app'),
                        icon: Icons.phone_android_rounded,
                        color: const Color(0xFF3B5BDB),
                        lightColor: const Color(0xFF748FFC),
                        onTap: () => _openSubPage(const _TentangAplikasiPage()),
                      ),
                      _buildMenuCard(
                        title: lp.s(im, 'menu_fitur'),
                        icon: Icons.auto_awesome_rounded,
                        color: const Color(0xFF087F5B),
                        lightColor: const Color(0xFF38D9A9),
                        onTap: () => _openSubPage(const _FiturAplikasiPage()),
                      ),
                      _buildMenuCard(
                        title: lp.s(im, 'menu_tujuan'),
                        icon: Icons.track_changes_rounded,
                        color: const Color(0xFF862E9C),
                        lightColor: const Color(0xFFDA77FF),
                        onTap: () =>
                            _openSubPage(const _TujuanPengembanganPage()),
                      ),
                      _buildMenuCard(
                        title: lp.s(im, 'menu_museum'),
                        icon: Icons.museum_rounded,
                        color: const Color(0xFF9C4A00),
                        lightColor: const Color(0xFFD4A24C),
                        onTap: () => _openSubPage(const _TentangMuseumPage()),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(Map<String, Map<String, String>> im) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              // ✅ Ikut bahasa
              lp.s(im, 'appbar_title'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(Map<String, Map<String, String>> im) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        children: [
          // ✅ Judul utama ikut bahasa
          Text(
            lp.s(im, 'hero_title'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              height: 1.3,
            ),
          ),

          const SizedBox(height: 28),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogoContainer('assets/images/Logo_gubugwayang.png', 75),
              const SizedBox(width: 24),
              Container(
                width: 1,
                height: 60,
                color: Colors.white.withOpacity(0.2),
              ),
              const SizedBox(width: 24),
              _buildLogoContainer('assets/images/polinema.png', 75),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFD4A24C).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFD4A24C).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              // ✅ Tagline ikut bahasa
              lp.s(im, 'tagline'),
              style: const TextStyle(
                color: Color(0xFFD4A24C),
                fontSize: 12,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoContainer(String assetPath, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
      ),
      padding: const EdgeInsets.all(10),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.image_not_supported,
          color: Colors.white38,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    required Color color,
    required Color lightColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.85), color.withOpacity(0.6)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: lightColor.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lightColor.withOpacity(0.15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              height: 1.3,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white54,
                          size: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openSubPage(Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => page,
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// BASE SUB PAGE
// ═══════════════════════════════════════════════════════════════════
class _BaseSubPage extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color accentColor;

  const _BaseSubPage({
    required this.title,
    required this.children,
    this.accentColor = const Color(0xFFD4A24C),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1F3A),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A1F3A),
                  Color(0xFF1E2D4A),
                  Color(0xFF162235),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      gradient: LinearGradient(
                        colors: [accentColor, accentColor.withOpacity(0.0)],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────
Widget _sectionTitle(String text, {Color color = const Color(0xFFD4A24C)}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Inter',
      ),
    ),
  );
}

Widget _bodyText(String text) {
  return Text(
    text,
    textAlign: TextAlign.justify,
    style: const TextStyle(
      color: Colors.white70,
      fontSize: 14,
      fontFamily: 'Inter',
      height: 1.6,
    ),
  );
}

Widget _numberedList(
  List<String> items, {
  Color bulletColor = const Color(0xFFD4A24C),
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: items.asMap().entries.map((e) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(right: 10, top: 1),
              decoration: BoxDecoration(
                color: bulletColor.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: bulletColor.withOpacity(0.5)),
              ),
              child: Center(
                child: Text(
                  '${e.key + 1}',
                  style: TextStyle(
                    color: bulletColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                e.value,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
      );
    }).toList(),
  );
}

Widget _divider() => Padding(
  padding: const EdgeInsets.symmetric(vertical: 20),
  child: Container(height: 1, color: Colors.white.withOpacity(0.1)),
);

Widget _imageBox(String assetPath, {double height = 180}) {
  return Container(
    height: height,
    margin: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white.withOpacity(0.05),
      border: Border.all(color: Colors.white12),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.image, color: Colors.white24, size: 48),
        ),
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════
// HALAMAN 1: TENTANG APLIKASI
// ═══════════════════════════════════════════════════════════════════
class _TentangAplikasiPage extends StatefulWidget {
  const _TentangAplikasiPage();

  @override
  State<_TentangAplikasiPage> createState() => _TentangAplikasiPageState();
}

class _TentangAplikasiPageState extends State<_TentangAplikasiPage>
    with LanguageAware {
  @override
  Widget build(BuildContext context) {
    final isId = lp.isIndonesian;

    return _BaseSubPage(
      title: isId ? 'Tentang Aplikasi' : 'About the Application',
      accentColor: const Color(0xFF748FFC),
      children: [
        _sectionTitle(
          isId ? 'Tentang Aplikasi' : 'About the Application',
          color: const Color(0xFF748FFC),
        ),
        _bodyText(
          isId
              ? 'Aplikasi ini merupakan media edukasi interaktif dwi bahasa berbasis Augmented Reality. Aplikasi ini merupakan produk penelitian terapan inovasi yang dikembangkan oleh tim peneliti dari Politeknik Negeri Malang bekerja sama dengan Museum Gubug Wayang sebagai mitra penelitian.\n\nDengan memanfaatkan teknologi AR, pengguna dapat memindai objek atau gambar wayang untuk menampilkan visual 3D serta informasi digital secara langsung. Aplikasi dirancang untuk berjalan di perangkat Android, memberikan pengalaman museum yang imersif bagi semua kalangan.'
              : 'This application is a bilingual interactive educational medium based on Augmented Reality (AR) technology. It is an innovative applied research product developed by a research team from Politeknik Negeri Malang in collaboration with Museum Gubug Wayang as a research partner.\n\nBy utilizing AR technology, users can scan wayang objects or images to instantly display 3D visualizations and digital information. The application is designed to run on Android devices, providing an immersive museum experience for visitors of all ages and backgrounds.',
        ),

        _divider(),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _bodyText(
                isId
                    ? 'Aplikasi dirancang untuk berjalan di perangkat Android untuk memberikan pengalaman museum yang imersif bagi semua kalangan.'
                    : 'The application is designed to run on Android devices for providing an immersive museum experience for all audiences.',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 2,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(color: Colors.white12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/Logo_gubugwayang.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.museum,
                      color: Colors.white38,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// HALAMAN 2: FITUR APLIKASI
// ═══════════════════════════════════════════════════════════════════
class _FiturAplikasiPage extends StatefulWidget {
  const _FiturAplikasiPage();

  @override
  State<_FiturAplikasiPage> createState() => _FiturAplikasiPageState();
}

class _FiturAplikasiPageState extends State<_FiturAplikasiPage>
    with LanguageAware {
  @override
  Widget build(BuildContext context) {
    final isId = lp.isIndonesian;

    final List<Map<String, dynamic>> fitur = isId
        ? [
            {
              'icon': Icons.qr_code_scanner_rounded,
              'judul': 'Scan AR Kamera',
              'desc':
                  'Arahkan kamera ke gambar atau objek wayang untuk menampilkan model 3D secara langsung.',
            },
            {
              'icon': Icons.language_rounded,
              'judul': 'Informasi Dwi Bahasa',
              'desc':
                  'Informasi tersedia dalam dua bahasa (Indonesia & English) untuk menjangkau pengunjung lokal dan internasional.',
            },
            {
              'icon': Icons.info_rounded,
              'judul': 'Informasi Edukatif',
              'desc':
                  'Menampilkan deskripsi karakter dari setiap koleksi wayang secara detail.',
            },
            {
              'icon': Icons.collections_bookmark_rounded,
              'judul': 'Koleksi Saya',
              'desc':
                  'Simpan koleksi yang sudah di-scan dan akses kembali kapan saja tanpa perlu scan ulang.',
            },
          ]
        : [
            {
              'icon': Icons.qr_code_scanner_rounded,
              'judul': 'AR Camera Scan',
              'desc':
                  'Point the camera at a wayang image or object to instantly display its 3D model.',
            },
            {
              'icon': Icons.language_rounded,
              'judul': 'Bilingual Information',
              'desc':
                  'Information is available in two languages (Indonesian and English) to accommodate both local and international visitors.',
            },
            {
              'icon': Icons.info_rounded,
              'judul': 'Educational Content',
              'desc':
                  'Provides detailed descriptions and background information about each wayang character and collection.',
            },
            {
              'icon': Icons.collections_bookmark_rounded,
              'judul': 'My Collection',
              'desc':
                  'Save scanned collections and access them anytime without the need to scan them again.',
            },
          ];

    return _BaseSubPage(
      title: isId ? 'Fitur Aplikasi' : 'Application Features',
      accentColor: const Color(0xFF38D9A9),
      children: [
        _sectionTitle(
          isId ? 'Fitur Aplikasi' : 'Application Features',
          color: const Color(0xFF38D9A9),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: fitur
                    .map(
                      (f) => _buildFiturItem(
                        icon: f['icon'] as IconData,
                        judul: f['judul'] as String,
                        desc: f['desc'] as String,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(0.05),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/bg-wayanggunungan.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.image,
                          color: Colors.white38,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFiturItem({
    required IconData icon,
    required String judul,
    required String desc,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF38D9A9).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF38D9A9), size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    height: 1.4,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// HALAMAN 3: TUJUAN PENGEMBANGAN
// ═══════════════════════════════════════════════════════════════════
class _TujuanPengembanganPage extends StatefulWidget {
  const _TujuanPengembanganPage();

  @override
  State<_TujuanPengembanganPage> createState() =>
      _TujuanPengembanganPageState();
}

class _TujuanPengembanganPageState extends State<_TujuanPengembanganPage>
    with LanguageAware {
  @override
  Widget build(BuildContext context) {
    final isId = lp.isIndonesian;

    final List<String> tujuan = isId
        ? [
            'untuk mengenalkan dan mempromosikan koleksi Museum Gubug Wayang',
            'memberikan pengalaman museum yang imersif bagi semua kalangan',
          ]
        : [
            'To introduce and promote the collections of Museum Gubug Wayang.',
            'To provide an immersive museum experience for visitors from all backgrounds.',
          ];

    return _BaseSubPage(
      title: isId ? 'Tujuan Pengembangan' : 'Development Goals',
      accentColor: const Color(0xFFDA77FF),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(color: Colors.white12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/images/Logo_gubugwayang.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.museum,
                        color: Colors.white38,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(
                    isId ? 'Tujuan Pengembangan' : 'Development Objectives',
                    color: const Color(0xFFDA77FF),
                  ),
                  _bodyText(
                    isId
                        ? 'Aplikasi ini dikembangkan dengan tujuan:'
                        : 'This application was developed with the following goals:',
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _numberedList(tujuan, bulletColor: const Color(0xFFDA77FF)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// HALAMAN 4: TENTANG MUSEUM + KONTAK + CREDITS
// ═══════════════════════════════════════════════════════════════════
class _TentangMuseumPage extends StatefulWidget {
  const _TentangMuseumPage();

  @override
  State<_TentangMuseumPage> createState() => _TentangMuseumPageState();
}

class _TentangMuseumPageState extends State<_TentangMuseumPage>
    with LanguageAware {
  @override
  Widget build(BuildContext context) {
    final isId = lp.isIndonesian;

    return _BaseSubPage(
      title: isId ? 'Tentang Museum' : 'About the Museum',
      accentColor: const Color(0xFFD4A24C),
      children: [
        _sectionTitle(
          isId ? 'Tentang Museum Gubug Wayang' : 'About Museum Gubug Wayang',
        ),
        _bodyText(
          isId
              ? 'Museum Gubug Wayang didirikan oleh Yensen Project Indonesia sebagai wujud rasa peduli terhadap seni dan budaya Indonesia yang beraneka ragam. Kecintaaan terhadap sejarah seni dan budaya Indonesia memberikan semangat untuk menjaga dan melestarikannya. Koleksi yang ada meliputi wayang dari berbagai daerah di Indonesia, pusaka asli Indonesia, alat musik tradisional, mainan anak – anak, topeng dan lain lainnya. Wisata edukasi seni dan budaya menjadi tujuan berdirinya museum Gubug Wayang, agar masyarakat lebih mengenal dan merasa memiliki seni dan budaya yang sudah diwariskan secara turun temurun. Museum ini diresmikan pada tanggal 15 Agustus 2015 oleh Bp. Drs Suyadi/Pak Raden. Setelah perjalanan dua tahun museum, pada tanggal 15 Agustus 2017, Yensen Project Indonesia resmi berada dibawah naungan Sendjojo Njoto Seni Budoyo yang dikelola langsung oleh Bpk Sendjojo Njoto sebagai pemilik tunggal seluruh aset dan hak label Sendjojo Njoto Seni Budoyo beserta Yensen Project Indonesia. Kecintaan Museum Gubug Wayang akan luhurnya budaya Indonesia menjadi semangat kemerdekaan untuk terus berbenah dan memberikan informasi aktual dan faktual tentang Sejarah budaya Indonesia.'
              : 'Museum Gubug Wayang was established by Yensen Project Indonesia as a manifestation of its commitment to preserving Indonesia’s rich and diverse arts and cultural heritage. A deep appreciation for Indonesian history, arts, and culture has inspired continuous efforts to safeguard and promote these valuable traditions. The museum\'s collections include wayang from various regions of Indonesia, authentic Indonesian heirlooms, traditional musical instruments, children\'s traditional toys, masks, and many other cultural artifacts. Museum Gubug Wayang was founded as an educational tourism destination dedicated to arts and culture, with the goal of helping the public better understand, appreciate, and take pride in Indonesia\'s cultural heritage that has been passed down through generations. The museum was officially inaugurated on August 15, 2015, by Drs. Suyadi, widely known as Pak Raden. After two years of operation, on August 15, 2017, Yensen Project Indonesia officially came under the management of Sendjojo Njoto Seni Budoyo, which is directly managed by Mr. Sendjojo Njoto as the sole owner of all assets and intellectual property rights associated with the Sendjojo Njoto Seni Budoyo and Yensen Project Indonesia brands. The museum\’s dedication to preserving the noble values of Indonesian culture continues to inspire its mission to improve and provide accurate, up-to-date, and factual information about Indonesia\’s cultural history.',
        ),

        _divider(),

        _sectionTitle(
          isId ? 'Alamat dan Kontak kami' : 'Contact Information Address',
        ),
        _buildContactItem(
          Icons.location_on_rounded,
          isId ? 'Alamat' : 'Address',
          'Jalan R.A Kartini No.23, Kelurahan Kauman, Kecamatan Prajurit Kulon, Kota Mojokerto, Jawa Timur. Kode Pos: 61382',
        ),
        const SizedBox(height: 12),
        _buildContactItem(
          Icons.phone_rounded,
          isId ? 'Telepon' : 'Phone',
          '0811-352-7776',
        ),
        const SizedBox(height: 12),
        _buildContactItem(
          Icons.email_rounded,
          'Email',
          'museumgubugwayang@gmail.com',
        ),

        _divider(),

        _sectionTitle('Credits'),
        _buildCreditsSection(isId),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFD4A24C).withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFFD4A24C), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFD4A24C),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.4,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreditsSection(bool isId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isId
              ? 'Tim Penelitian dan Pengembangan'
              : 'Research and Development Team',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 10),
        _buildPersonCard(
          'Ririn Pratiwi Suharto, S.S., M.Hum.',
          'NIDN. 0730129201',
        ),
        _buildPersonCard('Achmad Suyono, S.Pd., M.S.', 'NIDN. 0026017106'),
        _buildPersonCard('Tri Ramadani Arjo S.ST., M.Kom.', 'NIDN. 1005108603'),
        _buildPersonCard(
          'Andi Reza Maulana, S.Pd., M.Pd.',
          'NIDN. 3151772673130303',
        ),

        const SizedBox(height: 20),

        Text(
          isId ? 'Mitra' : 'Research Partner',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 10),
        _buildPersonCard(
          isId ? 'Museum Gubung Wayang' : 'Museum Gubung Wayang',
          '',
        ),
      ],
    );
  }

  Widget _buildPersonCard(String name, String nidn) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFD4A24C).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Color(0xFFD4A24C),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
                if (nidn.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    nidn,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
