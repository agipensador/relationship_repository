import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/services/auth_session.dart';
import 'package:love_relationship/features/auth/domain/usecases/get_user_profile_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/watch_user_profile_usecase.dart';
import 'package:love_relationship/features/auth/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AuthSession authSession;
  final GetUserProfileUsecase getUserProfileUsecase;
  final WatchUserProfileUsecase watchUserProfileUsecase;

  StreamSubscription? _streamSubscription;

  HomeCubit(
    this.getUserProfileUsecase,
    this.watchUserProfileUsecase,
    this.authSession,
  ) : super(HomeState.initial());

  Future<void> loadCurrentUser() async {
    emit(state.copyWith(loading: true, error: null));

    try {
      final uid = authSession.requireUid();

      // Opcional: escuta em tempo real
      _streamSubscription?.cancel();
      _streamSubscription = watchUserProfileUsecase(uid).listen((either) {
        either.fold(
          (f) => emit(state.copyWith(error: f.message, loading: false)),
          (user) => emit(
            state.copyWith(
              user: user,
              ready: true,
              loading: false,
              error: null,
            ),
          ),
        );
      });
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
    // Ou apenas carregamento pontual:
    // final res = await getUser(uid);
    // res.fold(
    //   (f) => emit(state.copyWith(error: f.message, loading: false)),
    //   (user) => emit(state.copyWith(user: user, loading: false)),
    // );
  }

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    return super.close();
  }
}
