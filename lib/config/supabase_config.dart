class SupabaseConfig {
  // ✅ BENAR - URL dasar saja, tanpa /rest/v1/
  static const String projectUrl = 'https://szkzqlvkwphmrqkixusn.supabase.co';
  static const String bucketName = 'models';

  static String getModelUrl(String fileName) {
    return '$projectUrl/storage/v1/object/public/$bucketName/$fileName';
  }
}
