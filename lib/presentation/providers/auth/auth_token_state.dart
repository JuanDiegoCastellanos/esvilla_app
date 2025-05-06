class AuthTokenState {
  final String? accessToken;
  final String? refreshToken;
  final int? expiration;
  final String? role;

  const AuthTokenState({
    this.role,
    this.accessToken,
    this.refreshToken,
    this.expiration,
  });
  const AuthTokenState.empty() : this();

  AuthTokenState copyWith({
    String? role,
    String? accessToken,
    String? refreshToken,
    int? expiration,
  }) {
    return AuthTokenState(
      role: role ?? this.role,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiration: expiration ?? this.expiration,
    );
  }

  bool get isValid {
    if (accessToken == null || expiration == null) return false;
    final expirationDate = DateTime.fromMillisecondsSinceEpoch(expiration!);
    return expirationDate.isAfter(DateTime.now());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthTokenState &&
          runtimeType == other.runtimeType &&
          role == other.role &&
          accessToken == other.accessToken &&
          refreshToken == other.refreshToken &&
          expiration == other.expiration;

  @override
  int get hashCode =>
      role.hashCode ^
      accessToken.hashCode ^
      refreshToken.hashCode ^
      expiration.hashCode;
}
