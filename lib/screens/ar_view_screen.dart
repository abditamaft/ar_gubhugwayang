import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../services/model_cache_service.dart';
import '../provider/language_provider.dart';

class ArViewScreen extends StatefulWidget {
  final String modelUrl;
  final String modelName; // Nama wayang — TIDAK diterjemahkan
  final String fileName;
  final String? deskripsi; // Deskripsi Indonesia
  final String? deskripsiEn; // Deskripsi English

  const ArViewScreen({
    super.key,
    required this.modelUrl,
    required this.modelName,
    required this.fileName,
    this.deskripsi,
    this.deskripsiEn,
  });

  @override
  State<ArViewScreen> createState() => _ArViewScreenState();
}

// ← LanguageAware + TickerProviderStateMixin
class _ArViewScreenState extends State<ArViewScreen>
    with TickerProviderStateMixin, LanguageAware {
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

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  // Ukuran tombol AR bawaan model-viewer ≈ 48x48 logical px
  // Kita samakan tombol info dengan ukuran yang sama
  static const double _buttonSize = 48.0;

  @override
  void initState() {
    super.initState(); // LanguageAware.initState dipanggil di sini

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
      duration: const Duration(milliseconds: 750),
    )..repeat(reverse: true);
    _arrowBounce = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _loadModel();
  }

  @override
  void dispose() {
    _popupController.dispose();
    _arrowController.dispose();
    _pulseController.dispose();
    super.dispose(); // LanguageAware.dispose dipanggil di sini
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
          _errorMessage = e.toString();
          _isLoading = false;
          _isDownloading = false;
        });
      }
    }
  }

  void _toggleInfoPopup() {
    setState(() => _showInfoPopup = !_showInfoPopup);
    if (_showInfoPopup) {
      _pulseController.stop();
      _popupController.forward();
    } else {
      _pulseController.repeat(reverse: true);
      _popupController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // lp = LanguageProvider dari mixin LanguageAware
    final ar = AppStrings.arView;

    final String deskripsiTampil = lp.isIndonesian
        ? (widget.deskripsi ?? lp.s(ar, 'popup_default_desc'))
        : (widget.deskripsiEn ?? lp.s(ar, 'popup_default_desc'));

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
              color: Colors.black.withOpacity(0.55),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                widget.modelName, // Nama wayang TIDAK diterjemahkan
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Ikon ⓘ kecil di sebelah judul (tetap ada)
            GestureDetector(
              onTap: _toggleInfoPopup,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4A24C).withOpacity(0.85),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.black,
                  size: 16,
                ),
              ),
            ),
          ],
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
                      colors: [Colors.transparent, Color(0xBB000000)],
                      stops: [0.45, 1.0],
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
                        Color(0xEE000000),
                      ],
                      stops: [0.0, 0.18, 0.65, 1.0],
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
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFD4A24C), Color(0xFFF5D08C)],
                      ).createShader(bounds),
                      child: const Icon(
                        Icons.view_in_ar,
                        color: Colors.white,
                        size: 72,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_isDownloading) ...[
                      Text(
                        lp.s(ar, 'downloading'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.modelName,
                        style: const TextStyle(
                          color: Color(0xFFD4A24C),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _downloadProgress,
                          minHeight: 8,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFD4A24C),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${(_downloadProgress * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Color(0xFFD4A24C),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lp.s(ar, 'cache_hint'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ] else ...[
                      const CircularProgressIndicator(
                        color: Color(0xFFD4A24C),
                        strokeWidth: 2,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        lp.s(ar, 'preparing'),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
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
                        color: Colors.black.withOpacity(0.72),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_off,
                            color: Colors.redAccent,
                            size: 56,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${lp.s(ar, 'error_title')}\n\n'
                            '${lp.s(ar, 'error_check')}\n\n'
                            'Detail: $_errorMessage',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _loadModel,
                            icon: const Icon(Icons.refresh, size: 18),
                            label: Text(lp.s(ar, 'retry')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4A24C),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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

          // ── 5. ARROW HINT (menunjuk tombol AR bawaan di kanan bawah)
          // Posisi disesuaikan agar tepat di atas tombol kubus bawaan
          if (!_isLoading && _localFilePath != null && _showArrowHint)
            Positioned(
              // Tombol kubus bawaan model-viewer: bottom=16, right=16, size=48
              // Arrow hint diletakkan tepat di atasnya
              bottom: 16 + _buttonSize + 8, // 16(margin) + 48(tombol) + 8(gap)
              right: 16,
              child: GestureDetector(
                onTap: () => setState(() => _showArrowHint = false),
                child: AnimatedBuilder(
                  animation: _arrowBounce,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, -_arrowBounce.value),
                    child: child,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Label petunjuk
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.68),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFD4A24C).withOpacity(0.6),
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.touch_app_rounded,
                                  color: Color(0xFFD4A24C),
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lp.s(ar, 'ar_hint_tap'),
                                      style: const TextStyle(
                                        color: Colors.white60,
                                        fontSize: 10,
                                      ),
                                    ),
                                    Text(
                                      lp.s(ar, 'ar_hint_mode'),
                                      style: const TextStyle(
                                        color: Color(0xFFD4A24C),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Garis + panah mengarah ke tombol kubus
                      Padding(
                        padding: EdgeInsets.only(
                          // Pusatkan garis di tengah tombol kubus (48/2 - 1 = 23)
                          right: (_buttonSize / 2) - 1,
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 2,
                              height: 26,
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
                            const Icon(
                              Icons.arrow_drop_down_rounded,
                              color: Color(0xFFD4A24C),
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ── 6. TOMBOL INFO MENGAMBANG (kiri bawah) ───────────
          // ✅ PERBAIKAN UKURAN: Samakan dengan tombol AR bawaan
          // Tombol AR bawaan model-viewer: bottom=16, right=16, size≈48x48
          // Tombol info kita: bottom=16, left=16, size=48x48 (SAMA PERSIS)
          if (!_isLoading && _localFilePath != null)
            Positioned(
              bottom: 16, // sama dengan bottom tombol kubus bawaan
              left: 16, // simetris dengan right=16 tombol kubus
              child: AnimatedBuilder(
                animation: _pulseAnim,
                builder: (_, child) =>
                    Transform.scale(scale: _pulseAnim.value, child: child),
                child: GestureDetector(
                  onTap: _toggleInfoPopup,
                  child: Container(
                    // ✅ Ukuran SAMA dengan tombol kubus bawaan (~48x48)
                    width: _buttonSize,
                    height: _buttonSize,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4A24C),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD4A24C).withOpacity(0.5),
                          blurRadius: 14,
                          spreadRadius: 1,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.info_rounded,
                      color: Colors.black,
                      size: 22, // ikon lebih kecil agar proporsional
                    ),
                  ),
                ),
              ),
            ),

          // ── 7. TAP LUAR POPUP → TUTUP ─────────────────────────
          if (_showInfoPopup)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleInfoPopup,
                child: Container(color: Colors.transparent),
              ),
            ),

          // ── 8. POPUP INFO KOLEKSI ─────────────────────────────
          if (_showInfoPopup)
            Positioned(
              // Muncul di atas tombol info + sedikit margin
              bottom: 16 + _buttonSize + 12,
              left: 16,
              right: 16,
              child: ScaleTransition(
                scale: _popupScale,
                alignment: Alignment.bottomLeft,
                child: FadeTransition(
                  opacity: _popupOpacity,
                  child: GestureDetector(
                    onTap: () {}, // cegah tap popup tutup dirinya
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8A830).withOpacity(0.94),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFD4A24C,
                                ).withOpacity(0.40),
                                blurRadius: 28,
                                spreadRadius: 2,
                                offset: const Offset(0, 6),
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
                                      color: Colors.black.withOpacity(0.14),
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
                                        Text(
                                          lp.s(ar, 'popup_label'),
                                          style: const TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 2.2,
                                            color: Colors.black45,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          widget
                                              .modelName, // TIDAK diterjemahkan
                                          style: const TextStyle(
                                            fontSize: 19,
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
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.14),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: Colors.black54,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Divider
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                child: Container(
                                  height: 1,
                                  color: Colors.black.withOpacity(0.13),
                                ),
                              ),

                              // Deskripsi sesuai bahasa
                              Text(
                                deskripsiTampil,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  height: 1.6,
                                ),
                              ),

                              const SizedBox(height: 15),

                              // Tags sesuai bahasa
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  _buildTag(lp.s(ar, 'tag1')),
                                  _buildTag(lp.s(ar, 'tag2')),
                                  _buildTag(lp.s(ar, 'tag3')),
                                  _buildTag('📍 Gubug Wayang'),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.11),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.08), width: 1),
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
