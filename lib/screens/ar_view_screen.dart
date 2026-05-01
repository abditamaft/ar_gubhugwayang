import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:path_provider/path_provider.dart';

class ArViewScreen extends StatefulWidget {
  final String modelPath; // 'assets/models/wayang_cepot.glb'
  final String modelName;

  const ArViewScreen({
    super.key,
    required this.modelPath,
    required this.modelName,
  });

  @override
  State<ArViewScreen> createState() => _ArViewScreenState();
}

class _ArViewScreenState extends State<ArViewScreen> {
  String? _localFilePath; // Path file di storage HP
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _copyAssetToLocal();
  }

  /// Copy file .glb dari assets → cache storage HP
  /// Ini diperlukan karena Scene Viewer (AR eksternal Google)
  /// tidak bisa akses file di dalam bundle Flutter langsung.
  Future<void> _copyAssetToLocal() async {
    try {
      // 1. Baca file dari assets sebagai bytes
      final ByteData data = await rootBundle.load(widget.modelPath);
      final List<int> bytes = data.buffer.asUint8List();

      // 2. Tentukan lokasi penyimpanan di cache HP
      final Directory cacheDir = await getTemporaryDirectory();
      final String fileName = widget.modelPath.split('/').last;
      final String localPath = '${cacheDir.path}/$fileName';

      // 3. Tulis file ke cache
      final File localFile = File(localPath);
      await localFile.writeAsBytes(bytes, flush: true);

      // 4. Update state dengan path lokal yang sudah jadi
      if (mounted) {
        setState(() {
          _localFilePath = localPath;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal memuat model: $e\n\nPastikan file "${widget.modelPath}" ada di folder assets.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141318),
      appBar: AppBar(
        title: Text(widget.modelName,
            style: const TextStyle(fontFamily: 'Inter')),
        backgroundColor: const Color(0xFF1B233A),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // ── STATE 1: LOADING ──────────────────────────────────
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Memuat model 3D...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

          // ── STATE 2: ERROR ────────────────────────────────────
          if (!_isLoading && _errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.redAccent, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                          _errorMessage = null;
                        });
                        _copyAssetToLocal();
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            ),

          // ── STATE 3: MODEL SIAP ───────────────────────────────
          if (!_isLoading && _localFilePath != null)
            Positioned.fill(
              child: ModelViewer(
                // ✅ Gunakan URI file lokal — format yang bisa dibaca
                // oleh WebView internal DAN Scene Viewer Google
                src: 'file://$_localFilePath',
                backgroundColor: Colors.transparent,
                alt: 'Model 3D ${widget.modelName}',
                ar: true,
                arModes: const ['scene-viewer', 'webxr', 'quick-look'],
                autoRotate: true,
                cameraControls: true,
                loading: Loading.eager,
              ),
            ),

          // ── KARTU PETUNJUK (hanya tampil saat model sudah siap) ──
          if (!_isLoading && _localFilePath != null)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Text(
                  'Geser untuk memutar 360°.\n'
                  'Ketuk ikon AR di kanan bawah untuk meletakkan objek di ruanganmu!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}