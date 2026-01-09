import 'dart:io';
import 'package:http/http.dart' as http;

class KycRepository {
  final String baseUrl = 'YOUR_API_BASE_URL';

  Future<bool> uploadKycDocument(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/kyc/upload'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'document',
          imageFile.path,
        ),
      );

      // Add headers if needed
      // request.headers['Authorization'] = 'Bearer $token';

      final response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> skipKyc() async {
    // API call to mark KYC as skipped
    try {
      // await http.post(Uri.parse('$baseUrl/kyc/skip'));
    } catch (e) {
      rethrow;
    }
  }
}