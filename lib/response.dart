import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class UploadResponse {
  static dynamic dioResponse(Response response) async {
    switch (response.statusCode) {
      case 200:

        ///* This is a catch block for when the server returns a 200 ok status.
        debugPrint(response.statusCode.toString());
        debugPrint(response.data);
        return response.data;
      case 201:

        ///* This is a catch block for when the server returns a 201 created status.
        debugPrint(response.statusCode.toString());
        debugPrint(response.data);
        return response.data;
      case 400:

        ///* This is a catch block for when the server returns a 400 bad request status.
        debugPrint(response.statusCode.toString());
        throw Exception(response.data);
      case 401:

        ///* This is a catch block for when the server returns a 401 unauthorised error.
        debugPrint(response.statusCode.toString());
        throw Exception(response.data);

      case 403:

        ///* This is a catch block for when the server returns a 403 unauthorised error.
        debugPrint(response.statusCode.toString());
        throw Exception(response.data);

      case 405:

        ///* This is a catch block for when the server returns a 403 unauthorised error.
        debugPrint(response.statusCode.toString());
        throw Exception(response.data);

      case 415:

        ///* This is a catch block for when the server returns a 403 unauthorised error.
        debugPrint(response.statusCode.toString());
        throw Exception(response.data);

      case 500:
      default:
        throw Exception(
          'Error occured while Communication with Server with StatusCode: ${response.statusCode}',
        );
    }
  }
}
