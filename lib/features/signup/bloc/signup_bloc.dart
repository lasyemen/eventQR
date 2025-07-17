import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(const SignupState()) {
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  Future<void> _onSignupSubmitted(SignupSubmitted event, Emitter<SignupState> emit) async {
    emit(state.copyWith(status: SignupStatus.loading));

    try {
      // Validate Saudi phone number format
      final pattern = r'^(5\d{8})$';
      final regExp = RegExp(pattern);
      
      if (event.name.isEmpty) {
        throw Exception('يرجى إدخال الاسم الكامل');
      }
      
      if (!regExp.hasMatch(event.phone)) {
        throw Exception('أدخل رقم جوال سعودي صحيح (5XXXXXXXX)');
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(
        status: SignupStatus.success,
        name: event.name,
        phone: event.phone,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: SignupStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }
}