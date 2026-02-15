import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/services/auth_session.dart';
import 'package:love_relationship/features/auth/domain/usecases/get_user_profile_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/watch_user_profile_usecase.dart';
import 'package:love_relationship/features/auth/presentation/bloc/home/home_event.dart';
import 'package:love_relationship/features/auth/presentation/bloc/home/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthSession authSession;
  final GetUserProfileUsecase getUserProfileUsecase;
  final WatchUserProfileUsecase watchUserProfileUsecase;

  StreamSubscription? _streamSubscription;

  HomeBloc(
    this.getUserProfileUsecase,
    this.watchUserProfileUsecase,
    this.authSession,
  ) : super(HomeState.initial()) {
    on<HomeLoadCurrentUser>(_onLoadCurrentUser);
    on<HomeUserReceived>(_onUserReceived);
    on<HomeUserError>(_onUserError);
  }

  Future<void> _onLoadCurrentUser(HomeLoadCurrentUser event, Emitter<HomeState> emit) async {
    if (kDebugMode) debugPrint('[HomeBloc] _onLoadCurrentUser: iniciando');
    emit(state.copyWith(loading: true, error: null));

    try {
      final uid = authSession.requireUid();
      if (kDebugMode) debugPrint('[HomeBloc] uid=$uid, inscrevendo em watchUserProfile');

      _streamSubscription?.cancel();
      _streamSubscription = watchUserProfileUsecase(uid).listen(
        (either) {
          either.fold(
            (f) {
              if (kDebugMode) debugPrint('[HomeBloc] stream emitiu Left: ${f.message}');
              add(HomeUserError(f.message ?? 'Unknown error'));
            },
            (user) {
              if (kDebugMode) debugPrint('[HomeBloc] stream emitiu Right: user=${user.name}');
              add(HomeUserReceived(user));
            },
          );
        },
        onError: (e, st) {
          if (kDebugMode) debugPrint('[HomeBloc] stream onError: $e\n$st');
          add(HomeUserError(e.toString()));
        },
        onDone: () {
          if (kDebugMode) debugPrint('[HomeBloc] stream onDone');
        },
        cancelOnError: false,
      );
    } catch (e, st) {
      if (kDebugMode) debugPrint('[HomeBloc] exceção em _onLoadCurrentUser: $e\n$st');
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onUserReceived(HomeUserReceived event, Emitter<HomeState> emit) {
    if (kDebugMode) debugPrint('[HomeBloc] _onUserReceived: user=${event.user.name}');
    emit(state.copyWith(
      user: event.user,
      ready: true,
      loading: false,
      error: null,
    ));
  }

  void _onUserError(HomeUserError event, Emitter<HomeState> emit) {
    if (kDebugMode) debugPrint('[HomeBloc] _onUserError: ${event.message}');
    emit(state.copyWith(error: event.message, loading: false));
  }

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    return super.close();
  }
}
