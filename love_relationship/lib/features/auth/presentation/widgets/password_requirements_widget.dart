import 'package:flutter/material.dart';
import 'package:love_relationship/core/validators/password_validator.dart';
import 'package:love_relationship/l10n/app_localizations.dart';

/// Exibe os requisitos de senha com indicadores visuais (✓/✗) conforme o usuário digita.
class PasswordRequirementsWidget extends StatelessWidget {
  final String password;

  const PasswordRequirementsWidget({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final result = PasswordValidator.validate(password);

    String label(String key) {
      switch (key) {
        case PasswordValidator.minLengthKey:
          return l10n.passwordRequirementMinLength;
        case PasswordValidator.uppercaseKey:
          return l10n.passwordRequirementUppercase;
        case PasswordValidator.lowercaseKey:
          return l10n.passwordRequirementLowercase;
        case PasswordValidator.specialKey:
          return l10n.passwordRequirementSpecial;
        case PasswordValidator.numberKey:
          return l10n.passwordRequirementNumber;
        default:
          return key;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: result.requirements
            .map(
              (r) => Row(
                children: [
                  Icon(
                    r.isMet ? Icons.check_circle : Icons.cancel,
                    size: 18,
                    color: r.isMet ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label(r.key),
                    style: TextStyle(
                      fontSize: 12,
                      color: r.isMet ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
