class UpdatePasswordRequestEntity {
  final String oldPassword;
  final String newPassword;
  final String confirmNewPassword;

  UpdatePasswordRequestEntity({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });
}

