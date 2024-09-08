part of 'delete_history_of_student_attendens_cubit.dart';

@immutable
sealed class DeleteHistoryOfStudentAttendensState {}

final class DeleteHistoryOfStudentAttendensInitial
    extends DeleteHistoryOfStudentAttendensState {}

final class DeleteHistoryOfStudentAttendensSuccess
    extends DeleteHistoryOfStudentAttendensState {}

final class DeleteHistoryOfStudentAttendensFailuer
    extends DeleteHistoryOfStudentAttendensState {}

final class DeleteHistoryOfStudentAttendensLoading
    extends DeleteHistoryOfStudentAttendensState {}
