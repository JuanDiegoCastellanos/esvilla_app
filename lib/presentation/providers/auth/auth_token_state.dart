class AuthTokenState {
  final String? accessToken;
  final String? refreshToken;
  final int? expiration;
  final String? role;

  bool get isValid {
    if (accessToken == null || expiration == null) return false;
    final expirationDate = DateTime.fromMillisecondsSinceEpoch(expiration!);
    return expirationDate.isAfter(DateTime.now());
  }

  const AuthTokenState({
    this.role,
    required this.accessToken,
    required this.refreshToken,
    required this.expiration,
  });

  const AuthTokenState.empty()
      : accessToken = null,
        refreshToken = null,
        role = null,
        expiration = null;
}
