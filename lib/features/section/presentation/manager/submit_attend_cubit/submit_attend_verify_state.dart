part of 'submit_attend_verify_cubit.dart';

@immutable
sealed class SubmitAttendVerifyState {}

final class SubmitAttendVerifyInitial extends SubmitAttendVerifyState {}

final class SubmitAttendVerifySuccess extends SubmitAttendVerifyState {}

final class SubmitAttendVerifyFailuer extends SubmitAttendVerifyState {}

final class SubmitAttendVerifyLoading extends SubmitAttendVerifyState {}
