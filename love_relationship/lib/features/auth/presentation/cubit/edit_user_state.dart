
import 'package:equatable/equatable.dart';
import 'package:love_relationship/core/error/failure.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';

class EditUserState extends Equatable {
  final bool loading;
  final Failure? error;
  final UserEntity? current;
  final String? nameDraft;

  const EditUserState({this.loading = false, this.error, this.current, this.nameDraft = ''});

  factory EditUserState.initial() => const EditUserState();

  EditUserState copyWith({
    bool? loading,
    Failure? error,
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

  @override
  // TODO: implement props
  List<Object?> get props => [loading, error, current, nameDraft];
}