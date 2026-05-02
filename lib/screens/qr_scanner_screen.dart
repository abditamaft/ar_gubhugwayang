import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'ar_view_screen.dart';
import '../config/supabase_config.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _isNavigating = false;

  /// Mapping QR Code → data koleksi (termasuk deskripsi untuk popup info)
  static final Map<String, Map<String, String>> _koleksiMap = {
    '01-wayang-cepot': {
      'modelUrl': SupabaseConfig.getModelUrl('wayang_cepot.glb'),
      'fileName': 'topeng_panji.glb',
      'modelName': 'Topeng Panji',
      'deskripsi':
          'Topeng Panji adalah topeng tradisional Jawa yang melambangkan kelembutan, ketenangan, dan kesempurnaan. Berwarna putih bersih sebagai simbol jiwa yang suci dan mulia dalam kisah Panji Asmarabangun.',
    },
    'KOL-02-KERIS': {
      'modelUrl': SupabaseConfig.getModelUrl('keris_pusaka.glb'),
      'fileName': 'keris_pusaka.glb',
      'modelName': 'Keris Pusaka',
      'deskripsi':
          'Keris adalah senjata tikam golongan belati dengan bentuk bilah yang khas, berliku-liku seperti api. Dianggap memiliki kekuatan magis dan merupakan warisan budaya yang diakui UNESCO sejak 2005.',
    },
    'KOL-03-GONG': {
      'modelUrl': SupabaseConfig.getModelUrl('gong_gamelan.glb'),
      'fileName': 'gong_gamelan.glb',
      'modelName': 'Gong Gamelan',
      'deskripsi':
          'Gong adalah instrumen musik pukul tradisional Jawa yang terbuat dari perunggu. Bunyi "gong" yang bergema menandai akhir sebuah gongan (siklus) dalam musik gamelan Jawa dan Bali.',
    },
    'KOL-04-ARJUNA': {
      'modelUrl': SupabaseConfig.getModelUrl('wayang_arjuna.glb'),
      'fileName': 'wayang_arjuna.glb',
      'modelName': 'Wayang Kulit Arjuna',
      'deskripsi':
          'Arjuna adalah tokoh pewayangan berparas tampan, berhati lembut, dan ahli memanah. Putra ketiga Pandawa ini dikenal sebagai kesatria terbaik dalam epik Mahabharata.',
    },
    'KOL-05-CEPOT': {
      'modelUrl': SupabaseConfig.getModelUrl('wayang_cepot.glb'),
      'fileName': 'wayang_cepot.glb',
      'modelName': 'Wayang Golek Cepot',
      'deskripsi':
          'Cepot atau Astrajingga adalah karakter punakawan khas Sunda yang jenaka dan humoris. Ia adalah anak sulung Semar, dengan wajah merah dan sifat yang polos namun penuh kebijaksanaan tersembunyi.',
    },
    'KOL-06-BATIK': {
      'modelUrl': SupabaseConfig.getModelUrl('batik_megamendung.glb'),
      'fileName': 'batik_megamendung.glb',
      'modelName': 'Batik Megamendung',
      'deskripsi':
          'Megamendung adalah motif batik khas Cirebon berbentuk awan bertingkat yang berasal dari pengaruh budaya Tiongkok. Motif ini melambangkan kesabaran dan ketenangan jiwa.',
    },
    'KOL-07-MAHKOTA': {
      'modelUrl': SupabaseConfig.getModelUrl('mahkota_binokasih.glb'),
      'fileName': 'mahkota_binokasih.glb',
      'modelName': 'Mahkota Binokasih',
      'deskripsi':
          'Mahkota Binokasih adalah mahkota peninggalan Kerajaan Sunda Pajajaran yang dianggap sakral. Mahkota ini dipercaya sebagai simbol legitimasi kekuasaan raja-raja Sunda.',
    },
    'KOL-08-LUDING': {
      'modelUrl': SupabaseConfig.getModelUrl('kuda_lumping.glb'),
      'fileName': 'kuda_lumping.glb',
      'modelName': 'Kuda Lumping',
      'deskripsi':
          'Kuda Lumping adalah properti tari tradisional berbentuk tiruan kuda yang terbuat dari anyaman bambu atau kulit. Pertunjukannya dikenal dengan atraksi kesurupan yang mistis.',
    },
    'KOL-09-ANGKLUNG': {
      'modelUrl': SupabaseConfig.getModelUrl('angklung_buhun.glb'),
      'fileName': 'angklung_buhun.glb',
      'modelName': 'Angklung Buhun',
      'deskripsi':
          'Angklung Buhun adalah alat musik bambu kuno khas masyarakat Baduy yang digunakan dalam ritual adat. Berbeda dari angklung modern, Buhun hanya dimainkan pada upacara sakral Seren Taun.',
    },
    'KOL-10-BEBER': {
      'modelUrl': SupabaseConfig.getModelUrl('wayang_beber.glb'),
      'fileName': 'wayang_beber.glb',
      'modelName': 'Wayang Beber',
      'deskripsi':
          'Wayang Beber adalah seni pertunjukan wayang tertua di Jawa, berbentuk gulungan lukisan bergambar cerita. Dalang bercerita sambil membeberkan (membuka) gulungan gambar satu per satu.',
    },
    'KOL-11-TOMBAK': {
      'modelUrl': SupabaseConfig.getModelUrl('tombak_trisula.glb'),
      'fileName': 'tombak_trisula.glb',
      'modelName': 'Tombak Trisula',
      'deskripsi':
          'Tombak Trisula adalah senjata tradisional bermata tiga yang melambangkan kekuatan Dewa Siwa. Digunakan sebagai simbol kekuasaan dan perlindungan kerajaan-kerajaan Hindu di Nusantara.',
    },
    'KOL-12-KELANA': {
      'modelUrl': SupabaseConfig.getModelUrl('topeng_kelana.glb'),
      'fileName': 'topeng_kelana.glb',
      'modelName': 'Topeng Kelana',
      'deskripsi':
          'Topeng Kelana berwarna merah menyala melambangkan amarah, nafsu, dan angkara murka. Ia adalah raja jahat dalam pertunjukan topeng Cirebon yang mengejar Dewi Sekartaji.',
    },
    'KOL-13-KENONG': {
      'modelUrl': SupabaseConfig.getModelUrl('gamelan_kenong.glb'),
      'fileName': 'gamelan_kenong.glb',
      'modelName': 'Gamelan Kenong',
      'deskripsi':
          'Kenong adalah alat musik pukul berupa gong kecil yang duduk di atas tali dalam gamelan Jawa. Berfungsi sebagai penegas irama dan penanda frase musikal dalam setiap gongan.',
    },
    'KOL-14-GANESHA': {
      'modelUrl': SupabaseConfig.getModelUrl('arca_ganesha.glb'),
      'fileName': 'arca_ganesha.glb',
      'modelName': 'Arca Ganesha',
      'deskripsi':
          'Arca Ganesha adalah patung dewa berkepala gajah, pelindung ilmu pengetahuan dan pembuang rintangan dalam kepercayaan Hindu. Banyak ditemukan di situs-situs candi di Jawa dan Bali.',
    },
    'KOL-15-BLENCONG': {
      'modelUrl': SupabaseConfig.getModelUrl('blencong.glb'),
      'fileName': 'blencong.glb',
      'modelName': 'Blencong',
      'deskripsi':
          'Blencong adalah lampu minyak gantung berbentuk khas yang digunakan khusus dalam pertunjukan wayang kulit. Cahayanya menciptakan bayangan dramatik pada kelir (layar putih) di belakang wayang.',
    },

    // Backward compatible dengan QR lama
    '01-wayang-cepot': {
      'modelUrl': SupabaseConfig.getModelUrl('wayang_cepot.glb'),
      'fileName': 'wayang_cepot.glb',
      'modelName': 'Wayang Golek Cepot',
      'deskripsi':
          'Cepot atau Astrajingga adalah karakter punakawan khas Sunda yang jenaka dan humoris. Ia adalah anak sulung Semar, dengan wajah merah dan sifat yang polos namun penuh kebijaksanaan tersembunyi.',
    },
  };

  void _handleScan(String rawValue) {
    if (_isNavigating) return;

    final koleksi = _koleksiMap[rawValue];

    if (koleksi != null) {
      setState(() => _isNavigating = true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ArViewScreen(
            modelUrl: koleksi['modelUrl']!,
            fileName: koleksi['fileName']!,
            modelName: koleksi['modelName']!,
            deskripsi: koleksi['deskripsi'], // ← kirim deskripsi ke popup
          ),
        ),
      ).then((_) {
        if (mounted) setState(() => _isNavigating = false);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('QR tidak dikenal: "$rawValue"'),
          backgroundColor: Colors.red[700],
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan QR Koleksi',
          style: TextStyle(fontFamily: 'Inter'),
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
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              'Arahkan kamera ke QR Code Koleksi',
              textAlign: TextAlign.center,
              style: TextStyle(
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
