/// Resultado da validação de senha com detalhes dos requisitos atendidos.
class PasswordValidationResult {
  final bool isValid;
  final List<PasswordRequirement> requirements;

  const PasswordValidationResult({
    required this.isValid,
    required this.requirements,
  });

  List<PasswordRequirement> get failedRequirements =>
      requirements.where((r) => !r.isMet).toList();
}

/// Requisito individual de senha.
class PasswordRequirement {
  final String key;
  final bool isMet;

  const PasswordRequirement({required this.key, required this.isMet});
}

/// Validador de senha com regras obrigatórias:
/// - Mínimo 8 caracteres
/// - Letra maiúscula
/// - Letra minúscula
/// - Caractere especial
/// - Número
class PasswordValidator {
  PasswordValidator._();

  static const int minLength = 8;
  static const String uppercaseKey = 'uppercase';
  static const String lowercaseKey = 'lowercase';
  static const String specialKey = 'special';
  static const String numberKey = 'number';
  static const String minLengthKey = 'minLength';

  static final RegExp _uppercase = RegExp(r'[A-Z]');
  static final RegExp _lowercase = RegExp(r'[a-z]');
  static final RegExp _special = RegExp(r'[^a-zA-Z0-9]');
  static final RegExp _number = RegExp(r'[0-9]');

  /// Valida a senha e retorna o resultado com status de cada requisito.
  static PasswordValidationResult validate(String password) {
    final requirements = [
      PasswordRequirement(
        key: minLengthKey,
        isMet: password.length >= minLength,
      ),
      PasswordRequirement(
        key: uppercaseKey,
        isMet: _uppercase.hasMatch(password),
      ),
      PasswordRequirement(
        key: lowercaseKey,
        isMet: _lowercase.hasMatch(password),
      ),
      PasswordRequirement(
        key: specialKey,
        isMet: _special.hasMatch(password),
      ),
      PasswordRequirement(
        key: numberKey,
        isMet: _number.hasMatch(password),
      ),
    ];

    final isValid = requirements.every((r) => r.isMet);

    return PasswordValidationResult(
      isValid: isValid,
      requirements: requirements,
    );
  }

  /// Verifica se a senha é válida (atalho).
  static bool isValid(String password) => validate(password).isValid;
}
