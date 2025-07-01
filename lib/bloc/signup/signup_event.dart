import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupSubmitted extends SignupEvent {
  final String name;
  final String phone;

  const SignupSubmitted({required this.name, required this.phone});

  @override
  List<Object> get props => [name, phone];
}
