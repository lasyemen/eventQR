import 'package:equatable/equatable.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {}

class EventError extends EventState {
  final String error;

  const EventError(this.error);

  @override
  List<Object> get props => [error];
}
