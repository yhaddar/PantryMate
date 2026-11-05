class AppConfig {
  const AppConfig({required this.supabaseUrl, required this.supabaseAnonKey});

  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      supabaseUrl: 'https://kerggpakhptlkaapgwyo.supabase.co',
      supabaseAnonKey: 'sb_publishable_5luoif3Rf9-cJmvTYcu1EQ_TgsFh1FU',
    );
  }

  final String supabaseUrl;
  final String supabaseAnonKey;

  bool get hasSupabase =>
      supabaseUrl.startsWith('https://') && supabaseAnonKey.isNotEmpty;
}
