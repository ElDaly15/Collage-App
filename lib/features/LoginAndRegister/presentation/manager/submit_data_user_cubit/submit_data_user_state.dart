part of 'submit_data_user_cubit.dart';

@immutable
sealed class SubmitDataUserState {}

final class SubmitDataUserInitial extends SubmitDataUserState {}

final class SubmitDataUserSuccess extends SubmitDataUserState {}

final class SubmitDataUserFailuer extends SubmitDataUserState {
  final String error;

  SubmitDataUserFailuer({required this.error});
}

final class SubmitDataUserLoading extends SubmitDataUserState {}
