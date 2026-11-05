import 'package:supabase_flutter/supabase_flutter.dart';

class FeedbackRepository {
  const FeedbackRepository(this._client);

  final SupabaseClient _client;

  Future<void> submit({
    required String category,
    required String message,
    String? screenshotPath,
  }) async {
    await _client.from('feedback_submissions').insert({
      'user_id': _client.auth.currentUser!.id,
      'category': category,
      'message': message,
      'screenshot_path': screenshotPath,
    });
  }
}
