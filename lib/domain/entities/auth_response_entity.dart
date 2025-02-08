class AuthResponseEntity {
  final String accessToken;
  final String refreshToken;
  final String role;
  final int expiration;

  AuthResponseEntity(
      {required this.refreshToken,
      required this.expiration,
      required this.accessToken,
      required this.role});
}
