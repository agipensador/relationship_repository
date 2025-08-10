import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/features/auth/domain/usecases/get_user_profile_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/watch_user_profile_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:love_relationship/features/auth/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetUserProfileUsecase getUserProfileUsecase;
  final WatchUserProfileUsecase watchUserProfileUsecase;
  final fb.FirebaseAuth auth;

  StreamSubscription? _streamSubscription;
  
  HomeCubit(this.getUserProfileUsecase, this.watchUserProfileUsecase, this.auth) : super(HomeState.initial());

  Future<void> loadCurrentUser() async {
  final uid = auth.currentUser?.uid;
    if (uid == null) {
      emit(state.copyWith(error: 'Usuário não autenticado'));
      return;
    }

    // Opcional: escuta em tempo real
    _streamSubscription?.cancel();
    _streamSubscription = watchUserProfileUsecase(uid).listen((either) {
      either.fold(
        (f) => emit(state.copyWith(error: f.message, loading: false)),
        (user) => emit(state.copyWith(user: user, loading: false, error: null)),
      );
    });

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