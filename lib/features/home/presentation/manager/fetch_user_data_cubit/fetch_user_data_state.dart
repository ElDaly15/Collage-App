part of 'fetch_user_data_cubit.dart';

@immutable
sealed class FetchUserDataState {}

final class FetchUserDataInitial extends FetchUserDataState {}

final class FetchUserDataSuccess extends FetchUserDataState {}
