part of 'edit_user_cubit.dart';

class EditUserState {
  final bool loading;
  final String? error;
  final UserEntity? current;
  final String? nameDraft;

  const EditUserState({this.loading = false, this.error, this.current, this.nameDraft = ''});

  EditUserState copyWith({
    bool? loading,
    String? error,
    UserEntity? current,
    String? nameDraft,
  }) {
    return EditUserState(
      loading: loading ?? this.loading,
      error: error,
      current: current ?? this.current,
      nameDraft: nameDraft ?? this.nameDraft,
    );
  }
}