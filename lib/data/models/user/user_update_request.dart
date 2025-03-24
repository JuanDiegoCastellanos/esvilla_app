class UpdateUserRequest{
  final String id;
  final String? name;
  final String? documentNumber;
  final String? email;
  final String? phone;
  final String? mainAddress;

  UpdateUserRequest({
    required this.id,
    this.name,
    this.documentNumber,
    this.email,
    this.phone,
    this.mainAddress,
  });

  Map<String, dynamic> toJson(){
    final map = <String, dynamic>{'_id': id};
    if (name != null) map['name'] = name;
    if (documentNumber != null) map['documentNumber'] = documentNumber;
    if (email != null) map['email'] = email;
    if (phone != null) map['phone'] = phone;
    if (mainAddress != null) map['mainAddress'] = mainAddress;
    return map;
  }
}