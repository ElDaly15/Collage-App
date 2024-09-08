part of 'get_attendens_history_data_cubit.dart';

@immutable
sealed class GetAttendensHistoryDataState {}

final class GetAttendensHistoryDataInitial
    extends GetAttendensHistoryDataState {}

final class GetAttendensHistoryDataSucceess
    extends GetAttendensHistoryDataState {}

final class GetAttendensHistoryDataFailuer
    extends GetAttendensHistoryDataState {}

final class GetAttendensHistoryDataLoading
    extends GetAttendensHistoryDataState {}
