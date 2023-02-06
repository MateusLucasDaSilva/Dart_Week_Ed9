import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class AuthModel {
  final String accessToken;
  final String refreshToken;
  AuthModel({
    required this.accessToken,
    required this.refreshToken,
  });
  
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      accessToken: map['access_token'] as String,
      refreshToken: map['refresh_token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthModel.fromJson(String source) => AuthModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
