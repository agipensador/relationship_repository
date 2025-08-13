import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/core/services/auth_session.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
import 'package:love_relationship/features/auth/domain/usecases/get_user_profile_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/update_user_profile_usecase.dart';
import 'package:love_relationship/features/auth/presentation/cubit/edit_user_state.dart';

class EditUserCubit extends Cubit<EditUserState> {
  final AuthSession session;
  final GetUserProfileUsecase getUser;
  final UpdateUserProfileUsecase updateUser;

  EditUserCubit(this.session, this.getUser, this.updateUser) :super(EditUserState.initial());

  // Carrega o usuario atual

    Future<void> load() async {
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

  void onNameChanged(String value){
    emit(state.copyWith(nameDraft: value, error: null));
  }

  // Salva o nome
  Future<bool> save() async {
    // final current = state.current;
    
    // if(current == null) return false;
    // final newName = state.nameDraft!.trim().isEmpty ? current.name : state.nameDraft?.trim(); 
    // if(newName == current.name) return true; // Nada pra salvar
    
    // emit(state.copyWith(loading: true, error: null));
    // final updated = UserEntity(
    //   id: current.id, 
    //   name: newName,
    //   email: current.email,
    // );

    // final result = await updateUser(updated);

    // return result.fold(
    //   (failure){
    //     state.copyWith(loading: false, error: failure);
    //     return false;
    //   }, (user) {
    //     state.copyWith(loading: false, current: user);
    //     return true;
    // });

    final current = state.current;
    if (current == null) return false;

    final newName =
        state.nameDraft!.trim().isEmpty ? current.name : state.nameDraft?.trim();
    if (newName == current.name) return true; // nada a salvar

    emit(state.copyWith(loading: true, error: null));
    final updated = UserEntity(id: current.id, name: newName, email: current.email);

    final res = await updateUser(updated);
    return res.fold((f) {
      emit(state.copyWith(loading: false, error: f));
      return false;
    }, (user) {
      emit(state.copyWith(loading: false, current: user, nameDraft: user.name, error: null));
      return true;
    });
  }
}