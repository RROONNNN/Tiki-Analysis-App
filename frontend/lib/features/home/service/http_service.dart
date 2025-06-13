import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/analysis_model.dart';

class HttpService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<AnalysisModel> getAnalysis(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/comment-analysis/$productId'),
      );

      if (response.statusCode == 200) {
        return AnalysisModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load analysis: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}
