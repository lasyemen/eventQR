import 'package:equatable/equatable.dart';
import '../models/company_event_model.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class LoadEvents extends EventEvent {}

class CreateCompanyEventRequested extends EventEvent {
  final CompanyEvent companyEvent;
  const CreateCompanyEventRequested(this.companyEvent);

  @override
  List<Object> get props => [companyEvent];
}
