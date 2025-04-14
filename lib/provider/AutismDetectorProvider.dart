// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:mlautismdetection/consts/cosnstant.dart';

// class AutismDetectorProvider extends ChangeNotifier {
//   File? _imageFile;
//   Uint8List? _imageBytes;
//   bool _isLoading = false;
//   Map<String, dynamic>? _result;
//   final ImagePicker _picker = ImagePicker();

//   // API endpoint for autism detection

//   File? get imageFile => _imageFile;
//   Uint8List? get imageBytes => _imageBytes;
//   bool get hasImage => _imageBytes != null;
//   bool get isLoading => _isLoading;
//   Map<String, dynamic>? get result => _result;
//   bool get hasResult => _result != null;

//   Future<void> pickImage(ImageSource source) async {
//     try {
//       final pickedImage = await _picker.pickImage(source: source);
//       if (pickedImage == null) return;

//       // Store as file for non-web platforms
//       if (!kIsWeb) {
//         _imageFile = File(pickedImage.path);
//       }

//       // Always store bytes for cross-platform compatibility
//       _imageBytes = await pickedImage.readAsBytes();

//       notifyListeners();
//     } catch (e) {
//       debugPrint('Error picking image: $e');
//     }
//   }

//   Future<void> analyzeImage() async {
//     if (_imageBytes == null) return;

//     try {
//       _isLoading = true;
//       _result = null;
//       notifyListeners();

//       // Create multipart request
//       var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

//       // Add image file/bytes to request
//       if (kIsWeb) {
//         request.files.add(
//           http.MultipartFile.fromBytes(
//             'image',
//             _imageBytes!,
//             filename: 'image.jpg',
//           ),
//         );
//       } else {
//         request.files.add(
//           await http.MultipartFile.fromPath(
//             'image',
//             _imageFile!.path,
//             filename: 'image.jpg',
//           ),
//         );
//       }

//       // Send request
//       var response = await request.send();

//       // Process response
//       if (response.statusCode == 200) {
//         var responseData = await response.stream.bytesToString();
//         _result = json.decode(responseData);
//       } else {
//         _result = {
//           'error':
//               'Failed to analyze image. Status code: ${response.statusCode}',
//         };
//       }
//     } catch (e) {
//       _result = {'error': 'Error analyzing image: $e'};
//       debugPrint('Error analyzing image: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   void resetState() {
//     _imageFile = null;
//     _imageBytes = null;
//     _result = null;
//     notifyListeners();
//   }
// }
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mlautismdetection/consts/cosnstant.dart';

class AutismDetectorProvider extends ChangeNotifier {
  File? _imageFile;
  Uint8List? _imageBytes;
  bool _isLoading = false;
  Map<String, dynamic>? _result;
  final ImagePicker _picker = ImagePicker();

  File? get imageFile => _imageFile;
  Uint8List? get imageBytes => _imageBytes;
  bool get hasImage => _imageBytes != null;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get result => _result;
  bool get hasResult => _result != null;

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedImage = await _picker.pickImage(source: source);
      if (pickedImage == null) return;

      if (!kIsWeb) {
        _imageFile = File(pickedImage.path);
      }

      _imageBytes = await pickedImage.readAsBytes();
      notifyListeners();
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> analyzeImage() async {
    if (_imageBytes == null) return;

    try {
      _isLoading = true;
      _result = null;
      notifyListeners();

      // Fetch the latest API URL
      final currentApiUrl = await fetchApiBaseUrl();
      debugPrint('Using API URL: $currentApiUrl/predict');

      // Fix the URL construction syntax
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$currentApiUrl/predict'),
      );

      if (kIsWeb) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            _imageBytes!,
            filename: 'image.jpg',
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            _imageFile!.path,
            filename: 'image.jpg',
          ),
        );
      }

      var response = await request.send();

      // Read the response body
      var responseBody = await response.stream.bytesToString();
      debugPrint('Response body: $responseBody');

      if (response.statusCode == 200) {
        _result = json.decode(responseBody);
        debugPrint('Parsed JSON: $_result');
      } else {
        _result = {
          'error':
              'Failed to analyze image. Status code: ${response.statusCode}',
        };
        debugPrint('Error: ${_result!['error']}');
      }
    } catch (e) {
      _result = {'error': 'Error analyzing image: $e'};
      debugPrint('Error analyzing image: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetState() {
    _imageFile = null;
    _imageBytes = null;
    _result = null;
    notifyListeners();
  }
}
