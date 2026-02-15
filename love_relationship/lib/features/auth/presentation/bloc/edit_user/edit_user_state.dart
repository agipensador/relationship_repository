import 'package:equatable/equatable.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';

class EditUserState extends Equatable {
  final bool loading;
  final Failure? error;
  final UserEntity? current;
  final String? nameDraft;
  final bool saveSuccess;

  const EditUserState({
    this.loading = false,
    this.error,
    this.current,
    this.nameDraft = '',
    this.saveSuccess = false,
  });

  factory EditUserState.initial() => const EditUserState();

  EditUserState copyWith({
    bool? loading,
    Failure? error,
    UserEntity? current,
    String? nameDraft,
    bool? saveSuccess,
  }) {
    return EditUserState(
      loading: loading ?? this.loading,
      error: error,
      current: current ?? this.current,
      nameDraft: nameDraft ?? this.nameDraft,
      saveSuccess: saveSuccess ?? this.saveSuccess,
    );
  }

  @override
  List<Object?> get props => [loading, error, current, nameDraft, saveSuccess];
}
