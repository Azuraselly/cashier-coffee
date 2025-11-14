import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://vdeviutxdfblzxamufyb.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZkZXZpdXR4ZGZibHp4YW11ZnliIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA5ODczMDIsImV4cCI6MjA3NjU2MzMwMn0.3gUYis0AhkqhhSXtGtUbwwHWFfTyDuvF7QF-jS5_SU8',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}