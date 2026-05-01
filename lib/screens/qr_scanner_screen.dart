import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'ar_view_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _isNavigating = false;

  /// ✅ Mapping QR Code → data koleksi
  /// Tambahkan koleksi baru di sini sesuai file .glb yang kamu punya
  static const Map<String, Map<String, String>> _koleksiMap = {
    'KOL-01-PANJI': {
      'modelPath': 'assets/models/topeng_panji.glb',
      'modelName': 'Topeng Panji',
    },
    'KOL-02-KERIS': {
      'modelPath': 'assets/models/keris_pusaka.glb',
      'modelName': 'Keris Pusaka',
    },
    'KOL-03-GONG': {
      'modelPath': 'assets/models/gong_gamelan.glb',
      'modelName': 'Gong Gamelan',
    },
    'KOL-04-ARJUNA': {
      'modelPath': 'assets/models/wayang_arjuna.glb',
      'modelName': 'Wayang Kulit Arjuna',
    },
    'KOL-05-CEPOT': {
      'modelPath': 'assets/models/wayang_cepot.glb',
      'modelName': 'Wayang Golek Cepot',
    },
    // Tambahkan koleksi lainnya di sini...
    // Format QR yang dicetak: KOL-06-BATIK, KOL-07-MAHKOTA, dst.
    '01-wayang-cepot': {
      // ← backward compatible dengan kode lama kamu
      'modelPath': 'assets/models/wayang_cepot.glb',
      'modelName': 'Wayang Golek Cepot',
    },
  };

  void _handleScan(String rawValue) {
    if (_isNavigating) return;

    final koleksi = _koleksiMap[rawValue];

    if (koleksi != null) {
      // ✅ QR dikenal → buka AR
      setState(() => _isNavigating = true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ArViewScreen(
            modelPath: koleksi['modelPath']!,
            modelName: koleksi['modelName']!,
          ),
        ),
      );
    } else {
      // ✅ QR tidak dikenal → tampilkan pesan, jangan layar hitam diam
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
