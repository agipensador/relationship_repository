import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/services/auth_session.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
import 'package:love_relationship/features/auth/domain/usecases/get_user_profile_usecase.dart';
import 'package:love_relationship/features/auth/domain/usecases/update_user_profile_usecase.dart';

part 'edit_user_state.dart';

class EditUserCubit extends Cubit<EditUserState> {
  final AuthSession session;
  final GetUserProfileUsecase getUser;
  final UpdateUserProfileUsecase updateUser;

  EditUserCubit(this.session, this.getUser, this.updateUser) :super(const EditUserState());

  // void prefill(UserEntity user){
  //   emit(state.copyWith(current: user, nameDraft: user.name));
  // }

  // Carrega o usuario atual e pré preenche o rascunho com o nome
  Future<void> load() async {
    emit(state.copyWith(loading: true, error: null));
    try{
      final uid = session.requiredUid();
      final result = await getUser(uid);
      result.fold(
        (failure) => emit(state.copyWith(loading: false, error: failure.message)), 
        (user) => emit(state.copyWith(loading: false, current: user, nameDraft: user.name)));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void onNameChanged(String value){
    emit(state.copyWith(nameDraft: value));
  }

  // Salva o nome
  Future<bool> save() async {
    final current = state.current;
    
    if(current == null) return false;
    // emit(state.copyWith(loading: true, error: null));

    // final updated = UserEntity(
    //   id: current.id, 
    //   name: state.nameDraft?.trim().isEmpty == true ? current.name 
    //   : state.nameDraft?.trim() ?? '',
    //   email: current.email,
    //   );

    final newName = state.nameDraft!.trim().isEmpty ? current.name : state.nameDraft?.trim(); 
    if(newName == current.name) return true; // Nada pra salvar
    
    emit(state.copyWith(loading: true, error: null));
    final updated = UserEntity(
      id: current.id, 
      name: newName,
      email: current.email,
    );

    final result = await updateUser(updated);

    return result.fold(
      (failure){
        state.copyWith(loading: false, error: failure.message);
        return false;
      }, (user) {
        state.copyWith(loading: false, current: user);
        return true;
    });
  }
}