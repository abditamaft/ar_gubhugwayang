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

// Master list 20 koleksi — satu sumber kebenaran
const List<KoleksiData> allKoleksi = [
  KoleksiData(
    id: '01-SI-UNYIL',
    nama: 'Si Unyil',
    fileName: 'si_unyil.glb',
    imagePath: 'assets/images/koleksi_1.png',
    deskripsi:
        'Anak laki-laki yang menjadi tokoh utama. Unyil dikenal cerdas, baik hati, rajin, suka menolong, dan sering menjadi teladan bagi teman-temannya.',
    deskripsiEn:
        'A young boy who serves as the main character of the series. Unyil is known for being intelligent, kind-hearted, diligent, helpful, and often acts as a role model for his friends.',
  ),
  KoleksiData(
    id: '02-UCRIT',
    nama: 'Ucrit',
    fileName: 'ucrit.glb',
    imagePath: 'assets/images/koleksi_2.png',
    deskripsi:
        'Sahabat Unyil yang bertubuh kecil dan kurus. Ucrit dikenal polos, lugu, serta sering menimbulkan kelucuan dalam berbagai situasi.',
    deskripsiEn:
        'Unyil\'s friend, who is small and thin. Ucrit is known for being innocent, naïve, and often brings humor to various situations.',
  ),
  KoleksiData(
    id: '03-USRO',
    nama: 'Usro',
    fileName: 'usro.glb',
    imagePath: 'assets/images/koleksi_3.png',
    deskripsi:
        'Teman Unyil yang memiliki sifat baik dan suka bekerja sama. Usro sering ikut dalam berbagai kegiatan dan petualangan bersama teman-temannya.',
    deskripsiEn:
        'One of Unyil\’s friends who is kind and cooperative. Usro frequently takes part in various activities and adventures with his friends.',
  ),
  KoleksiData(
    id: '04-PAK-OGAH',
    nama: 'Pak Ogah',
    fileName: 'pak_ogah.glb',
    imagePath: 'assets/images/koleksi_4.png',
    deskripsi:
        'Tokoh yang terkenal karena sifatnya yang malas dan sering meminta imbalan sebelum membantu orang lain. Kalimat khasnya adalah meminta “cepek dulu”',
    deskripsiEn:
        'A character famous for his laziness and his habit of asking for payment before helping others. His trademark phrase involves requesting money first before offering assistance.',
  ),
  KoleksiData(
    id: '05-PAK-RADEN',
    nama: 'Pak Raden',
    fileName: 'pak_raden.glb',
    imagePath: 'assets/images/koleksi_5.png',
    deskripsi:
        'Tokoh orang tua yang bijaksana, berwibawa, dan sering memberikan nasihat kepada anak-anak. Ia menjadi salah satu figur panutan dalam cerita.',
    deskripsiEn:
        'An elder figure who is wise, respected, and often gives advice to children. He serves as a role model within the story.',
  ),
  KoleksiData(
    id: '06-MBOK-BARIAH',
    nama: 'Mbok Bariah',
    fileName: 'mbok_bariah.glb',
    imagePath: 'assets/images/koleksi_6.png',
    deskripsi:
        'Ibu yang ramah, penyayang, dan peduli terhadap lingkungan sekitar. Ia sering berinteraksi dengan warga kampung dalam berbagai kegiatan.',
    deskripsiEn:
        'A friendly and caring mother figure who is concerned about her community. She often interacts with the villagers in various activities.',
  ),
  KoleksiData(
    id: '07-MEILANI',
    nama: 'Meilani',
    fileName: 'meilani.glb',
    imagePath: 'assets/images/koleksi_7.png',
    deskripsi:
        'Anak perempuan yang menjadi teman Unyil dan kawan-kawannya. Meilani dikenal sopan, ceria, dan aktif dalam berbagai kegiatan bersama teman-temannya.',
    deskripsiEn:
        'A young girl who is friends with Unyil and his companions. Meilani is known for being polite, cheerful, and actively involved in group activities.',
  ),
  KoleksiData(
    id: '08-CUPLIS',
    nama: 'Cuplis',
    fileName: 'cuplis.glb',
    imagePath: 'assets/images/koleksi_8.png',
    deskripsi:
        'Anak laki-laki yang usil dan sering membuat kehebohan. Meski demikian, ia tetap menjadi bagian dari kelompok pertemanan di kampung.',
    deskripsiEn:
        'A mischievous boy who often causes trouble and excitement. Despite this, he remains an important member of the group of friends.',
  ),
  KoleksiData(
    id: '09-PAK-ABLEH',
    nama: 'Pak Ableh',
    fileName: 'pak_ableh.glb',
    imagePath: 'assets/images/koleksi_9.png',
    deskripsi:
        'Warga kampung yang sering muncul dalam berbagai cerita. Ia digambarkan sebagai sosok dewasa yang berinteraksi dengan masyarakat dan turut meramaikan kehidupan kampung dalam serial tersebut.',
    deskripsiEn:
        'A village resident who frequently appears throughout the stories. He is portrayed as an adult community member who interacts with other villagers and contributes to the lively atmosphere of the village.',
  ),
  KoleksiData(
    id: '10-SEMAR',
    nama: 'Semar',
    fileName: 'semar.glb',
    imagePath: 'assets/images/koleksi_10.png',
    deskripsi:
        'Semar adalah pemimpin para Punakawan dan tokoh yang paling bijaksana. Meskipun berpenampilan sederhana, ia memiliki pengetahuan yang luas, sifat rendah hati, serta sering memberikan nasihat dan petunjuk kepada para ksatria.',
    deskripsiEn:
        'Semar is the leader of the Punakawan and the wisest among them. Despite his humble appearance, he possesses profound knowledge, great humility, and often provides guidance and advice to noble warriors.',
  ),
  KoleksiData(
    id: '11-CEPOT',
    nama: 'Cepot',
    fileName: 'cepot.glb',
    imagePath: 'assets/images/koleksi_11.png',
    deskripsi:
        'Cepot, yang juga dikenal sebagai Astrajingga, adalah putra sulung Semar. Ia terkenal karena sifatnya yang jenaka, cerdas, berani, dan suka berbicara terus terang. Kelucuannya sering menjadi hiburan sekaligus sarana penyampaian kritik sosial.',
    deskripsiEn:
        'Cepot, also known as Astrajingga, is Semar\'s eldest son. He is famous for his humor, intelligence, courage, and straightforward manner of speaking. His comic behavior often serves as both entertainment and a means of delivering social criticism.',
  ),
  KoleksiData(
    id: '12-DAWALA',
    nama: 'Dawala',
    fileName: 'dawala.glb',
    imagePath: 'assets/images/koleksi_12.png',
    deskripsi:
        'Dawala adalah putra Semar yang dikenal berwatak baik, setia, dan sopan. Ia sering menjadi penengah dalam percakapan antara Semar dan Cepot serta membantu menciptakan suasana yang harmonis.',
    deskripsiEn:
        'Dawala is one of Semar\’s sons, known for his kind, loyal, and polite nature. He often acts as a mediator between Semar and Cepot, helping to maintain harmony within their conversations and interactions.',
  ),
  KoleksiData(
    id: '13-GARENG',
    nama: 'Gareng',
    fileName: 'gareng.glb',
    imagePath: 'assets/images/koleksi_13.png',
    deskripsi:
        'Gareng merupakan salah satu anggota Punakawan yang dikenal sederhana, jujur, dan berhati baik. Dengan gaya bicara dan tingkah lakunya yang khas, Gareng sering menyampaikan pesan moral serta memberikan sudut pandang yang bijak dalam berbagai peristiwa.',
    deskripsiEn:
        'Gareng is a member of the Punakawan who is known for his simplicity, honesty, and good-hearted character. Through his distinctive speech and behavior, he frequently conveys moral lessons and offers wise perspectives on various situations.',
  ),
  KoleksiData(
    id: '14-AMIR-HAMZAH',
    nama: 'Amir Hamzah',
    fileName: 'amir_hamzah.glb',
    imagePath: 'assets/images/koleksi_14.png',
    deskripsi:
        'Amir Hamzah adalah tokoh utama dalam siklus cerita Menak yang diadaptasi dari kisah kepahlawanan Islam. Ia digambarkan sebagai ksatria yang gagah berani, saleh, setia kepada agamanya, dan selalu membela kebenaran serta keadilan.',
    deskripsiEn:
        'Amir Hamzah is the central hero of the Menak cycle, which is adapted from Islamic heroic tales. He is portrayed as a brave and noble warrior who is devout, loyal to his faith, and dedicated to defending truth and justice. ',
  ),
  KoleksiData(
    id: '15-PANJI-ASMARABANGUN',
    nama: 'Panji Asmarabangun',
    fileName: 'panji_asmarabangun.glb',
    imagePath: 'assets/images/koleksi_15.png',
    deskripsi:
        'Panji Asmarabangun adalah pangeran dari Kerajaan Jenggala yang menjadi tokoh utama dalam cerita Panji. Ia dikenal tampan, berbudi luhur, bijaksana, dan setia kepada kekasihnya, Dewi Sekartaji, dalam berbagai petualangan yang penuh tantangan.',
    deskripsiEn:
        'Panji Asmarabangun is a prince of the Kingdom of Jenggala and the main protagonist of the Panji stories. He is known for his handsome appearance, noble character, wisdom, and unwavering devotion to his beloved, Princess Sekartaji, throughout their many adventures and challenges.',
  ),
  KoleksiData(
    id: '16-PRABU-CAKRABUANA',
    nama: 'Prabu Cakrabuana',
    fileName: 'prabu_cakrabuana.glb',
    imagePath: 'assets/images/koleksi_16.png',
    deskripsi:
        'Prabu Cakrabuana, yang juga dikenal sebagai Pangeran Walangsungsang, merupakan tokoh penting dalam sejarah dan babad Cirebon. Ia dikenal sebagai pendiri serta pemimpin awal Cirebon yang berperan besar dalam penyebaran Islam dan pembangunan pemerintahan di wilayah tersebut.',
    deskripsiEn:
        'Prabu Cakrabuana, also known as Pangeran Walangsungsang, is an important figure in the history and chronicles of Cirebon. He is recognized as the founder and early ruler of Cirebon, playing a significant role in the spread of Islam and the establishment of governance in the region.',
  ),
  KoleksiData(
    id: '17-SIE-DJIN-KOEI-TJENG-TANG',
    nama: 'Sie Djin Koei Tjeng Tang',
    fileName: 'sie_djin_koei_tjeng_tang.glb',
    imagePath: 'assets/images/koleksi_17.png',
    deskripsi:
        'Sie Djin Koei adalah tokoh utama dalam kisah kepahlawanan Dinasti Tang. Ia digambarkan sebagai seorang panglima muda yang gagah berani, setia kepada negara, dan memiliki kemampuan perang yang luar biasa. Berkat kecerdasan, keteguhan hati, serta kesetiaannya kepada kaisar, Sie Djin Koei berhasil menaklukkan berbagai musuh dan menjadi salah satu pahlawan legendaris yang paling populer dalam cerita Wayang Potehi.',
    deskripsiEn:
        'Sie Djin Koei is the central hero in the legendary stories of the Tang Dynasty. He is portrayed as a brave and talented young general, renowned for his loyalty to the kingdom and exceptional military skills. Through his intelligence, perseverance, and unwavering devotion to the emperor, Sie Djin Koei successfully defeats numerous enemies and becomes one of the most celebrated heroic figures in Potehi puppet theater.',
  ),
  KoleksiData(
    id: '18-PANGLIMA-SO-POO-TONG',
    nama: 'Panglima So Poo Tong',
    fileName: 'panglima_so_poo_tong.glb',
    imagePath: 'assets/images/koleksi_18.png',
    deskripsi:
        'Panglima So Poo Tong merupakan salah satu jenderal terkemuka yang dikenal memiliki kemampuan strategi dan kepemimpinan yang baik. Dalam berbagai lakon Potehi, ia digambarkan sebagai panglima yang setia kepada kerajaan, berani menghadapi musuh, serta selalu mengutamakan kehormatan dan tugas negara. Sosoknya sering tampil sebagai pendukung utama dalam perjuangan mempertahankan keamanan dan kejayaan kerajaan Dinasti Tang.',
    deskripsiEn:
        'General So Poo Tong is a distinguished military commander known for his strategic brilliance and strong leadership. In various Potehi performances, he is depicted as a loyal servant of the kingdom who courageously faces enemies and consistently upholds honor and duty. He often appears as a key supporter in the struggle to protect the security and prosperity of the Tang Dynasty.',
  ),
  KoleksiData(
    id: '19-WAYANG-GOLEK-LENONG-BETAWI',
    nama: 'Wayang Golek Lenong Betawi',
    fileName: 'wayang_golek_lenong_betawi.glb',
    imagePath: 'assets/images/koleksi_19.png',
    deskripsi:
        'Wayang Golek Lenong Betawi adalah bentuk wayang golek kontemporer yang memadukan seni wayang, lenong, dan musik gambang kromong khas Betawi. Diciptakan oleh dalang Tizar Purbaya sebagai upaya menghadirkan wayang berciri Betawi, tokoh-tokohnya menampilkan karakter masyarakat Betawi yang jenaka, lugas, dan dekat dengan kehidupan sehari-hari. Cerita yang dibawakan umumnya diambil dari legenda, sejarah, maupun kisah modern Betawi.',
    deskripsiEn:
        'The Betawi Lenong Rod Puppet is a contemporary form of rod puppet theater that combines traditional puppetry, Lenong folk theater, and Gambang Kromong music, all of which are distinctive elements of Betawi culture. Created by puppeteer Tizar Purbaya, it was developed to introduce a uniquely Betawi style of puppetry. Its characters portray the humor, straightforwardness, and everyday life of Betawi society. The stories performed are often based on local legends, historical events, and contemporary Betawi narratives.',
  ),
  KoleksiData(
    id: '20-WAYANG-GOLEK-SESEK',
    nama: 'Wayang Golek Sesek',
    fileName: 'wayang_golek_sesek.glb',
    imagePath: 'assets/images/koleksi_20.png',
    deskripsi:
        'Wayang Golek Sesek merupakan kreasi wayang golek yang berasal dari Bogor, Jawa Barat. Keunikannya terletak pada penciptaan karakter yang terinspirasi dari berbagai jenis bambu yang tumbuh di Indonesia. Setiap tokoh memiliki bentuk, sifat, dan nama yang berbeda, tidak mengacu pada tokoh pewayangan klasik seperti Mahabharata atau Ramayana. Wayang ini menjadi simbol kreativitas seni kontemporer yang mengangkat kekayaan alam dan budaya Nusantara ke dalam bentuk pertunjukan wayang.',
    deskripsiEn:
        'The Sesek Rod Puppet is a contemporary rod puppet creation originating from Bogor, West Java. Its uniqueness lies in its characters, which are inspired by various species of bamboo found throughout Indonesia. Each puppet has its own distinctive appearance, personality, and name, rather than being based on classical wayang figures from the Mahabharata or Ramayana epics. This puppet tradition represents a creative innovation in modern Indonesian puppetry, highlighting the richness of the nation\'s natural and cultural heritage through performance art.',
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
