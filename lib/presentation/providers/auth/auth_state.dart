class AuthState {
  final String token;
  final bool isAdmin;
  final bool isLoading;
  final String? error;

  AuthState({
    this.token = '',
    this.isAdmin = false,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => token.isNotEmpty;

  //copyWith
  AuthState copyWith({
    String? token,
    bool? isAdmin,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      token: token ?? this.token,
      isAdmin: isAdmin ?? this.isAdmin,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
