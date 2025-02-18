import 'package:audibrain/models/nmt_tts_pipeline_model.dart';
import 'package:audibrain/services/api_endpoints.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

DotEnv dotEnv = DotEnv();

class MyApiService {
  static String BHASHINI_API_VALUE = dotenv.get('BHASHINI_API_VALUE');
  static String BHASHINI_API_KEY = dotenv.get('BHASHINI_API_KEY');
  static String BHASHINI_USER_ID = dotEnv.get('BHASHINI_USER_ID');

  static const String baseUrl = 'https://dhruva-api.bhashini.gov.in';

  static const String ulcaBaseUrl = 'https://meity-auth.ulcacontrib.org';
  static const String pipelineId = '64392f96daac500b55c543cd';

  // Headers for Bhashini API
  static Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': BHASHINI_API_KEY,
      'x-api-key': BHASHINI_API_VALUE,
      'userID': BHASHINI_USER_ID,
    };
  }

  // Fetch NmtTtsModel data from Bhashini API
  static Future<NmtTtsModel> fetchNmtTtsData({
    required String sourceLanguage,
    required String targetLanguage,
    required String inputText,
  }) async {
    final url = Uri.parse('$baseUrl/${ApiEndpoints.nmtTtsEndpoint}');

    final body = {
      "pipelineTasks": [
        {
          "taskType": "translation",
          "config": {
            "language": {
              "sourceLanguage": sourceLanguage,
              "targetLanguage": targetLanguage,
            },
            "serviceId": "ai4bharat/indictrans-v2-all-gpu--t4",
          },
        },
        {
          "taskType": "tts",
          "config": {
            "language": {
              "sourceLanguage": sourceLanguage,
            },
            "serviceId": "ai4bharat/indic-tts-coqui-indo_aryan-gpu--t4",
            "gender": "female",
            "samplingRate": 8000
          },
        },
      ],
      "inputData": {
        "input": [
          {
            "source": inputText,
          },
        ],
      },
    };

    final response = await http.post(
      url,
      headers: getHeaders(),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('API response: ${response.body}');
      return NmtTtsModel.fromJson(json.decode(response.body));
    } else {
      print('API response: ${response.body}');
      throw Exception(
          'Failed to fetch NmtTtsModel data: ${response.statusCode}');
    }
  }

  // Post NmtTtsModel data to Bhashini API
  static Future<NmtTtsModel> postNmtTtsData(NmtTtsModel nmtTtsModel) async {
    final url = Uri.parse('$baseUrl/${ApiEndpoints.nmtTtsEndpoint}');

    final response = await http.post(
      url,
      headers: getHeaders(),
      body: jsonEncode(nmtTtsModel.toJson()),
    );

    if (response.statusCode == 200) {
      print('API response: ${response.body}');
      return NmtTtsModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print('API response: ${response.body}');
      throw Exception(
        'Failed to fetch NmtTtsModel data: ${response.statusCode}',
      );
    }
  }
}
