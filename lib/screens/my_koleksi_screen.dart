import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'ar_view_screen.dart';
import '../config/supabase_config.dart';
import '../provider/language_provider.dart';

// ═══════════════════════════════════════════════════════════════
// DATA MODEL KOLEKSI LENGKAP
// ═══════════════════════════════════════════════════════════════
class KoleksiData {
  final String id;
  final String nama;
  final String fileName;
  final String imagePath;
  final String deskripsi;
  final String deskripsiEn;

  const KoleksiData({
    required this.id,
    required this.nama,
    required this.fileName,
    required this.imagePath,
    required this.deskripsi,
    required this.deskripsiEn,
  });

  String get modelUrl => SupabaseConfig.getModelUrl(fileName);
}

// Master list 15 koleksi — satu sumber kebenaran
const List<KoleksiData> allKoleksi = [
  KoleksiData(
    id: '01-SI-UNYIL',
    nama: 'Si Unyil',
    fileName: 'si_unyil.glb',
    imagePath: 'assets/images/koleksi_1.png',
    deskripsi:
        'Si Unyil adalah karakter utama ciptaan Drs. Suyadi (Pak Raden) yang tayang sejak 1981. Ia merepresentasikan anak sekolah dasar di Indonesia yang lugu, ceria, selalu ingin tahu, dan mengajarkan nilai-nilai moral dalam kehidupan sehari-hari.',
    deskripsiEn:
        'Si Unyil is the main character created by Drs. Suyadi (Pak Raden), airing since 1981. He represents an innocent, cheerful, and curious Indonesian elementary school child, teaching moral values in daily life.',
  ),
  KoleksiData(
    id: '02-UCRIT',
    nama: 'Ucrit',
    fileName: 'ucrit.glb',
    imagePath: 'assets/images/koleksi_2.png',
    deskripsi:
        'Ucrit adalah salah satu sahabat karib Unyil yang beragama Katolik dan sering terlihat memakai kalung salib. Karakter ini sengaja diciptakan untuk merepresentasikan keberagaman sosial dan mengajarkan toleransi beragama sejak dini.',
    deskripsiEn:
        'Ucrit is one of Unyil\'s best friends who is Catholic and often seen wearing a cross necklace. This character was specifically created to represent social diversity and teach religious tolerance from an early age.',
  ),
  KoleksiData(
    id: '03-USRO',
    nama: 'Usro',
    fileName: 'usro.glb',
    imagePath: 'assets/images/koleksi_3.png',
    deskripsi:
        'Usro adalah teman sepermainan Unyil yang sangat khas dengan peci miringnya. Ia dikenal memiliki sifat yang sangat setia kawan dan sering kali menjadi penengah atau teman setia dalam berbagai petualangan di desa.',
    deskripsiEn:
        'Usro is Unyil\'s playmate, known for his distinctive tilted cap (peci). He is recognized for his deep loyalty to his friends and often acts as a mediator or a faithful companion in their village adventures.',
  ),
  KoleksiData(
    id: '04-PAK-OGAH',
    nama: 'Pak Ogah',
    fileName: 'pak_ogah.glb',
    imagePath: 'assets/images/koleksi_4.png',
    deskripsi:
        'Karakter tunakarya ikonik berkepala plontos yang terkenal dengan jargon "Cepek dulu dong". Pak Ogah diciptakan sebagai representasi sosial tentang pengangguran pemalas yang selalu mencari jalan pintas untuk mendapatkan uang.',
    deskripsiEn:
        'An iconic bald, unemployed character famous for his catchphrase "Cepek dulu dong". Pak Ogah was created as a social representation of a lazy unemployed person always looking for shortcuts to get money.',
  ),
  KoleksiData(
    id: '05-PAK-RADEN',
    nama: 'Pak Raden',
    fileName: 'pak_raden.glb',
    imagePath: 'assets/images/koleksi_5.png',
    deskripsi:
        'Pak Raden adalah karakter keturunan bangsawan Jawa berpakaian beskap yang kaku, pelit, serta mudah marah. Karakter ini disuarakan dan diciptakan langsung oleh mendiang Drs. Suyadi sebagai karikatur golongan priyayi tua.',
    deskripsiEn:
        'Pak Raden is a Javanese noble descendant dressed in a traditional beskap, known for being stiff, stingy, and short-tempered. Created by the late Drs. Suyadi as a caricature of conservative elder nobles.',
  ),
  KoleksiData(
    id: '06-MBOK-BARIAH',
    nama: 'Mbok Bariah',
    fileName: 'mbok_bariah.glb',
    imagePath: 'assets/images/koleksi_6.png',
    deskripsi:
        'Mbok Bariah adalah tokoh penjual rujak asal Madura dengan logat bicara kental yang sangat khas. Karakter ini melambangkan kegigihan, semangat pantang menyerah, dan kerja keras yang menjadi identitas para pedagang perantauan.',
    deskripsiEn:
        'Mbok Bariah is a rujak seller from Madura with a very distinctive thick accent. This character symbolizes persistence, an unyielding spirit, and the hard work that forms the identity of migrating traders.',
  ),
  KoleksiData(
    id: '07-MEILANI',
    nama: 'Meilani',
    fileName: 'meilani.glb',
    imagePath: 'assets/images/koleksi_7.png',
    deskripsi:
        'Meilani adalah karakter anak perempuan keturunan Tionghoa berwajah manis yang memiliki sifat ramah dan pintar. Sosok ini didesain sebagai representasi asimilasi budaya, kebaikan hati, serta harmoni kehidupan antar etnis di Indonesia.',
    deskripsiEn:
        'Meilani is a sweet-faced girl of Chinese descent who is friendly and smart. Designed as a representation of cultural assimilation, kindness, and inter-ethnic harmony in Indonesia.',
  ),
  KoleksiData(
    id: '08-CUPLIS',
    nama: 'Cuplis',
    fileName: 'cuplis.glb',
    imagePath: 'assets/images/koleksi_8.png',
    deskripsi:
        'Cuplis adalah teman bermain Unyil yang sangat identik dengan kepala botaknya. Ia sering digambarkan sebagai anak yang periang, terkadang sedikit usil, namun kehadirannya selalu melengkapi dinamika persahabatan anak-anak di desa.',
    deskripsiEn:
        'Cuplis is Unyil\'s playmate, highly recognized by his bald head. Often depicted as a cheerful and sometimes mischievous child, his presence always completes the dynamic of children\'s friendships in the village.',
  ),
  KoleksiData(
    id: '09-PAK-ABLEH',
    nama: 'Pak Ableh',
    fileName: 'pak_ableh.glb',
    imagePath: 'assets/images/koleksi_9.png',
    deskripsi:
        'Pak Ableh adalah teman akrab sekaligus pengikut setia Pak Ogah yang juga tidak memiliki pekerjaan tetap. Ia digambarkan memiliki karakter yang terkesan lamban dan kurang cerdas, sering menemani Pak Ogah nongkrong di pos ronda.',
    deskripsiEn:
        'Pak Ableh is a close friend and loyal follower of Pak Ogah, who also does not have a steady job. Portrayed as rather slow and less intelligent, he often accompanies Pak Ogah at the neighborhood guard post.',
  ),
  KoleksiData(
    id: '10-SEMAR',
    nama: 'Semar',
    fileName: 'semar.glb',
    imagePath: 'assets/images/koleksi_10.png',
    deskripsi:
        'Semar adalah tokoh utama dalam kelompok Punakawan pewayangan Jawa dan Sunda yang diyakini sebagai penjelmaan dewa (Batara Ismaya). Ia melambangkan kearifan, kebijaksanaan murni, dan merupakan figur pamong spiritual bagi para ksatria.',
    deskripsiEn:
        'Semar is the main figure in the Punakawan group of Javanese and Sundanese puppetry, believed to be the incarnation of a god (Batara Ismaya). He symbolizes wisdom and acts as a spiritual guardian for the knights.',
  ),
  KoleksiData(
    id: '11-CEPOT',
    nama: 'Cepot',
    fileName: 'cepot.glb',
    imagePath: 'assets/images/koleksi_11.png',
    deskripsi:
        'Astrajingga atau lebih dikenal dengan nama Cepot adalah tokoh wayang golek Sunda berwajah merah. Ia sangat dikenal karena sifatnya yang humoris, jenaka, dan sering menjadi media dalang untuk menyampaikan kritik sosial secara ringan.',
    deskripsiEn:
        'Astrajingga, better known as Cepot, is a red-faced Sundanese wooden puppet character. Widely known for his humorous and witty nature, often serving as the puppeteer\'s medium to deliver social criticism lightly.',
  ),
  KoleksiData(
    id: '12-DAWALA',
    nama: 'Dawala',
    fileName: 'dawala.glb',
    imagePath: 'assets/images/koleksi_12.png',
    deskripsi:
        'Dawala adalah adik dari Cepot dalam jagat wayang golek Sunda yang memiliki ciri fisik berupa hidung mancung ke bawah. Ia memiliki sifat yang lebih tenang, sabar, dan selalu setia mendampingi saudaranya dalam berbagai situasi.',
    deskripsiEn:
        'Dawala is Cepot\'s younger brother in the Sundanese puppet universe, characterized by a downward-pointing nose. He has a calmer and more patient nature, always loyally accompanying his brother in various situations.',
  ),
  KoleksiData(
    id: '13-GARENG',
    nama: 'Gareng',
    fileName: 'gareng.glb',
    imagePath: 'assets/images/koleksi_13.png',
    deskripsi:
        'Gareng adalah tokoh Punakawan dengan ciri khas fisik tidak sempurna seperti mata juling dan kaki pincang. Ketidaksempurnaan ini secara filosofis merupakan simbolisasi dari sifat kehati-hatian dalam bertindak, melihat, dan melangkah di kehidupan.',
    deskripsiEn:
        'Gareng is a Punakawan character with distinctive physical imperfections such as crossed eyes and a limp. Philosophically, these imperfections symbolize caution in taking action, seeing, and stepping through life.',
  ),
  KoleksiData(
    id: '14-AMIR-HAMZAH',
    nama: 'Amir Hamzah',
    fileName: 'amir_hamzah.glb',
    imagePath: 'assets/images/koleksi_14.png',
    deskripsi:
        'Amir Hamzah adalah tokoh sentral dalam pertunjukan Wayang Golek Menak yang diadaptasi dari literatur epik bernapaskan Islam. Sosoknya melambangkan keberanian tempur, ketangguhan, dan keteguhan pahlawan dalam menyebarkan nilai kebaikan.',
    deskripsiEn:
        'Amir Hamzah is the central figure in the Wayang Golek Menak performance, adapted from Islamic epic literature. His figure symbolizes combat bravery, resilience, and steadfastness in spreading the values of goodness.',
  ),
  KoleksiData(
    id: '15-PANJI-ASMARABANGUN',
    nama: 'Panji Asmarabangun',
    fileName: 'panji_asmarabangun.glb',
    imagePath: 'assets/images/koleksi_15.png',
    deskripsi:
        'Panji Asmarabangun adalah tokoh utama dalam siklus Cerita Panji kuno nusantara sebagai pewaris takhta Kerajaan Jenggala. Ia merepresentasikan sosok ksatria luhur ideal yang sangat halus budi pekertinya, berwibawa, berani, dan romantis.',
    deskripsiEn:
        'Panji Asmarabangun is the main character in the ancient archipelago\'s Panji cycle tales as heir to the Jenggala Kingdom throne. He represents the ideal noble knight — refined in character, authoritative, brave, and romantic.',
  ),
];

// ═══════════════════════════════════════════════════════════════
// MY KOLEKSI SCREEN
// ═══════════════════════════════════════════════════════════════
class MyKoleksiScreen extends StatefulWidget {
  const MyKoleksiScreen({super.key});

  @override
  State<MyKoleksiScreen> createState() => _MyKoleksiScreenState();
}

class _MyKoleksiScreenState extends State<MyKoleksiScreen> with LanguageAware {
  // fileName → sudah di-cache (true) atau belum (false)
  final Map<String, bool> _cacheStatus = {};
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkAllCache();
  }

  Future<void> _checkAllCache() async {
    setState(() => _isChecking = true);
    final Directory cacheDir = await getTemporaryDirectory();
    final Map<String, bool> status = {};
    for (final k in allKoleksi) {
      final file = File('${cacheDir.path}/${k.fileName}');
      final exists = await file.exists();
      if (exists) {
        final size = await file.length();
        status[k.fileName] = size > 1000;
      } else {
        status[k.fileName] = false;
      }
    }
    if (mounted)
      setState(() {
        _cacheStatus.addAll(status);
        _isChecking = false;
      });
  }

  // Teks bilingual
  static const Map<String, Map<String, String>> _str = {
    'id': {
      'title': 'MY KOLEKSI',
      'subtitle': 'Koleksi yang sudah kamu scan',
      'unlocked': 'terkumpul',
      'locked_hint': 'Scan QR untuk membuka',
      'empty_title': 'Belum ada koleksi',
      'empty_sub':
          'Scan QR Code pada objek museum\nuntuk mulai mengumpulkan koleksi.',
      'view_ar': 'Lihat AR',
    },
    'en': {
      'title': 'MY COLLECTION',
      'subtitle': 'Collections you have scanned',
      'unlocked': 'collected',
      'locked_hint': 'Scan QR to unlock',
      'empty_title': 'No collection yet',
      'empty_sub': 'Scan the QR Code on museum objects\nto start collecting.',
      'view_ar': 'View AR',
    },
  };

  String _s(String key) {
    return _str[lp.lang]?[key] ?? _str['id']![key]!;
  }

  int get _unlockedCount => _cacheStatus.values.where((v) => v).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141318),
      body: Stack(
        children: [
          // ── Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1B2342),
                  Color(0xFF2C1F3A),
                  Color(0xFF141318),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── AppBar custom
                _buildHeader(),

                // ── Progress bar koleksi
                if (!_isChecking) _buildProgressBar(),

                // ── Grid koleksi
                Expanded(
                  child: _isChecking
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFD4A24C),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _checkAllCache,
                          color: const Color(0xFFD4A24C),
                          backgroundColor: const Color(0xFF1B2342),
                          child: GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.78,
                                ),
                            itemCount: allKoleksi.length,
                            itemBuilder: (context, index) {
                              final koleksi = allKoleksi[index];
                              final isUnlocked =
                                  _cacheStatus[koleksi.fileName] ?? false;
                              return _buildCard(koleksi, isUnlocked);
                            },
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          // Tombol back
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _s('title'),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  _s('subtitle'),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Refresh
          GestureDetector(
            onTap: _checkAllCache,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
              child: const Icon(
                Icons.refresh_rounded,
                color: Color(0xFFD4A24C),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final total = allKoleksi.length;
    final unlocked = _unlockedCount;
    final progress = unlocked / total;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$unlocked / $total ${_s('unlocked')}',
                style: const TextStyle(
                  color: Color(0xFFD4A24C),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFD4A24C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(KoleksiData koleksi, bool isUnlocked) {
    return GestureDetector(
      onTap: isUnlocked
          ? () => _openArView(koleksi)
          : () => _showLockedSnackbar(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: const Color(0xFFD4A24C).withOpacity(0.25),
                    blurRadius: 12,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Gambar koleksi
              Image.asset(
                koleksi.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF2C2A3A),
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white30,
                    size: 40,
                  ),
                ),
              ),

              // ── Overlay: gelap jika terkunci
              if (!isUnlocked)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.55),
                        Colors.black.withOpacity(0.80),
                      ],
                    ),
                  ),
                ),

              // ── Overlay tipis untuk yang unlocked (gradient bawah)
              if (isUnlocked)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.75),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

              // ── Badge UNLOCKED: border emas
              if (isUnlocked)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFD4A24C).withOpacity(0.7),
                        width: 2,
                      ),
                    ),
                  ),
                ),

              // ── Ikon gembok (terkunci)
              if (!isUnlocked)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.lock_rounded,
                          color: Colors.white54,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _s('locked_hint'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              // ── Nama + tombol AR (unlocked)
              if (isUnlocked)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Badge emas kecil
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4A24C),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: Colors.black,
                                size: 10,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'AR',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          koleksi.nama,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 4),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),

              // ── Nama di tengah bawah (terkunci)
              if (!isUnlocked)
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Text(
                    koleksi.nama,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openArView(KoleksiData koleksi) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ArViewScreen(
          modelUrl: koleksi.modelUrl,
          fileName: koleksi.fileName,
          modelName: koleksi.nama,
          deskripsi: koleksi.deskripsi,
          deskripsiEn: koleksi.deskripsiEn,
        ),
      ),
    );
  }

  void _showLockedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.lock_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              _s('locked_hint'),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1B2342),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
