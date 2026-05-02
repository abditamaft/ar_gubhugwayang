import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ModelCacheService {
  /// Download .glb dari Supabase Storage → simpan ke cache HP.
  /// Kalau sudah ada di cache → langsung pakai, skip download.
  static Future<String> getLocalPath({
    required String url,
    required String fileName,
    void Function(double progress)? onProgress,
  }) async {
    final Directory cacheDir = await getTemporaryDirectory();
    final String localPath = '${cacheDir.path}/$fileName';
    final File localFile = File(localPath);

    // Cek cache dulu
    if (await localFile.exists()) {
      final int fileSize = await localFile.length();
      if (fileSize > 1000) {
        return localPath; // Langsung pakai cache
      }
    }

    // Download dari Supabase
    final http.Client client = http.Client();
    try {
      final http.Request request = http.Request('GET', Uri.parse(url));
      final http.StreamedResponse response = await client.send(request);

      if (response.statusCode != 200) {
        throw Exception(
          'Gagal download dari Supabase: HTTP ${response.statusCode}\nURL: $url',
        );
      }

      final int totalBytes = response.contentLength ?? 0;
      int downloadedBytes = 0;

      final IOSink sink = localFile.openWrite();
      await response.stream
          .map((chunk) {
            downloadedBytes += chunk.length;
            if (totalBytes > 0 && onProgress != null) {
              onProgress(downloadedBytes / totalBytes);
            }
            return chunk;
          })
          .pipe(sink);

      return localPath;
    } catch (e) {
      // Hapus file yang mungkin corrupt kalau gagal di tengah jalan
      if (await localFile.exists()) await localFile.delete();
      rethrow;
    } finally {
      client.close();
    }
  }

  /// Hapus semua cache .glb di HP
  static Future<void> clearCache() async {
    final Directory cacheDir = await getTemporaryDirectory();
    for (final entity in cacheDir.listSync()) {
      if (entity is File && entity.path.endsWith('.glb')) {
        await entity.delete();
      }
    }
  }

  /// Hitung total ukuran file .glb yang tersimpan di cache
  static Future<String> getCacheSize() async {
    final Directory cacheDir = await getTemporaryDirectory();
    int totalBytes = 0;
    for (final entity in cacheDir.listSync()) {
      if (entity is File && entity.path.endsWith('.glb')) {
        totalBytes += await entity.length();
      }
    }
    if (totalBytes == 0) return '0 KB';
    if (totalBytes < 1024 * 1024) {
      return '${(totalBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(totalBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
