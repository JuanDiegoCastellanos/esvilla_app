class AuthState {
  final String token;
  final bool isAdmin;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.token = '',
    this.isAdmin = false,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
  });

  //copyWith
  AuthState copyWith({
    String? token,
    bool? isAdmin,
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
  }) {
    return AuthState(
      token: token ?? this.token,
      isAdmin: isAdmin ?? this.isAdmin,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error ?? this.error,
    );
  }
}
