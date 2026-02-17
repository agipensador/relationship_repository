import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart' hide AuthSession;
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/core/services/auth_session.dart';

class AmplifyAuthSession implements AuthSession {
  final _controller = StreamController<String?>.broadcast();
  String? _cachedUid;

  AmplifyAuthSession() {
    _initStream();
  }

  void _emit(String? uid) {
    _cachedUid = uid;
    _controller.add(uid);
  }

  void _initStream() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      _emit(user.userId);
    } catch (_) {
      _emit(null);
    }
    Amplify.Hub.listen(HubChannel.Auth, (event) {
      if (event is AuthHubEvent) {
        switch (event.type) {
        case AuthHubEventType.signedIn:
          _emit(event.payload?.userId);
          break;
        case AuthHubEventType.signedOut:
        case AuthHubEventType.sessionExpired:
        case AuthHubEventType.userDeleted:
          _emit(null);
          break;
        }
      }
    });
  }

  @override
  String? currentUidOrNull() => _cachedUid;

  @override
  String requireUid() {
    final uid = _cachedUid;
    if (uid == null) {
      throw AuthFailure(AuthErrorType.unauthenticated);
    }
    return uid;
  }

  @override
  Stream<String?> uidChanges() => _controller.stream;
}
