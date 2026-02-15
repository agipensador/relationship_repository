import 'package:equatable/equatable.dart';

sealed class EditUserEvent extends Equatable {
  const EditUserEvent();

  @override
  List<Object?> get props => [];
}

final class EditUserLoad extends EditUserEvent {
  const EditUserLoad();
}

final class EditUserNameChanged extends EditUserEvent {
  final String name;

  const EditUserNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

final class EditUserSave extends EditUserEvent {
  const EditUserSave();
}

final class EditUserClearSaveSuccess extends EditUserEvent {
  const EditUserClearSaveSuccess();
}
