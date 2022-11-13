// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:upload_encoded_image/response.dart';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;

class UploadService {
  final dio = Dio();

  String token =
      'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJoZW5yaXNhbnRvczUyQG1pdGFraWFuLmNvbSIsInNjb3BlcyI6IkNPTVBBTlkiLCJpYXQiOjE2NjgyNDU4NjIsImV4cCI6MTY3MzQyOTg2Mn0.5nlNpKBrRBAh84OzpnjDTPDXePEWdL9rArXlTAmndtg';

  final host = Uri.parse(
      'https://api-rosabon.optisoft.com.ng:8090/auth/company/company-document');

  Future<dynamic> picImageFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        final file = File(result.files.single.path!);
        final fileName = file.path.split('/').last;
        debugPrint('selected image: $fileName');
        return file;
      } else {
        debugPrint('cancelled image selection');
      }
    } on PlatformException catch (e) {
      debugPrint('Unsupported operation$e');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // methode for encoding image file to Base64

  String convertTo64(File image) {
    final bytes = image.readAsBytesSync();

    String img64 = base64Encode(bytes);

    String convertedImage = img64.substring(0, 100);

    debugPrint('$convertedImage is in base64');

    return img64;
  }


  Future uploadPhoto(dynamic pickedFile) async {
    final String fileName = pickedFile.path.split('/').last;

    print('$fileName is file name');

    // file
    final formData = FormData.fromMap({
      // "cacImage": {
      //   "encodedUpload": MultipartFile.fromBytes(
      //     convertTo64(pickedFile),
      //     filename: fileName,
      //   ),
      //   "name": fileName,
      // },
      // "certificateOfIncoImage": {
      //   "encodedUpload": MultipartFile.fromBytes(
      //     convertTo64(pickedFile),
      //     filename: fileName,
      //   ),
      //   "name": fileName,
      // },
      // "contactPersonIdNumber": "29384756124",
      // "contactPersonIdentityImage": {
      //   "encodedUpload": MultipartFile.fromBytes(
      //     convertTo64(pickedFile),
      //     filename: fileName,
      //   ),
      //   "name": fileName
      // },
      // "contactPersonPhotographImage": {
      //   "encodedUpload": MultipartFile.fromBytes(
      //     convertTo64(pickedFile),
      //     filename: fileName,
      //   ),
      //   "name": fileName
      // },
      // "idType": "DRIVERS_LICENSE",
      // "moaImage": {
      //   "encodedUpload": MultipartFile.fromBytes(
      //     convertTo64(pickedFile),
      //     filename: fileName,
      //   ),
      //   "name": fileName,
      // },
      // "utilityBillImage": {
      //   "encodedUpload": MultipartFile.fromBytes(
      //     convertTo64(pickedFile),
      //     filename: fileName,
      //   ),
      //   "name": fileName,
      // },

      "cacImage": {
        "encodedUpload": convertTo64(pickedFile),
        "name": fileName,
      },
      "certificateOfIncoImage": {
        "encodedUpload": convertTo64(pickedFile),
        "name": fileName,
      },
      "contactPersonIdNumber": "29384756124",
      "contactPersonIdentityImage": {
        "encodedUpload": convertTo64(pickedFile),
        "name": fileName
      },
      "contactPersonPhotographImage": {
        "encodedUpload": convertTo64(pickedFile),
        "name": fileName
      },
      //"id": 0,
      "idType": "DRIVERS_LICENSE",
      "moaImage": {
        "encodedUpload": convertTo64(pickedFile),
        "name": fileName,
      },
      "utilityBillImage": {
        "encodedUpload": convertTo64(pickedFile),
        "name": fileName,
      },
    });

    return await uploadMthd(
      host,
      data: formData,
      headers: getUserRequestHeader(),
    ).then((value) {
      debugPrint('upload response: $value');
    }).whenComplete(() {
      debugPrint('cloud upload complete');
    });
  }



  Future<dynamic> uploadMthd(
    Uri uri, {
    required FormData data,
    required Map<String, dynamic>? headers,
  }) async {
    debugPrint('Making request to $uri');
    final options = Options(
        headers: headers,
        responseType: ResponseType.plain,
        contentType: Headers.formUrlEncodedContentType);
    try {
      final response = await dio.put(
        uri.toString(),
        data: data,
        options: options,
        onSendProgress: (int sent, int total) {
          debugPrint(
            'sent ${sent.round()} total${total.round()}',
          );
        },
      );

      return UploadResponse.dioResponse(response);
    } on SocketException catch (e) {
      debugPrint(e.toString());

      throw HttpException('$e');
    } on FormatException catch (error) {
      debugPrint('FormatException: $error');
      throw HttpException('Bad response format: $error');
    }
  }

  Map<String, String> getUserRequestHeader() {
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
  }
}
