import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/core/services/auth_session.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
import 'package:love_relationship/features/auth/domain/usecases/get_user_profile_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/update_user_profile_usecase.dart';
import 'package:love_relationship/features/auth/presentation/bloc/edit_user/edit_user_event.dart';
import 'package:love_relationship/features/auth/presentation/bloc/edit_user/edit_user_state.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  final AuthSession session;
  final GetUserProfileUsecase getUser;
  final UpdateUserProfileUsecase updateUser;

  EditUserBloc(this.session, this.getUser, this.updateUser)
      : super(EditUserState.initial()) {
    on<EditUserLoad>(_onLoad);
    on<EditUserNameChanged>(_onNameChanged);
    on<EditUserSave>(_onSave);
    on<EditUserClearSaveSuccess>(_onClearSaveSuccess);
  }

  void _onClearSaveSuccess(EditUserClearSaveSuccess event, Emitter<EditUserState> emit) {
    emit(state.copyWith(saveSuccess: false));
  }

  Future<void> _onLoad(EditUserLoad event, Emitter<EditUserState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final uid = session.requireUid();
      final res = await getUser(uid);
      res.fold(
        (failure) => emit(state.copyWith(loading: false, error: failure)),
        (user) => emit(state.copyWith(
          loading: false,
          current: user,
          nameDraft: user.name,
          error: null,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        error: ServerFailure(ServerErrorType.unknown),
      ));
    }
  }

  void _onNameChanged(EditUserNameChanged event, Emitter<EditUserState> emit) {
    emit(state.copyWith(nameDraft: event.name, error: null));
  }

  Future<void> _onSave(EditUserSave event, Emitter<EditUserState> emit) async {
    final current = state.current;
    if (current == null) return;

    final newName =
        state.nameDraft!.trim().isEmpty ? current.name : state.nameDraft?.trim();
    if (newName == current.name) return;

    emit(state.copyWith(loading: true, error: null));
    final updated =
        UserEntity(id: current.id, name: newName!, email: current.email);

    final res = await updateUser(updated);
    res.fold(
      (f) => emit(state.copyWith(loading: false, error: f)),
      (user) => emit(state.copyWith(
        loading: false,
        current: user,
        nameDraft: user.name,
        error: null,
        saveSuccess: true,
      )),
    );
  }
}
