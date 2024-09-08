part of 'get_verify_request_cubit.dart';

@immutable
sealed class GetVerifyRequestState {}

final class GetVerifyRequestInitial extends GetVerifyRequestState {}

final class GetVerifyRequestSuccess extends GetVerifyRequestState {}

final class GetVerifyRequestFailuer extends GetVerifyRequestState {}

final class GetVerifyRequestLoading extends GetVerifyRequestState {}
