class UserState {
  final String? id;
  final String? name;
  final String? email;
  final String? documentNumber;
  final String? phone;
  final String? password;
  final String? mainAddress;
  final String? role;
  final bool isLoading;
  final String? error;

  const UserState(
    {
    this.id,  
    this.name,
    this.email,
    this.documentNumber,
    this.phone,
    this.password,
    this.mainAddress,
    this.role,
    this.isLoading = false,
    this.error,
  }
  );
  factory UserState.initial() => const UserState(
    id: null,
    name:'',
    email: '',
    documentNumber: '',
    phone: '',
    password: '',
    mainAddress: '',
    role: '',
    isLoading: false,
    error: ''
  );

  UserState copyWith({
    String? id,
    bool? isLoading,
    String? name,
    String? email,
    String? documentNumber,
    String? phone,
    String? password,
    String? mainAddress,
    String? role,
    String? error,
  }) {
    return UserState(
      id: id ?? this.id,
      isLoading: isLoading ?? this.isLoading,
      name: name ?? this.name,
      email: email ?? this.email,
      documentNumber: documentNumber ?? this.documentNumber,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      mainAddress: mainAddress ?? this.mainAddress,
      role: role ?? this.role,
      error: error ?? this.error,
    );
  }

  const UserState.empty()
      : id = null,
        isLoading = false,
        name = '',
        email = '',
        documentNumber = '',
        phone = '',
        password = '',
        mainAddress = '',
        role = '',
        error = '';
}
