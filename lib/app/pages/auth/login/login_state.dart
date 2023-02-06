// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:match/match.dart';

part 'login_state.g.dart';

@match
enum LoginStatus {
  initial,
  login,
  success,
  loginError,
  error,
}

class LoginState extends Equatable {
  final LoginStatus status;
  final String? errorMesseger;

  const LoginState({
    required this.status,
    this.errorMesseger,
  });

  const LoginState.initial()
      : status = LoginStatus.initial,
        errorMesseger = null;

  @override
  List<Object?> get props => [status, errorMesseger];

  LoginState copyWith({
    LoginStatus? status,
    String? errorMesseger,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMesseger: errorMesseger ?? this.errorMesseger,
    );
  }
}
