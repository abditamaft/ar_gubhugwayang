import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'ar_view_screen.dart';
import '../config/supabase_config.dart';
import '../provider/language_provider.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

// ← LanguageAware agar appbar & hint ikut bahasa
class _QRScannerScreenState extends State<QRScannerScreen> with LanguageAware {
  bool _isNavigating = false;

  static final Map<String, Map<String, String>> _koleksiMap = {
    '01-SI-UNYIL': {
      'modelUrl': SupabaseConfig.getModelUrl('si_unyil.glb'),
      'fileName': 'si_unyil.glb',
      'modelName': 'Si Unyil',
      'deskripsi':
          'Anak laki-laki yang menjadi tokoh utama. Unyil dikenal cerdas, baik hati, rajin, suka menolong, dan sering menjadi teladan bagi teman-temannya.',
      'deskripsiEn':
          'A young boy who serves as the main character of the series. Unyil is known for being intelligent, kind-hearted, diligent, helpful, and often acts as a role model for his friends.',
    },
    '02-UCRIT': {
      'modelUrl': SupabaseConfig.getModelUrl('ucrit.glb'),
      'fileName': 'ucrit.glb',
      'modelName': 'Ucrit',
      'deskripsi':
          'Sahabat Unyil yang bertubuh kecil dan kurus. Ucrit dikenal polos, lugu, serta sering menimbulkan kelucuan dalam berbagai situasi.',
      'deskripsiEn':
          'Unyil\'s friend, who is small and thin. Ucrit is known for being innocent, naïve, and often brings humor to various situations.',
    },
    '03-USRO': {
      'modelUrl': SupabaseConfig.getModelUrl('usro.glb'),
      'fileName': 'usro.glb',
      'modelName': 'Usro',
      'deskripsi':
          'Teman Unyil yang memiliki sifat baik dan suka bekerja sama. Usro sering ikut dalam berbagai kegiatan dan petualangan bersama teman-temannya.',
      'deskripsiEn':
          'One of Unyil\’s friends who is kind and cooperative. Usro frequently takes part in various activities and adventures with his friends.',
    },
    '04-PAK-OGAH': {
      'modelUrl': SupabaseConfig.getModelUrl('pak_ogah.glb'),
      'fileName': 'pak_ogah.glb',
      'modelName': 'Pak Ogah',
      'deskripsi':
          'Tokoh yang terkenal karena sifatnya yang malas dan sering meminta imbalan sebelum membantu orang lain. Kalimat khasnya adalah meminta “cepek dulu”',
      'deskripsiEn':
          'A character famous for his laziness and his habit of asking for payment before helping others. His trademark phrase involves requesting money first before offering assistance.',
    },
    '05-PAK-RADEN': {
      'modelUrl': SupabaseConfig.getModelUrl('pak_raden.glb'),
      'fileName': 'pak_raden.glb',
      'modelName': 'Pak Raden',
      'deskripsi':
          'Tokoh orang tua yang bijaksana, berwibawa, dan sering memberikan nasihat kepada anak-anak. Ia menjadi salah satu figur panutan dalam cerita.',
      'deskripsiEn':
          'An elder figure who is wise, respected, and often gives advice to children. He serves as a role model within the story.',
    },
    '06-MBOK-BARIAH': {
      'modelUrl': SupabaseConfig.getModelUrl('mbok_bariah.glb'),
      'fileName': 'mbok_bariah.glb',
      'modelName': 'Mbok Bariah',
      'deskripsi':
          'Ibu yang ramah, penyayang, dan peduli terhadap lingkungan sekitar. Ia sering berinteraksi dengan warga kampung dalam berbagai kegiatan.',
      'deskripsiEn':
          'A friendly and caring mother figure who is concerned about her community. She often interacts with the villagers in various activities.',
    },
    '07-MEILANI': {
      'modelUrl': SupabaseConfig.getModelUrl('meilani.glb'),
      'fileName': 'meilani.glb',
      'modelName': 'Meilani',
      'deskripsi':
          'Anak perempuan yang menjadi teman Unyil dan kawan-kawannya. Meilani dikenal sopan, ceria, dan aktif dalam berbagai kegiatan bersama teman-temannya.',
      'deskripsiEn':
          'A young girl who is friends with Unyil and his companions. Meilani is known for being polite, cheerful, and actively involved in group activities.',
    },
    '08-CUPLIS': {
      'modelUrl': SupabaseConfig.getModelUrl('cuplis.glb'),
      'fileName': 'cuplis.glb',
      'modelName': 'Cuplis',
      'deskripsi':
          'Anak laki-laki yang usil dan sering membuat kehebohan. Meski demikian, ia tetap menjadi bagian dari kelompok pertemanan di kampung.',
      'deskripsiEn':
          'A mischievous boy who often causes trouble and excitement. Despite this, he remains an important member of the group of friends.',
    },
    '09-PAK-ABLEH': {
      'modelUrl': SupabaseConfig.getModelUrl('pak_ableh.glb'),
      'fileName': 'pak_ableh.glb',
      'modelName': 'Pak Ableh',
      'deskripsi':
          'Warga kampung yang sering muncul dalam berbagai cerita. Ia digambarkan sebagai sosok dewasa yang berinteraksi dengan masyarakat dan turut meramaikan kehidupan kampung dalam serial tersebut.',
      'deskripsiEn':
          'A village resident who frequently appears throughout the stories. He is portrayed as an adult community member who interacts with other villagers and contributes to the lively atmosphere of the village.',
    },
    '10-SEMAR': {
      'modelUrl': SupabaseConfig.getModelUrl('semar.glb'),
      'fileName': 'semar.glb',
      'modelName': 'Semar',
      'deskripsi':
          'Semar adalah pemimpin para Punakawan dan tokoh yang paling bijaksana. Meskipun berpenampilan sederhana, ia memiliki pengetahuan yang luas, sifat rendah hati, serta sering memberikan nasihat dan petunjuk kepada para ksatria.',
      'deskripsiEn':
          'Semar is the leader of the Punakawan and the wisest among them. Despite his humble appearance, he possesses profound knowledge, great humility, and often provides guidance and advice to noble warriors.',
    },
    '11-CEPOT': {
      'modelUrl': SupabaseConfig.getModelUrl('cepot.glb'),
      'fileName': 'cepot.glb',
      'modelName': 'Cepot',
      'deskripsi':
          'Cepot, yang juga dikenal sebagai Astrajingga, adalah putra sulung Semar. Ia terkenal karena sifatnya yang jenaka, cerdas, berani, dan suka berbicara terus terang. Kelucuannya sering menjadi hiburan sekaligus sarana penyampaian kritik sosial.',
      'deskripsiEn':
          'Cepot, also known as Astrajingga, is Semar\'s eldest son. He is famous for his humor, intelligence, courage, and straightforward manner of speaking. His comic behavior often serves as both entertainment and a means of delivering social criticism.',
    },
    '12-DAWALA': {
      'modelUrl': SupabaseConfig.getModelUrl('dawala.glb'),
      'fileName': 'dawala.glb',
      'modelName': 'Dawala',
      'deskripsi':
          'Dawala adalah putra Semar yang dikenal berwatak baik, setia, dan sopan. Ia sering menjadi penengah dalam percakapan antara Semar dan Cepot serta membantu menciptakan suasana yang harmonis.',
      'deskripsiEn':
          'Dawala is one of Semar\’s sons, known for his kind, loyal, and polite nature. He often acts as a mediator between Semar and Cepot, helping to maintain harmony within their conversations and interactions.',
    },
    '13-GARENG': {
      'modelUrl': SupabaseConfig.getModelUrl('gareng.glb'),
      'fileName': 'gareng.glb',
      'modelName': 'Gareng',
      'deskripsi':
          'Gareng merupakan salah satu anggota Punakawan yang dikenal sederhana, jujur, dan berhati baik. Dengan gaya bicara dan tingkah lakunya yang khas, Gareng sering menyampaikan pesan moral serta memberikan sudut pandang yang bijak dalam berbagai peristiwa.',
      'deskripsiEn':
          'Gareng is a member of the Punakawan who is known for his simplicity, honesty, and good-hearted character. Through his distinctive speech and behavior, he frequently conveys moral lessons and offers wise perspectives on various situations.',
    },
    '14-AMIR-HAMZAH': {
      'modelUrl': SupabaseConfig.getModelUrl('amir_hamzah.glb'),
      'fileName': 'amir_hamzah.glb',
      'modelName': 'Amir Hamzah',
      'deskripsi':
          'Amir Hamzah adalah tokoh utama dalam siklus cerita Menak yang diadaptasi dari kisah kepahlawanan Islam. Ia digambarkan sebagai ksatria yang gagah berani, saleh, setia kepada agamanya, dan selalu membela kebenaran serta keadilan.',
      'deskripsiEn':
          'Amir Hamzah is the central hero of the Menak cycle, which is adapted from Islamic heroic tales. He is portrayed as a brave and noble warrior who is devout, loyal to his faith, and dedicated to defending truth and justice. ',
    },
    '15-PANJI-ASMARABANGUN': {
      'modelUrl': SupabaseConfig.getModelUrl('panji_asmarabangun.glb'),
      'fileName': 'panji_asmarabangun.glb',
      'modelName': 'Panji Asmarabangun',
      'deskripsi':
          'Panji Asmarabangun adalah pangeran dari Kerajaan Jenggala yang menjadi tokoh utama dalam cerita Panji. Ia dikenal tampan, berbudi luhur, bijaksana, dan setia kepada kekasihnya, Dewi Sekartaji, dalam berbagai petualangan yang penuh tantangan.',
      'deskripsiEn':
          'Panji Asmarabangun is a prince of the Kingdom of Jenggala and the main protagonist of the Panji stories. He is known for his handsome appearance, noble character, wisdom, and unwavering devotion to his beloved, Princess Sekartaji, throughout their many adventures and challenges.',
    },
    '16-PRABU-CAKRABUANA': {
      'modelUrl': SupabaseConfig.getModelUrl('prabu_cakrabuana.glb'),
      'fileName': 'prabu_cakrabuana.glb',
      'modelName': 'Prabu Cakrabuana',
      'deskripsi':
          'Prabu Cakrabuana, yang juga dikenal sebagai Pangeran Walangsungsang, merupakan tokoh penting dalam sejarah dan babad Cirebon. Ia dikenal sebagai pendiri serta pemimpin awal Cirebon yang berperan besar dalam penyebaran Islam dan pembangunan pemerintahan di wilayah tersebut.',
      'deskripsiEn':
          'Prabu Cakrabuana, also known as Pangeran Walangsungsang, is an important figure in the history and chronicles of Cirebon. He is recognized as the founder and early ruler of Cirebon, playing a significant role in the spread of Islam and the establishment of governance in the region.',
    },
    '17-SIE-DJIN-KOEI-TJENG-TANG': {
      'modelUrl': SupabaseConfig.getModelUrl('sie_djin_koei_tjeng_tang.glb'),
      'fileName': 'sie_djin_koei_tjeng_tang.glb',
      'modelName': 'Sie Djin Koei Tjeng Tang',
      'deskripsi':
          'Sie Djin Koei adalah tokoh utama dalam kisah kepahlawanan Dinasti Tang. Ia digambarkan sebagai seorang panglima muda yang gagah berani, setia kepada negara, dan memiliki kemampuan perang yang luar biasa. Berkat kecerdasan, keteguhan hati, serta kesetiaannya kepada kaisar, Sie Djin Koei berhasil menaklukkan berbagai musuh dan menjadi salah satu pahlawan legendaris yang paling populer dalam cerita Wayang Potehi.',
      'deskripsiEn':
          'Sie Djin Koei is the central hero in the legendary stories of the Tang Dynasty. He is portrayed as a brave and talented young general, renowned for his loyalty to the kingdom and exceptional military skills. Through his intelligence, perseverance, and unwavering devotion to the emperor, Sie Djin Koei successfully defeats numerous enemies and becomes one of the most celebrated heroic figures in Potehi puppet theater.',
    },
    '18-PANGLIMA-SO-POO-TONG': {
      'modelUrl': SupabaseConfig.getModelUrl('panglima_so_poo_tong.glb'),
      'fileName': 'panglima_so_poo_tong.glb',
      'modelName': 'Panglima So Poo Tong',
      'deskripsi':
          'Panglima So Poo Tong merupakan salah satu jenderal terkemuka yang dikenal memiliki kemampuan strategi dan kepemimpinan yang baik. Dalam berbagai lakon Potehi, ia digambarkan sebagai panglima yang setia kepada kerajaan, berani menghadapi musuh, serta selalu mengutamakan kehormatan dan tugas negara. Sosoknya sering tampil sebagai pendukung utama dalam perjuangan mempertahankan keamanan dan kejayaan kerajaan Dinasti Tang.',
      'deskripsiEn':
          'General So Poo Tong is a distinguished military commander known for his strategic brilliance and strong leadership. In various Potehi performances, he is depicted as a loyal servant of the kingdom who courageously faces enemies and consistently upholds honor and duty. He often appears as a key supporter in the struggle to protect the security and prosperity of the Tang Dynasty.',
    },
    '19-WAYANG-GOLEK-LENONG-BETAWI': {
      'modelUrl': SupabaseConfig.getModelUrl('wayang_golek_lenong_betawi.glb'),
      'fileName': 'wayang_golek_lenong_betawi.glb',
      'modelName': 'Wayang Golek Lenong Betawi',
      'deskripsi':
          'Wayang Golek Lenong Betawi adalah bentuk wayang golek kontemporer yang memadukan seni wayang, lenong, dan musik gambang kromong khas Betawi. Diciptakan oleh dalang Tizar Purbaya sebagai upaya menghadirkan wayang berciri Betawi, tokoh-tokohnya menampilkan karakter masyarakat Betawi yang jenaka, lugas, dan dekat dengan kehidupan sehari-hari. Cerita yang dibawakan umumnya diambil dari legenda, sejarah, maupun kisah modern Betawi.',
      'deskripsiEn':
          'The Betawi Lenong Rod Puppet is a contemporary form of rod puppet theater that combines traditional puppetry, Lenong folk theater, and Gambang Kromong music, all of which are distinctive elements of Betawi culture. Created by puppeteer Tizar Purbaya, it was developed to introduce a uniquely Betawi style of puppetry. Its characters portray the humor, straightforwardness, and everyday life of Betawi society. The stories performed are often based on local legends, historical events, and contemporary Betawi narratives.',
    },
    '20-WAYANG-GOLEK-SESEK': {
      'modelUrl': SupabaseConfig.getModelUrl('wayang_golek_sesek.glb'),
      'fileName': 'wayang_golek_sesek.glb',
      'modelName': 'Wayang Golek Sesek',
      'deskripsi':
          'Wayang Golek Sesek merupakan kreasi wayang golek yang berasal dari Bogor, Jawa Barat. Keunikannya terletak pada penciptaan karakter yang terinspirasi dari berbagai jenis bambu yang tumbuh di Indonesia. Setiap tokoh memiliki bentuk, sifat, dan nama yang berbeda, tidak mengacu pada tokoh pewayangan klasik seperti Mahabharata atau Ramayana. Wayang ini menjadi simbol kreativitas seni kontemporer yang mengangkat kekayaan alam dan budaya Nusantara ke dalam bentuk pertunjukan wayang.',
      'deskripsiEn':
          'The Sesek Rod Puppet is a contemporary rod puppet creation originating from Bogor, West Java. Its uniqueness lies in its characters, which are inspired by various species of bamboo found throughout Indonesia. Each puppet has its own distinctive appearance, personality, and name, rather than being based on classical wayang figures from the Mahabharata or Ramayana epics. This puppet tradition represents a creative innovation in modern Indonesian puppetry, highlighting the richness of the nation\'s natural and cultural heritage through performance art.',
    },
  };

  void _handleScan(String rawValue) {
    if (_isNavigating) return;
    final koleksi = _koleksiMap[rawValue];

    if (koleksi != null) {
      setState(() => _isNavigating = true);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ArViewScreen(
            modelUrl: koleksi['modelUrl']!,
            fileName: koleksi['fileName']!,
            modelName: koleksi['modelName']!,
            deskripsi: koleksi['deskripsi'],
            deskripsiEn: koleksi['deskripsiEn'],
          ),
        ),
      ).then((_) {
        // Reset flag saat user kembali dari ArViewScreen ke scanner
        if (mounted) setState(() => _isNavigating = false);
      });
    } else {
      final sc = AppStrings.scanner;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${lp.s(sc, 'unknown')}: "$rawValue"'),
          backgroundColor: Colors.red[700],
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sc = AppStrings.scanner;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lp.s(sc, 'appbar'),
          style: const TextStyle(fontFamily: 'Inter'),
        ),
        backgroundColor: const Color(0xFF1B233A),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              for (final barcode in capture.barcodes) {
                final String? rawValue = barcode.rawValue;
                if (rawValue != null) {
                  _handleScan(rawValue);
                  break;
                }
              }
            },
          ),

          // Kotak scan overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.7),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // Teks hint bawah
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              lp.s(sc, 'hint'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
