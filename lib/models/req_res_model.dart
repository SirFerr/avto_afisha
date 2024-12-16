class ReqRes {
  final int statusCode;
  final String? error;
  final String? message;
  final String? token;
  final String? refreshToken;
  final String? expirationTime;
  final String? name;
  final String? email;
  final String? role;
  final String? password;

  ReqRes({
    required this.statusCode,
    this.error,
    this.message,
    this.token,
    this.refreshToken,
    this.expirationTime,
    this.name,
    this.email,
    this.role,
    this.password,
  });

  factory ReqRes.fromJson(Map<String, dynamic> json) {
    return ReqRes(
      statusCode: json['statusCode'],
      error: json['error'],
      message: json['message'],
      token: json['token'],
      refreshToken: json['refreshToken'],
      expirationTime: json['expirationTime'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'error': error,
      'message': message,
      'token': token,
      'refreshToken': refreshToken,
      'expirationTime': expirationTime,
      'name': name,
      'email': email,
      'role': role,
      'password': password,
    };
  }
}
