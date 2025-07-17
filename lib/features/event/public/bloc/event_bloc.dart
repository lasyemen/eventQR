import 'package:flutter_bloc/flutter_bloc.dart';
import 'event_event.dart';
import 'event_state.dart';
import '../models/company_event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc() : super(EventInitial()) {
    on<CreateCompanyEventRequested>(_onCreateCompanyEventRequested);
  }

  Future<void> _onCreateCompanyEventRequested(
    CreateCompanyEventRequested event,
    Emitter<EventState> emit,
  ) async {
    emit(EventLoading());
    try {
      await Supabase.instance.client
          .from('company_events')
          .insert(event.companyEvent.toMap())
          .select();
      emit(EventSuccess());
    } catch (e) {
      emit(EventFailure(e.toString()));
    }
  }
}
