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
          'Si Unyil adalah karakter utama ciptaan Drs. Suyadi (Pak Raden) yang tayang sejak 1981. Ia merepresentasikan anak sekolah dasar di Indonesia yang lugu, ceria, selalu ingin tahu, dan mengajarkan nilai-nilai moral dalam kehidupan sehari-hari.',
      'deskripsiEn':
          'Si Unyil is the main character created by Drs. Suyadi (Pak Raden), airing since 1981. He represents an innocent, cheerful, and curious Indonesian elementary school child, teaching moral values in daily life.',
    },
    '02-UCRIT': {
      'modelUrl': SupabaseConfig.getModelUrl('ucrit.glb'),
      'fileName': 'ucrit.glb',
      'modelName': 'Ucrit',
      'deskripsi':
          'Ucrit adalah salah satu sahabat karib Unyil yang beragama Katolik dan sering terlihat memakai kalung salib. Karakter ini sengaja diciptakan untuk merepresentasikan keberagaman sosial dan mengajarkan toleransi beragama sejak dini kepada anak-anak Indonesia.',
      'deskripsiEn':
          'Ucrit is one of Unyil\'s best friends who is Catholic and often seen wearing a cross necklace. This character was specifically created to represent social diversity and teach religious tolerance from an early age to Indonesian children.',
    },
    '03-USRO': {
      'modelUrl': SupabaseConfig.getModelUrl('usro.glb'),
      'fileName': 'usro.glb',
      'modelName': 'Usro',
      'deskripsi':
          'Usro adalah teman sepermainan Unyil yang sangat khas dengan peci miringnya. Ia dikenal memiliki sifat yang sangat setia kawan dan sering kali menjadi penengah atau teman setia dalam berbagai petualangan di desa.',
      'deskripsiEn':
          'Usro is Unyil\'s playmate, known for his distinctive tilted cap (peci). He is recognized for his deep loyalty to his friends and often acts as a mediator or a faithful companion in their village adventures.',
    },
    '04-PAK-OGAH': {
      'modelUrl': SupabaseConfig.getModelUrl('pak_ogah.glb'),
      'fileName': 'pak_ogah.glb',
      'modelName': 'Pak Ogah',
      'deskripsi':
          'Karakter tunakarya ikonik berkepala plontos yang terkenal dengan jargon \'Cepek dulu dong\'. Pak Ogah secara spesifik diciptakan sebagai representasi sosial tentang pengangguran pemalas yang selalu mencari jalan pintas untuk mendapatkan uang.',
      'deskripsiEn':
          'An iconic bald, unemployed character famous for his catchphrase \'Cepek dulu dong\' (Give me 100 rupiahs first). Pak Ogah was specifically created as a social representation of a lazy unemployed person always looking for shortcuts to get money.',
    },
    '05-PAK-RADEN': {
      'modelUrl': SupabaseConfig.getModelUrl('pak_raden.glb'),
      'fileName': 'pak_raden.glb',
      'modelName': 'Pak Raden',
      'deskripsi':
          'Pak Raden adalah karakter keturunan bangsawan Jawa berpakaian beskap yang kaku, pelit, serta mudah marah. Karakter ini disuarakan dan diciptakan langsung oleh mendiang Drs. Suyadi sebagai karikatur golongan priyayi tua yang konservatif.',
      'deskripsiEn':
          'Pak Raden is a Javanese noble descendant character dressed in a traditional beskap, known for being stiff, stingy, and short-tempered. This character was voiced and created directly by the late Drs. Suyadi as a caricature of conservative elder nobles.',
    },
    '06-MBOK-BARIAH': {
      'modelUrl': SupabaseConfig.getModelUrl('mbok_bariah.glb'),
      'fileName': 'mbok_bariah.glb',
      'modelName': 'Mbok Bariah',
      'deskripsi':
          'Mbok Bariah adalah tokoh penjual rujak asal Madura dengan logat bicara kental yang sangat khas. Karakter ini melambangkan kegigihan, semangat pantang menyerah, dan kerja keras yang menjadi identitas para pedagang perantauan.',
      'deskripsiEn':
          'Mbok Bariah is a rujak seller from Madura with a very distinctive thick accent. This character symbolizes persistence, an unyielding spirit, and the hard work that forms the identity of migrating traders.',
    },
    '07-MEILANI': {
      'modelUrl': SupabaseConfig.getModelUrl('meilani.glb'),
      'fileName': 'meilani.glb',
      'modelName': 'Meilani',
      'deskripsi':
          'Meilani adalah karakter anak perempuan keturunan Tionghoa berwajah manis yang memiliki sifat ramah dan pintar. Sosok ini didesain sebagai representasi asimilasi budaya, kebaikan hati, serta harmoni kehidupan antar etnis di Indonesia.',
      'deskripsiEn':
          'Meilani is a sweet-faced girl of Chinese descent who is friendly and smart. This figure is designed as a representation of cultural assimilation, kindness, and inter-ethnic harmony in Indonesia.',
    },
    '08-CUPLIS': {
      'modelUrl': SupabaseConfig.getModelUrl('cuplis.glb'),
      'fileName': 'cuplis.glb',
      'modelName': 'Cuplis',
      'deskripsi':
          'Cuplis adalah teman bermain Unyil yang sangat identik dengan kepala botaknya. Ia sering digambarkan sebagai anak yang periang, terkadang sedikit usil, namun kehadirannya selalu melengkapi dinamika persahabatan anak-anak di desa tersebut.',
      'deskripsiEn':
          'Cuplis is Unyil\'s playmate, highly recognized by his bald head. He is often depicted as a cheerful and sometimes slightly mischievous child, but his presence always completes the dynamic of children\'s friendships in the village.',
    },
    '09-PAK-ABLEH': {
      'modelUrl': SupabaseConfig.getModelUrl('pak_ableh.glb'),
      'fileName': 'pak_ableh.glb',
      'modelName': 'Pak Ableh',
      'deskripsi':
          'Pak Ableh adalah teman akrab sekaligus pengikut setia Pak Ogah yang juga tidak memiliki pekerjaan tetap. Ia digambarkan memiliki karakter yang terkesan lamban dan kurang cerdas, sering menemani Pak Ogah nongkrong di pos ronda.',
      'deskripsiEn':
          'Pak Ableh is a close friend and loyal follower of Pak Ogah, who also does not have a steady job. He is portrayed as having a rather slow and less intelligent character, often accompanying Pak Ogah at the neighborhood guard post.',
    },
    '10-SEMAR': {
      'modelUrl': SupabaseConfig.getModelUrl('semar.glb'),
      'fileName': 'semar.glb',
      'modelName': 'Semar',
      'deskripsi':
          'Semar adalah tokoh utama dalam kelompok Punakawan pewayangan Jawa dan Sunda yang diyakini sebagai penjelmaan dewa (Batara Ismaya). Ia melambangkan kearifan, kebijaksanaan murni, dan merupakan figur pamong spiritual bagi para ksatria.',
      'deskripsiEn':
          'Semar is the main figure in the Punakawan group of Javanese and Sundanese puppetry, believed to be the incarnation of a god (Batara Ismaya). He symbolizes wisdom, pure sagacity, and acts as a spiritual guardian figure for the knights.',
    },
    '11-CEPOT': {
      'modelUrl': SupabaseConfig.getModelUrl('cepot.glb'),
      'fileName': 'cepot.glb',
      'modelName': 'Cepot',
      'deskripsi':
          'Astrajingga atau lebih dikenal dengan nama Cepot adalah tokoh wayang golek Sunda berwajah merah. Ia sangat dikenal karena sifatnya yang humoris, jenaka, dan sering menjadi media dalang untuk menyampaikan kritik sosial secara ringan.',
      'deskripsiEn':
          'Astrajingga, better known as Cepot, is a red-faced Sundanese wooden puppet character. He is widely known for his humorous and witty nature, often serving as the puppeteer\'s medium to deliver social criticism lightly.',
    },
    '12-DAWALA': {
      'modelUrl': SupabaseConfig.getModelUrl('dawala.glb'),
      'fileName': 'dawala.glb',
      'modelName': 'Dawala',
      'deskripsi':
          'Dawala adalah adik dari Cepot dalam jagat wayang golek Sunda yang memiliki ciri fisik berupa hidung mancung ke bawah. Ia memiliki sifat yang lebih tenang, sabar, dan selalu setia mendampingi saudaranya dalam berbagai situasi.',
      'deskripsiEn':
          'Dawala is Cepot\'s younger brother in the Sundanese puppet universe, physically characterized by a downward-pointing nose. He has a calmer and more patient nature, always loyally accompanying his brother in various situations.',
    },
    '13-GARENG': {
      'modelUrl': SupabaseConfig.getModelUrl('gareng.glb'),
      'fileName': 'gareng.glb',
      'modelName': 'Gareng',
      'deskripsi':
          'Gareng adalah tokoh Punakawan dengan ciri khas fisik tidak sempurna seperti mata juling dan kaki pincang. Ketidaksempurnaan ini secara filosofis merupakan simbolisasi dari sifat kehati-hatian dalam bertindak, melihat, dan melangkah di kehidupan.',
      'deskripsiEn':
          'Gareng is a Punakawan character with distinctive physical imperfections such as crossed eyes and a limp. Philosophically, these imperfections symbolize caution in taking action, seeing, and stepping through life.',
    },
    '14-AMIR-HAMZAH': {
      'modelUrl': SupabaseConfig.getModelUrl('amir_hamzah.glb'),
      'fileName': 'amir_hamzah.glb',
      'modelName': 'Amir Hamzah',
      'deskripsi':
          'Amir Hamzah adalah tokoh sentral dalam pertunjukan Wayang Golek Menak yang diadaptasi dari literatur epik bernapaskan Islam. Sosoknya melambangkan keberanian tempur, ketangguhan, dan keteguhan pahlawan dalam menyebarkan nilai kebaikan.',
      'deskripsiEn':
          'Amir Hamzah is the central figure in the Wayang Golek Menak performance, adapted from Islamic epic literature. His figure symbolizes combat bravery, resilience, and the hero\'s steadfastness in spreading the values of goodness.',
    },
    '15-PANJI-ASMARABANGUN': {
      'modelUrl': SupabaseConfig.getModelUrl('panji_asmarabangun.glb'),
      'fileName': 'panji_asmarabangun.glb',
      'modelName': 'Panji Asmarabangun',
      'deskripsi':
          'Panji Asmarabangun adalah tokoh utama dalam siklus Cerita Panji kuno nusantara sebagai pewaris takhta Kerajaan Jenggala. Ia merepresentasikan sosok ksatria luhur ideal yang sangat halus budi pekertinya, berwibawa, berani, dan romantis.',
      'deskripsiEn':
          'Panji Asmarabangun is the main character in the ancient archipelago\'s Panji cycle tales as the heir to the Jenggala Kingdom throne. He represents the ideal noble knight who is extremely refined in character, authoritative, brave, and romantic.',
    },
    '16-PRABU-CAKRABUANA': {
      'modelUrl': SupabaseConfig.getModelUrl('prabu_cakrabuana.glb'),
      'fileName': 'prabu_cakrabuana.glb',
      'modelName': 'Prabu Cakrabuana',
      'deskripsi':
          'Astrajingga atau lebih dikenal dengan nama Cepot adalah tokoh wayang golek Sunda berwajah merah. Ia sangat dikenal karena sifatnya yang humoris, jenaka, dan sering menjadi media dalang untuk menyampaikan kritik sosial secara ringan.',
      'deskripsiEn':
          'Astrajingga, better known as Cepot, is a red-faced Sundanese wooden puppet character. He is widely known for his humorous and witty nature, often serving as the puppeteer\'s medium to deliver social criticism lightly.',
    },
    '17-SIE-DJIN-KOEI-TJENG-TANG': {
      'modelUrl': SupabaseConfig.getModelUrl('sie_djin_koei_tjeng_tang.glb'),
      'fileName': 'sie_djin_koei_tjeng_tang.glb',
      'modelName': 'Sie Djin Koei Tjeng Tang',
      'deskripsi':
          'Dawala adalah adik dari Cepot dalam jagat wayang golek Sunda yang memiliki ciri fisik berupa hidung mancung ke bawah. Ia memiliki sifat yang lebih tenang, sabar, dan selalu setia mendampingi saudaranya dalam berbagai situasi.',
      'deskripsiEn':
          'Dawala is Cepot\'s younger brother in the Sundanese puppet universe, physically characterized by a downward-pointing nose. He has a calmer and more patient nature, always loyally accompanying his brother in various situations.',
    },
    '18-PANGLIMA-SO-POO-TONG': {
      'modelUrl': SupabaseConfig.getModelUrl('panglima_so_poo_tong.glb'),
      'fileName': 'panglima_so_poo_tong.glb',
      'modelName': 'Panglima So Poo Tong',
      'deskripsi':
          'Gareng adalah tokoh Punakawan dengan ciri khas fisik tidak sempurna seperti mata juling dan kaki pincang. Ketidaksempurnaan ini secara filosofis merupakan simbolisasi dari sifat kehati-hatian dalam bertindak, melihat, dan melangkah di kehidupan.',
      'deskripsiEn':
          'Gareng is a Punakawan character with distinctive physical imperfections such as crossed eyes and a limp. Philosophically, these imperfections symbolize caution in taking action, seeing, and stepping through life.',
    },
    '19-WAYANG-GOLEK-LENONG-BETAWI': {
      'modelUrl': SupabaseConfig.getModelUrl('wayang_golek_lenong_betawi.glb'),
      'fileName': 'wayang_golek_lenong_betawi.glb',
      'modelName': 'Wayang Golek Lenong Betawi',
      'deskripsi':
          'Amir Hamzah adalah tokoh sentral dalam pertunjukan Wayang Golek Menak yang diadaptasi dari literatur epik bernapaskan Islam. Sosoknya melambangkan keberanian tempur, ketangguhan, dan keteguhan pahlawan dalam menyebarkan nilai kebaikan.',
      'deskripsiEn':
          'Amir Hamzah is the central figure in the Wayang Golek Menak performance, adapted from Islamic epic literature. His figure symbolizes combat bravery, resilience, and the hero\'s steadfastness in spreading the values of goodness.',
    },
    '20-WAYANG-GOLEK-SESEK': {
      'modelUrl': SupabaseConfig.getModelUrl('wayang_golek_sesek.glb'),
      'fileName': 'wayang_golek_sesek.glb',
      'modelName': 'Wayang Golek Sesek',
      'deskripsi':
          'Panji Asmarabangun adalah tokoh utama dalam siklus Cerita Panji kuno nusantara sebagai pewaris takhta Kerajaan Jenggala. Ia merepresentasikan sosok ksatria luhur ideal yang sangat halus budi pekertinya, berwibawa, berani, dan romantis.',
      'deskripsiEn':
          'Panji Asmarabangun is the main character in the ancient archipelago\'s Panji cycle tales as the heir to the Jenggala Kingdom throne. He represents the ideal noble knight who is extremely refined in character, authoritative, brave, and romantic.',
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
