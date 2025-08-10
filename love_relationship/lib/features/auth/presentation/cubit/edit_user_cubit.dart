import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
import 'package:love_relationship/features/auth/domain/usecases/update_user_profile_usecase.dart';

part 'edit_user_state.dart';

class EditUserCubit extends Cubit<EditUserState> {
  final UpdateUserProfileUsecase _updateUserProfileUsecase;
  EditUserCubit(this._updateUserProfileUsecase) :super(const EditUserState());

  void prefill(UserEntity user){
    emit(state.copyWith(current: user, nameDraft: user.name));
  }

  void onNameChanged(String value){
    emit(state.copyWith(nameDraft: value));
  }

  Future<bool> save() async{
    if(state.current == null) return false;
    emit(state.copyWith(loading: true, error: null));

    final updated = UserEntity(
      id: state.current!.id, 
      name: state.nameDraft?.trim().isEmpty == true ? state.current?.name 
      : state.nameDraft?.trim() ?? '',
      email: state.current!.email,
      );

    final result = await _updateUserProfileUsecase(updated);

    return result.fold((failure){
      state.copyWith(loading: false, error: failure.message);
      return false;
    }, (user) {
      state.copyWith(loading: false, current: user);
      return true;
    });
  }
}