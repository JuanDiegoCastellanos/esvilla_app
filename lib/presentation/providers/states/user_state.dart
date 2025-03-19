class UserState {
  final String? name;
  final String? email;
  final String? documentNumber;
  final String? phone;
  final String? mainAddress;
  final String? role;
  final bool isLoading;

  UserState(
    {
    required this.name,
    required this.email,
    required this.documentNumber,
    required this.phone,
    required this.mainAddress,
    required this.role,
    this.isLoading = false,
  }
  );

  UserState copyWith({
    bool? isLoading,
    String? name,
    String? email,
    String? documentNumber,
    String? phone,
    String? mainAddress,
    String? role,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      name: name ?? this.name,
      email: email ?? this.email,
      documentNumber: documentNumber ?? this.documentNumber,
      phone: phone ?? this.phone,
      mainAddress: mainAddress ?? this.mainAddress,
      role: role ?? this.role,
    );
  }

  const UserState.empty()
      : isLoading = false,
        name = '',
        email = '',
        documentNumber = '',
        phone = '',
        mainAddress = '',
        role = '';
}
