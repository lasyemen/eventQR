import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../models/event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Events
abstract class PersonalEventEvent extends Equatable {
  const PersonalEventEvent();
  @override
  List<Object?> get props => [];
}

class CreatePersonalEventRequested extends PersonalEventEvent {
  final EventModel event;
  const CreatePersonalEventRequested(this.event);
  @override
  List<Object?> get props => [event];
}

// States
abstract class PersonalEventState extends Equatable {
  const PersonalEventState();
  @override
  List<Object?> get props => [];
}

class PersonalEventInitial extends PersonalEventState {}

class PersonalEventLoading extends PersonalEventState {}

class PersonalEventSuccess extends PersonalEventState {}

class PersonalEventFailure extends PersonalEventState {
  final String error;
  const PersonalEventFailure(this.error);
  @override
  List<Object?> get props => [error];
}

// Bloc
class PersonalEventBloc extends Bloc<PersonalEventEvent, PersonalEventState> {
  PersonalEventBloc() : super(PersonalEventInitial()) {
    on<CreatePersonalEventRequested>(_onCreatePersonalEventRequested);
  }

  Future<void> _onCreatePersonalEventRequested(
    CreatePersonalEventRequested event,
    Emitter<PersonalEventState> emit,
  ) async {
    emit(PersonalEventLoading());
    try {
      await Supabase.instance.client
          .from('events')
          .insert(event.event.toJson())
          .select();
      emit(PersonalEventSuccess());
    } catch (e) {
      emit(PersonalEventFailure(e.toString()));
    }
  }
}
