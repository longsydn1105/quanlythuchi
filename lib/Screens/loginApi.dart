import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List> login({
  String? email,
  String? password,
}) async {
  int? statusCode;
  String? responseBody;
  try {
    http.Response response = await http.post(
        Uri.parse(
            'https://thawing-reef-30756.herokuapp.com/api/student_info/login.php'),
        body: jsonEncode({'email': email, 'password': password}));

    statusCode = response.statusCode;
    responseBody = response.body.toString();
  } catch (e) {
    print(e.toString());
  }

  return [statusCode, responseBody];
}


// void login({
//   String? email,
//   String? password,
// }) async {
//   try {
//     http.Response response = await http.post(
//         Uri.parse(
//             'https://thawing-reef-30756.herokuapp.com/api/student_info/login.php'),
//         body: jsonEncode({'email': email, 'password': password}));

//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body.toString());
//       print(data);
//       print('Login successfully');
//     } else {
//       print('failed');
//     }
//   } catch (e) {
//     print(e.toString());
//   }
// }

// import 'dart:async';
// import 'dart:convert';

// import 'package:http/http.dart' as http;

// Future<Login> login(String email, String password) async {
//   final response = await http.post(
//       Uri.parse(
//           'https://thawing-reef-30756.herokuapp.com/api/student_info/login.php'),
//       headers: <String, String>{'Content-Type': 'application/json'},
//       body: jsonEncode(<String, String>{'email': email, 'password': password}));
//   if (response.statusCode == 200) {
//     print(response.body.toString());
//     return Login.fromJson(json.decode(response.body));
//   } else {
//     throw Exception('Unable to login');
//   }
// }

// class Login {
//   final int? success;
//   final String? message;
//   final int? status;

//   const Login(
//       {required this.message, required this.success, required this.status});

//   factory Login.fromJson(Map<String, dynamic> json) {
//     return Login(
//       message: json['message'] as String?,
//       success: json['success'] as int?,
//       status: json['status'] as int?,
//     );
//   }
// }
