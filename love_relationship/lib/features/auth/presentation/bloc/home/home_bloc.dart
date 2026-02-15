import 'dart:async';

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
    emit(state.copyWith(loading: true, error: null));

    try {
      final uid = authSession.requireUid();

      _streamSubscription?.cancel();
      _streamSubscription = watchUserProfileUsecase(uid).listen((either) {
        either.fold(
          (f) => add(HomeUserError(f.message ?? 'Unknown error')),
          (user) => add(HomeUserReceived(user)),
        );
      });
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onUserReceived(HomeUserReceived event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      user: event.user,
      ready: true,
      loading: false,
      error: null,
    ));
  }

  void _onUserError(HomeUserError event, Emitter<HomeState> emit) {
    emit(state.copyWith(error: event.message, loading: false));
  }

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    return super.close();
  }
}
