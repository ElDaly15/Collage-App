part of 'get_status_of_container_cubit.dart';

@immutable
sealed class GetStatusOfContainerState {}

final class GetStatusOfContainerInitial extends GetStatusOfContainerState {}

final class GetStatusOfContainerSuccess extends GetStatusOfContainerState {}

final class GetStatusOfContainerFailuer extends GetStatusOfContainerState {}

final class GetStatusOfContainerLoading extends GetStatusOfContainerState {}
