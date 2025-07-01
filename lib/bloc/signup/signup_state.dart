import 'package:equatable/equatable.dart';

enum SignupStatus { initial, loading, success, failure }

class SignupState extends Equatable {
  final SignupStatus status;
  final String? errorMessage;
  final String name;
  final String phone;

  const SignupState({
    this.status = SignupStatus.initial,
    this.errorMessage,
    this.name = '',
    this.phone = '',
  });

  SignupState copyWith({
    SignupStatus? status,
    String? errorMessage,
    String? name,
    String? phone,
  }) {
    return SignupState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, name, phone];
}