part of 'get_doctor_data_cubit.dart';

@immutable
sealed class GetDoctorDataState {}

final class GetDoctorDataInitial extends GetDoctorDataState {}

final class GetDoctorDataSuccess extends GetDoctorDataState {}

final class GetDoctorDataLoading extends GetDoctorDataState {}

final class GetDoctorDataFailuer extends GetDoctorDataState {}
