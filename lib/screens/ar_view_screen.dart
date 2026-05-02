import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../services/model_cache_service.dart';

class ArViewScreen extends StatefulWidget {
  final String modelUrl;
  final String modelName;
  final String fileName;
  final String? deskripsi;

  const ArViewScreen({
    super.key,
    required this.modelUrl,
    required this.modelName,
    required this.fileName,
    this.deskripsi,
  });

  @override
  State<ArViewScreen> createState() => _ArViewScreenState();
}

class _ArViewScreenState extends State<ArViewScreen>
    with TickerProviderStateMixin {
  String? _localFilePath;
  bool _isLoading = true;
  String? _errorMessage;
  double _downloadProgress = 0.0;
  bool _isDownloading = false;

  bool _showInfoPopup = false;
  late AnimationController _popupController;
  late Animation<double> _popupScale;
  late Animation<double> _popupOpacity;

  late AnimationController _arrowController;
  late Animation<double> _arrowBounce;
  bool _showArrowHint = true;

  @override
  void initState() {
    super.initState();

    _popupController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _popupScale = CurvedAnimation(
      parent: _popupController,
      curve: Curves.elasticOut,
    );
    _popupOpacity = CurvedAnimation(
      parent: _popupController,
      curve: Curves.easeIn,
    );

    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _arrowBounce = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );

    _loadModel();
  }

  @override
  void dispose() {
    _popupController.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  Future<void> _loadModel() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _downloadProgress = 0.0;
      _isDownloading = false;
    });

    try {
      final String localPath = await ModelCacheService.getLocalPath(
        url: widget.modelUrl,
        fileName: widget.fileName,
        onProgress: (progress) {
          if (mounted) {
            setState(() {
              _isDownloading = true;
              _downloadProgress = progress;
            });
          }
        },
      );

      if (mounted) {
        setState(() {
          _localFilePath = localPath;
          _isLoading = false;
          _isDownloading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'Gagal memuat model 3D.\n\n'
              'Pastikan:\n'
              '• Koneksi internet aktif\n'
              '• File "${widget.fileName}" sudah diupload ke Supabase\n\n'
              'Detail: $e';
          _isLoading = false;
          _isDownloading = false;
        });
      }
    }
  }

  void _toggleInfoPopup() {
    setState(() => _showInfoPopup = !_showInfoPopup);
    if (_showInfoPopup) {
      _popupController.forward();
    } else {
      _popupController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141318),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
        title: Text(
          widget.modelName,
          style: const TextStyle(
            fontFamily: 'Inter',
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
          ),
        ),
      ),
      body: Stack(
        children: [
          // ── 1. BACKGROUND + VIGNETTE ──────────────────────────
          Positioned.fill(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/bg-wayanggunungan.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFF1B1F2E)),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.0,
                      colors: [Colors.transparent, Color(0xCC000000)],
                      stops: [0.5, 1.0],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xCC000000),
                        Colors.transparent,
                        Colors.transparent,
                        Color(0xDD000000),
                      ],
                      stops: [0.0, 0.2, 0.7, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── 2. LOADING ────────────────────────────────────────
          if (_isLoading)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.view_in_ar,
                      color: Colors.white24,
                      size: 80,
                    ),
                    const SizedBox(height: 24),
                    if (_isDownloading) ...[
                      const Text(
                        'Mengunduh model 3D...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _downloadProgress,
                          minHeight: 10,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFD4A24C),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(_downloadProgress * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tersimpan di cache.\nScan berikutnya langsung tampil!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ] else
                      const CircularProgressIndicator(color: Color(0xFFD4A24C)),
                  ],
                ),
              ),
            ),

          // ── 3. ERROR ──────────────────────────────────────────
          if (!_isLoading && _errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_off,
                            color: Colors.redAccent,
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _loadModel,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4A24C),
                              foregroundColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // ── 4. MODEL VIEWER ───────────────────────────────────
          // PENTING: Tidak dibungkus GestureDetector agar WebView
          // bisa menerima touch event untuk render objek 3D.
          // Tombol AR bawaan (kubus) dari model-viewer otomatis
          // muncul di pojok kanan bawah karena ar: true.
          if (!_isLoading && _localFilePath != null)
            Positioned.fill(
              child: ModelViewer(
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

          // ── 5. PETUNJUK PANAH (menunjuk tombol AR bawaan di kanan bawah)
          if (!_isLoading && _localFilePath != null && _showArrowHint)
            Positioned(
              bottom: 90, // agar pas di atas tombol kubus ~48px
              right: 10, // sejajar dengan tombol kubus bawaan (16px + offset)
              child: GestureDetector(
                onTap: () => setState(() => _showArrowHint = false),
                child: AnimatedBuilder(
                  animation: _arrowBounce,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, -_arrowBounce.value),
                    child: child,
                  ),
                  child: Column(
                    children: [
                      // Label petunjuk
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFD4A24C).withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: const Column(
                              children: [
                                Text(
                                  'Ketuk untuk',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  'Masuk Mode AR',
                                  style: TextStyle(
                                    color: Color(0xFFD4A24C),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Garis vertikal emas
                      Container(
                        width: 2,
                        height: 28,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFFD4A24C).withOpacity(0.9),
                              const Color(0xFFD4A24C).withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                      // Ujung panah
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFFD4A24C),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ── 6. TOMBOL INFO (kiri bawah) ───────────────────────
          if (!_isLoading && _localFilePath != null)
            Positioned(
              bottom: 16, // sama dengan bottom tombol kubus bawaan
              left: 16, // simetris dengan right tombol kubus (16px)
              child: GestureDetector(
                onTap: _toggleInfoPopup,
                child: Container(
                  width: 48, // sama besar dengan tombol kubus
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A24C),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD4A24C).withOpacity(0.5),
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.info_rounded,
                    color: Colors.black,
                    size: 26,
                  ),
                ),
              ),
            ),

          // ── 7. POPUP INFO KOLEKSI ─────────────────────────────
          // Tap di luar popup → tutup
          if (_showInfoPopup)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleInfoPopup,
                child: Container(color: Colors.transparent),
              ),
            ),

          if (_showInfoPopup)
            Positioned(
              bottom: 95,
              left: 20,
              right: 20,
              child: ScaleTransition(
                scale: _popupScale,
                child: FadeTransition(
                  opacity: _popupOpacity,
                  child: GestureDetector(
                    onTap: () {}, // cegah tap popup tutup dirinya
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4A24C).withOpacity(0.93),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFD4A24C,
                                ).withOpacity(0.35),
                                blurRadius: 24,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Header
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.museum_rounded,
                                      color: Colors.black87,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'KOLEKSI MUSEUM',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 2,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          widget.modelName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                            height: 1.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _toggleInfoPopup,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.black54,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Divider
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Container(
                                  height: 1,
                                  color: Colors.black.withOpacity(0.15),
                                ),
                              ),

                              // Deskripsi
                              Text(
                                widget.deskripsi ??
                                    'Koleksi budaya tradisional warisan leluhur '
                                        'Nusantara. Sentuh dan putar objek untuk '
                                        'melihat dari semua sudut pandang.',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  height: 1.55,
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Tags
                              Row(
                                children: [
                                  _buildTag('🏛️ Museum'),
                                  const SizedBox(width: 8),
                                  _buildTag('🎭 Tradisional'),
                                  const SizedBox(width: 8),
                                  _buildTag('🌟 3D AR'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
