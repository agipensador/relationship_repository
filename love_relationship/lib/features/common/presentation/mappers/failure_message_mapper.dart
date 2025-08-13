import 'package:love_relationship/core/error/failure.dart';
import 'package:flutter/widgets.dart';
import 'package:love_relationship/l10n/app_localizations.dart';

String failureToMessage(BuildContext context, Failure failure){
  final l10n = AppLocalizations.of(context);

  if(failure is AuthFailure && l10n != null){
    switch(failure.type) {
      case AuthErrorType.userNotFound:
        return l10n.userNotFound;
      case AuthErrorType.invalidCredentials:
        return l10n.saveError; // crie uma string específica se quiser
      case AuthErrorType.unauthenticated:
        return l10n.unauthenticatedUser;
      case AuthErrorType.emailAlreadyInUse:
        return l10n.createUserError; // crie uma específica se quiser
      case AuthErrorType.unknown:
      default:
        return l10n.saveError;
    }
  }

  if (failure is ServerFailure && l10n != null) {
  switch (failure.type) {
    case ServerErrorType.createUserError:
      return l10n.createUserError;
    case ServerErrorType.updateUserError:
      return l10n.saveError;
    case ServerErrorType.network:
      return l10n.saveError; // crie "Sem conexão" se quiser
    case ServerErrorType.timeout:
      return l10n.saveError; // crie "Tempo esgotado" se quiser
    case ServerErrorType.unknown:
    default:
      return l10n.saveError;
    }
  }

  if(l10n != null ) {
    return l10n.saveError;
  } else { return 'Unkown Error Undefined!! A2'; }

}