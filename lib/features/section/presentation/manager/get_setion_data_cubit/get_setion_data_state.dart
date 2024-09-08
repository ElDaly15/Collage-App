part of 'get_setion_data_cubit.dart';

@immutable
sealed class GetSetionDataState {}

final class GetSetionDataInitial extends GetSetionDataState {}

final class GetSetionDataSuccess extends GetSetionDataState {}

final class GetSetionDataLoading extends GetSetionDataState {}

final class GetSetionDataFailuer extends GetSetionDataState {}
