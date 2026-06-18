import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ═══════════════════════════════════════════════════════════════
// GLOBAL SINGLETON
// ═══════════════════════════════════════════════════════════════
class LanguageProvider extends ChangeNotifier {
  static final LanguageProvider _instance = LanguageProvider._internal();
  factory LanguageProvider() => _instance;
  LanguageProvider._internal();

  String _lang = 'id';

  String get lang => _lang;
  bool get isIndonesian => _lang == 'id';

  // Panggil ini di main() sebelum runApp
  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _lang = prefs.getString('app_language') ?? 'id';
    notifyListeners();
  }

  void setLanguage(String lang) async {
    // tambah async
    if (_lang != lang) {
      _lang = lang;
      final prefs = await SharedPreferences.getInstance(); // tambah
      await prefs.setString('app_language', lang); // tambah
      notifyListeners();
    }
  }

  String s(Map<String, Map<String, String>> map, String key) {
    return AppStrings.get(map, _lang, key);
  }
}

// ═══════════════════════════════════════════════════════════════
// SEMUA TEKS APLIKASI
// ═══════════════════════════════════════════════════════════════
class AppStrings {
  static const Map<String, Map<String, String>> onboarding = {
    'id': {
      'title0': 'Museum Gubug Wayang',
      'sub0': 'Jelajahi wayang dan artefak museum\ndalam bentuk 3D interaktif.',
      'title1': 'Scan & Hidupkan Objek',
      'sub1': 'Arahkan kamera ke gambar atau objek\nmuseum, lihat jadi hidup!',
      'title2': 'Belajar dengan Cara Baru',
      'sub2': 'Dengar cerita, pahami filosofi, dan\neksplor budaya.',
      'next': 'next',
      'start': 'mulai sekarang',
    },
    'en': {
      'title0': 'Gubug Wayang Museum',
      'sub0': 'Explore wayang and museum artifacts\nin interactive 3D.',
      'title1': 'Scan & Bring Objects to Life',
      'sub1':
          'Point your camera at museum images\nor objects and watch them come alive!',
      'title2': 'Learn in a New Way',
      'sub2': 'Hear stories, understand philosophy,\nand explore culture.',
      'next': 'next',
      'start': 'get started',
    },
  };

  static const Map<String, Map<String, String>> dashboard = {
    'id': {
      'title': 'KOLEKSI GUBUG WAYANG',
      'search': 'Cari koleksi...',
      'langSheet_title': 'Pilih Bahasa',
      'langSheet_sub': 'Ubah bahasa tampilan aplikasi',
      'lang_id': 'Bahasa Indonesia',
      'lang_en': 'English',
      'lang_id_sub': 'Tampilan dalam Bahasa Indonesia',
      'lang_en_sub': 'Display in English',
    },
    'en': {
      'title': 'GUBUG WAYANG COLLECTION',
      'search': 'Search collection...',
      'langSheet_title': 'Select Language',
      'langSheet_sub': 'Change the app display language',
      'lang_id': 'Bahasa Indonesia',
      'lang_en': 'English',
      'lang_id_sub': 'Display in Indonesian',
      'lang_en_sub': 'Display in English',
    },
  };

  static const Map<String, Map<String, String>> scanner = {
    'id': {
      'appbar': 'Scan QR Koleksi',
      'hint': 'Arahkan kamera ke QR Code Koleksi',
      'unknown': 'QR tidak dikenal',
    },
    'en': {
      'appbar': 'Scan Collection QR',
      'hint': 'Point camera at Collection QR Code',
      'unknown': 'Unrecognized QR code',
    },
  };

  static const Map<String, Map<String, String>> arView = {
    'id': {
      'downloading': 'Mengunduh model 3D...',
      'preparing': 'Menyiapkan model...',
      'cache_hint': 'Tersimpan di cache.\nScan berikutnya langsung tampil!',
      'error_title': 'Gagal memuat model 3D.',
      'error_check':
          'Pastikan:\n• Koneksi internet aktif\n• File sudah diupload ke Supabase',
      'retry': 'Coba Lagi',
      'ar_hint_tap': 'Ketuk untuk',
      'ar_hint_mode': 'Masuk Mode AR',
      'popup_label': 'KOLEKSI MUSEUM',
      'popup_default_desc':
          'Koleksi budaya tradisional warisan leluhur Nusantara. Sentuh dan putar objek untuk melihat dari semua sudut pandang.',
      'tag1': '🏛️ Museum',
      'tag2': '🎭 Tradisional',
      'tag3': '🌟 3D AR',
    },
    'en': {
      'downloading': 'Downloading 3D model...',
      'preparing': 'Preparing model...',
      'cache_hint': 'Saved to cache.\nNext scan will load instantly!',
      'error_title': 'Failed to load 3D model.',
      'error_check':
          'Please check:\n• Internet connection is active\n• File has been uploaded to Supabase',
      'retry': 'Try Again',
      'ar_hint_tap': 'Tap to',
      'ar_hint_mode': 'Enter AR Mode',
      'popup_label': 'MUSEUM COLLECTION',
      'popup_default_desc':
          'Traditional cultural collection, a legacy of the Nusantara ancestors. Touch and rotate the object to view from all angles.',
      'tag1': '🏛️ Museum',
      'tag2': '🎭 Traditional',
      'tag3': '🌟 3D AR',
    },
  };

  static const Map<String, Map<String, String>> infoMuseum = {
    'id': {
      'appbar_title': 'Informasi Museum',
      'hero_title': 'Informasi Museum Gubug\nWayang Mojokerto',
      'tagline': 'Pilih kategori informasi di bawah',
      'menu_tentang_app': 'Tentang\nAplikasi',
      'menu_fitur': 'Fitur\nAplikasi',
      'menu_tujuan': 'Tujuan\nPengembangan',
      'menu_museum': 'Tentang\nMuseum',
    },
    'en': {
      'appbar_title': 'Museum Information',
      'hero_title': 'Information of Gubug\nWayang Mojokerto Museum',
      'tagline': 'Select an information category below',
      'menu_tentang_app': 'About\nApplication',
      'menu_fitur': 'Application\nFeatures',
      'menu_tujuan': 'Development\nGoals',
      'menu_museum': 'About\nMuseum',
    },
  };

  static String get(
    Map<String, Map<String, String>> map,
    String lang,
    String key,
  ) {
    return map[lang]?[key] ?? map['id']?[key] ?? key;
  }
}

// ═══════════════════════════════════════════════════════════════
// LANGUAGE SCOPE — InheritedWidget agar semua screen bisa akses
// via LanguageScope.of(context)
// ═══════════════════════════════════════════════════════════════
class LanguageScope extends InheritedNotifier<LanguageProvider> {
  const LanguageScope({
    super.key,
    required LanguageProvider provider,
    required super.child,
  }) : super(notifier: provider);

  static LanguageProvider of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LanguageScope>();
    assert(scope != null, 'LanguageScope tidak ditemukan di widget tree');
    return scope!.notifier!;
  }
}

// ═══════════════════════════════════════════════════════════════
// MIXIN — auto-rebuild saat bahasa berubah
// ═══════════════════════════════════════════════════════════════
mixin LanguageAware<T extends StatefulWidget> on State<T> {
  final LanguageProvider _lp = LanguageProvider();

  @override
  void initState() {
    super.initState();
    _lp.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _lp.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  LanguageProvider get lp => _lp;
}
