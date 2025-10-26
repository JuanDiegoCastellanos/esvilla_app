class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es requerido';
    }
    final emailRegExp = RegExp(
        r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+(\.[a-zA-Z]+)?$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null 
          ? '$fieldName es requerido' 
          : 'Este campo es requerido';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El número de teléfono es requerido';
    }
    final phoneRegExp = RegExp(r'^[0-9]{10}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Ingrese un número de teléfono válido (10 dígitos)';
    }
    return null;
  }

  static String? validateDocument(String? value) {
    if (value == null || value.isEmpty) {
      return 'El documento es requerido';
    }
    final documentRegExp = RegExp(r'^[0-9]{6,12}$');
    if (!documentRegExp.hasMatch(value)) {
      return 'Ingrese un documento válido (entre 6 y 12 dígitos)';
    }
    return null;
  }
}