import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'qr_scanner_screen.dart';
import '../provider/language_provider.dart';
import 'my_koleksi_screen.dart';

class Koleksi {
  final String nama;
  final String imagePath;
  final String deskripsiSingkat;
  final String deskripsiSingkatEn;

  Koleksi({
    required this.nama,
    required this.imagePath,
    required this.deskripsiSingkat,
    required this.deskripsiSingkatEn,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final AppinioSwiperController _swiperController = AppinioSwiperController();
  final TextEditingController _searchController = TextEditingController();
  Key _swiperKey = UniqueKey();

  final List<Koleksi> _daftarKoleksi = [
    Koleksi(
      nama: "Si Unyil",
      imagePath: 'assets/images/koleksi_1.png',
      deskripsiSingkat: "Wayang golek yang menggambarkan keluguan.",
      deskripsiSingkatEn: "Puppet character who symbolizes innocence.",
    ),
    Koleksi(
      nama: "Ucrit",
      imagePath: 'assets/images/koleksi_2.png',
      deskripsiSingkat: "Sahabat Unyil yang melambangkan keberagaman.",
      deskripsiSingkatEn: "Unyil's friend who symbolizes diversity.",
    ),
    Koleksi(
      nama: "Usro",
      imagePath: 'assets/images/koleksi_3.png',
      deskripsiSingkat: "Teman Unyil yang melambangkan kesetiakawanan.",
      deskripsiSingkatEn: "Unyil's friend who symbolizes solidarity.",
    ),
    Koleksi(
      nama: "Pak Ogah",
      imagePath: 'assets/images/koleksi_4.png',
      deskripsiSingkat: "Tokoh antagonis yang melambangkan pengangguran.",
      deskripsiSingkatEn: "Antagonist character who symbolizes unemployment.",
    ),
    Koleksi(
      nama: "Pak Raden",
      imagePath: 'assets/images/koleksi_5.png',
      deskripsiSingkat: "Tokoh pemarah yang melambangkan kepelitan.",
      deskripsiSingkatEn: "Grumpy character who symbolizes stinginess.",
    ),
    Koleksi(
      nama: "Mbok Bariah",
      imagePath: 'assets/images/koleksi_6.png',
      deskripsiSingkat: "Pedagang Madura yang melambangkan kegigihan.",
      deskripsiSingkatEn: "Madurese trader who symbolizes persistence.",
    ),
    Koleksi(
      nama: "Meilani",
      imagePath: 'assets/images/koleksi_7.png',
      deskripsiSingkat: "Teman Unyil yang melambangkan kecerdasan.",
      deskripsiSingkatEn: "Unyil's friend who symbolizes intelligence.",
    ),
    Koleksi(
      nama: "Cuplis",
      imagePath: 'assets/images/koleksi_8.png',
      deskripsiSingkat: "Teman botak yang melambangkan keceriaan.",
      deskripsiSingkatEn: "Bald friend who symbolizes cheerfulness.",
    ),
    Koleksi(
      nama: "Pak Ableh",
      imagePath: 'assets/images/koleksi_9.png',
      deskripsiSingkat: "Rekan Ogah yang melambangkan kelengahan.",
      deskripsiSingkatEn: "Ogah's partner who symbolizes negligence.",
    ),
    Koleksi(
      nama: "Semar",
      imagePath: 'assets/images/koleksi_10.png',
      deskripsiSingkat: "Tokoh bijaksana yang melambangkan pengasuhan.",
      deskripsiSingkatEn: "Wise character who symbolizes nurturing.",
    ),
    Koleksi(
      nama: "Cepot",
      imagePath: 'assets/images/koleksi_11.png',
      deskripsiSingkat: "Anak Semar yang melambangkan humor.",
      deskripsiSingkatEn: "Semar's son who symbolizes humor.",
    ),
    Koleksi(
      nama: "Dawala",
      imagePath: 'assets/images/koleksi_12.png',
      deskripsiSingkat: "Saudara Cepot yang melambangkan kesabaran.",
      deskripsiSingkatEn: "Cepot's brother who symbolizes patience.",
    ),
    Koleksi(
      nama: "Gareng",
      imagePath: 'assets/images/koleksi_13.png',
      deskripsiSingkat: "Anak Semar yang melambangkan kehati-hatian.",
      deskripsiSingkatEn: "Semar's son who symbolizes caution.",
    ),
    Koleksi(
      nama: "Amir Hamzah",
      imagePath: 'assets/images/koleksi_14.png',
      deskripsiSingkat: "Pahlawan Islam yang melambangkan keberanian.",
      deskripsiSingkatEn: "Islamic hero who symbolizes bravery.",
    ),
    Koleksi(
      nama: "Panji Asmarabangun",
      imagePath: 'assets/images/koleksi_15.png',
      deskripsiSingkat: "Kesatria luhur yang melambangkan kehalusan.",
      deskripsiSingkatEn: "Noble knight who symbolizes refinement.",
    ),
  ];

  List<Widget> _cards = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  void _loadCards() {
    _cards = _daftarKoleksi.map((k) => _buildCard(k)).toList();
  }

  void _jumpToCard(Koleksi targetKoleksi) {
    int targetIndex = _daftarKoleksi.indexOf(targetKoleksi);
    if (targetIndex != -1 && targetIndex != 0) {
      setState(() {
        List<Koleksi> reorderedList = [
          ..._daftarKoleksi.sublist(targetIndex),
          ..._daftarKoleksi.sublist(0, targetIndex),
        ];
        _daftarKoleksi.clear();
        _daftarKoleksi.addAll(reorderedList);
        _loadCards();
        _currentIndex = 0;
        _swiperKey = UniqueKey();
      });
    }
  }

  void _onSwipeEnd(
    int previousIndex,
    int targetIndex,
    SwiperActivity activity,
  ) {
    if (activity is Swipe) {
      setState(() {
        _currentIndex = targetIndex % _daftarKoleksi.length;
      });
    }
  }

  // ── BOTTOM SHEET BAHASA ──────────────────────────────
  void _showLanguageSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      // Animasi dari bawah ke atas — default showModalBottomSheet sudah ada
      builder: (context) => _LanguageSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageScope.of(context);
    final db = AppStrings.dashboard;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1B2342),
                  Color(0xFF2C392A),
                  Color(0xFF141318),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(lang, db),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    lang.s(db, 'title'),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2.0,
                      color: Colors.white,
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: AppinioSwiper(
                      key: _swiperKey,
                      controller: _swiperController,
                      cardCount: _cards.length,
                      onSwipeEnd: _onSwipeEnd,
                      backgroundCardCount: 2,
                      backgroundCardScale: 0.9,
                      backgroundCardOffset: const Offset(0, -30),
                      loop: true,
                      cardBuilder: (context, index) => _cards[index],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    lang.isIndonesian
                        ? _daftarKoleksi[_currentIndex].deskripsiSingkat
                        : _daftarKoleksi[_currentIndex].deskripsiSingkatEn,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ),

                _buildBottomActions(lang, db),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    LanguageProvider lang,
    Map<String, Map<String, String>> db,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          // Logo Kiri
          ClipOval(
            child: Image.asset(
              'assets/images/polije.png',
              height: 40,
              width: 40,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.school, color: Colors.white, size: 40),
            ),
          ),
          const SizedBox(width: 12),

          // Search Bar
          Expanded(
            child: RawAutocomplete<Koleksi>(
              textEditingController: _searchController,
              focusNode: FocusNode(),
              displayStringForOption: (Koleksi option) => option.nama,
              optionsBuilder: (TextEditingValue value) {
                if (value.text.isEmpty) return const Iterable<Koleksi>.empty();
                return _daftarKoleksi.where(
                  (k) =>
                      k.nama.toLowerCase().contains(value.text.toLowerCase()),
                );
              },
              onSelected: (Koleksi selection) {
                _jumpToCard(selection);
                FocusScope.of(context).unfocus();
              },
              fieldViewBuilder: (context, controller, focusNode, _) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: lang.s(db, 'search'),
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
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
                    color: const Color(0xFF2C392A),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 200,
                        maxWidth: 250,
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
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
                            onTap: () => onSelected(option),
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
          SizedBox(
            height: 40,
            width: 40,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                'assets/images/Logo_gubugwayang.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.museum, color: Colors.black, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          fit: StackFit.expand,
          children: [
            Image.asset(
              koleksi.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
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
            Positioned(
              bottom: 20,
              left: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      koleksi.nama,
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

  Widget _buildBottomActions(
    LanguageProvider lang,
    Map<String, Map<String, String>> db,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF1B233A).withOpacity(0.88),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ── 1. Tombol Globe (Bahasa)
                _buildIslandButton(
                  icon: Icons.language_rounded,
                  onTap: _showLanguageSheet,
                ),

                _buildDivider(),

                // ── 2. Tombol Scan QR
                _buildIslandButton(
                  icon: Icons.filter_center_focus_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QRScannerScreen(),
                      ),
                    );
                  },
                ),

                _buildDivider(),

                // ── 3. Tombol AR (label teks)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QRScannerScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'AR',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                _buildDivider(),

                // ── 4. Tombol My Koleksi
                _buildIslandButton(
                  icon: Icons.collections_bookmark_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyKoleksiScreen(),
                      ),
                    );
                  },
                  isHighlighted: true, // warna emas
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIslandButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isHighlighted = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Icon(
          icon,
          color: isHighlighted ? const Color(0xFFD4A24C) : Colors.white,
          size: 26,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 28,
      color: Colors.white.withOpacity(0.12),
    );
  }
}

// ═══════════════════════════════════════════════════════
// LANGUAGE BOTTOM SHEET WIDGET
// ═══════════════════════════════════════════════════════
class _LanguageSheet extends StatefulWidget {
  @override
  State<_LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<_LanguageSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageScope.of(context);
    final db = AppStrings.dashboard;

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnim,
          child: Transform.translate(
            offset: Offset(0, 60 * _slideAnim.value),
            child: child,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1B2342).withOpacity(0.95),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              border: Border.all(color: Colors.white12, width: 1),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4A24C).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.language_rounded,
                            color: Color(0xFFD4A24C),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang.s(db, 'langSheet_title'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              lang.s(db, 'langSheet_sub'),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Opsi Bahasa Indonesia
                    _buildLangOption(
                      context: context,
                      lang: lang,
                      langCode: 'id',
                      flag: '🇮🇩',
                      name: lang.s(db, 'lang_id'),
                      subtitle: lang.s(db, 'lang_id_sub'),
                    ),

                    const SizedBox(height: 12),

                    // Opsi English
                    _buildLangOption(
                      context: context,
                      lang: lang,
                      langCode: 'en',
                      flag: '🇬🇧',
                      name: lang.s(db, 'lang_en'),
                      subtitle: lang.s(db, 'lang_en_sub'),
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLangOption({
    required BuildContext context,
    required LanguageProvider lang,
    required String langCode,
    required String flag,
    required String name,
    required String subtitle,
  }) {
    final bool isSelected = lang.lang == langCode;

    return GestureDetector(
      onTap: () {
        lang.setLanguage(langCode);
        // Tutup sheet setelah pilih
        Navigator.pop(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD4A24C).withOpacity(0.15)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4A24C).withOpacity(0.6)
                : Colors.white12,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Flag emoji
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),

            // Nama + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFFD4A24C)
                          : Colors.white,
                      fontSize: 15,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),

            // Centang jika dipilih
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSelected
                  ? Container(
                      key: const ValueKey('check'),
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4A24C),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.black,
                        size: 14,
                      ),
                    )
                  : const SizedBox(key: ValueKey('empty'), width: 22),
            ),
          ],
        ),
      ),
    );
  }
}
