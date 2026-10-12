class ApiConfig {
  static const String baseUrl = String.fromEnvironment('API_BASE_URL');

  static Uri? get loginEndpoint {
    final value = baseUrl.trim();
    final parsed = Uri.tryParse(value);

    if (parsed == null ||
        parsed.host.isEmpty ||
        !const {'http', 'https'}.contains(parsed.scheme) ||
        parsed.hasQuery ||
        parsed.hasFragment) {
      return null;
    }

    final normalizedBaseUrl = value.replaceFirst(RegExp(r'/+$'), '');
    return Uri.tryParse('$normalizedBaseUrl/api/register_or_login');
  }
}