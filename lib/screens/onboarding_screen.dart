import 'dart:ui';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  bool _startAnimation = false;

  @override
  void initState() {
    super.initState();
    // Pakai addPostFrameCallback agar animasi berjalan tepat setelah frame pertama render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            _startAnimation = true;
          });
        }
      });
    });
  }

  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Museum Gubug Wayang",
      "subtitle":
          "Jelajahi wayang dan artefak museum\ndalam bentuk 3D interaktif.",
    },
    {
      "title": "Scan & Hidupkan Objek",
      "subtitle":
          "Arahkan kamera ke gambar atau objek\nmuseum, lihat jadi hidup!",
    },
    {
      "title": "Belajar dengan Cara Baru",
      "subtitle": "Dengar cerita, pahami filosofi, dan\neksplor budaya.",
    },
  ];

  void _nextPage() {
    if (_currentPage < 2) {
      setState(() {
        _currentPage++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // =========================================================
          // 1. BACKGROUND LAYER PALING BAWAH (GRADIENT)
          // =========================================================
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF141318),
                  Color(0xFF141318),
                  Color(0xFF141318),
                ],
              ),
            ),
          ),

          // =========================================================
          // 2. EFEK GLOW / BLUR LAYER DI TENGAH
          // =========================================================
          Positioned.fill(
            child: Align(
              alignment: const Alignment(0.0, -0.2),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 200, sigmaY: 200),
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1578B1),
                        Color(0xFFDA8533),
                        Color(0xFFDA8533),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // =========================================================
          // 3. KONTEN UTAMA
          // =========================================================
          SafeArea(
            child: Column(
              children: [
                Expanded(child: _buildImageArea()),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 40.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TweenAnimationBuilder<double>(
                        key: ValueKey<int>(_currentPage),
                        tween: Tween<double>(
                          begin: 0.0,
                          end: _startAnimation ? 1.0 : 0.0,
                        ),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                _onboardingData[_currentPage]["title"]!,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                softWrap: false,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _onboardingData[_currentPage]["subtitle"]!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                color: Colors.white70,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildDot(isActive: _currentPage == 0),
                          const SizedBox(width: 8),
                          _buildDot(isActive: _currentPage == 1),
                          const SizedBox(width: 8),
                          _buildDot(isActive: _currentPage == 2),
                        ],
                      ),
                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: Text(
                            _currentPage == 2 ? 'mulai sekarang' : 'next',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageArea() {
    if (_currentPage == 0) {
      return Stack(
        key: const ValueKey(0),
        children: [
          // --- WAYANG KIRI (Muncul dari Kanan ke Kiri) ---
          Positioned(
            left: -70,
            top: 100,
            bottom: 80,
            child: AnimatedOpacity(
              opacity: _startAnimation ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              child: AnimatedSlide(
                // Geser dari offset X=+1.5 (kanan layar) menuju 0 (posisi asli)
                offset: _startAnimation ? Offset.zero : const Offset(-1.5, 0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                child: Transform.scale(
                  scale: 1.2,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/wayang_kiri.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // --- WAYANG KANAN (Muncul dari Kiri ke Kanan) ---
          Positioned(
            right: 25,
            top: 180,
            bottom: 120,
            child: AnimatedOpacity(
              opacity: _startAnimation ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              child: AnimatedSlide(
                // Geser dari offset X=-1.5 (kiri layar) menuju 0 (posisi asli)
                offset: _startAnimation ? Offset.zero : const Offset(1.5, 0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                child: Transform.scale(
                  scale: 1.8,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/wayang_kanan.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (_currentPage == 1) {
      return Center(
        key: const ValueKey(1),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Transform.scale(scale: value, child: child),
            );
          },
          child: Image.asset(
            'assets/images/keris_sakti.png',
            height: 400,
            fit: BoxFit.contain,
          ),
        ),
      );
    } else {
      return Center(
        key: const ValueKey(2),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Transform.scale(scale: value, child: child),
            );
          },
          child: Image.asset(
            'assets/images/gamelan.png',
            height: 350,
            fit: BoxFit.contain,
          ),
        ),
      );
    }
  }

  Widget _buildDot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xFF6B8A8A) : Colors.white,
      ),
    );
  }
}
