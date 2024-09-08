part of 'get_admin_for_check_cubit.dart';

sealed class GetAdminForCheckState {}

final class GetAdminForCheckInitial extends GetAdminForCheckState {}

final class GetAdminForCheckSuccess extends GetAdminForCheckState {}

final class GetAdminForCheckFailuer extends GetAdminForCheckState {}
