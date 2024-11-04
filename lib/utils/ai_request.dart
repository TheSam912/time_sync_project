import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/ProgramModel.dart';

Future<ProgramModel?> fetchRoutinePlan({
  required String apiKey,
  required String fixedCommitments,
  required String goals,
  required String dietPreferences,
  required String challenges,
  required String additionalPreferences,
}) async {
  const String url = 'https://api.openai.com/v1/chat/completions';

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  final prompt = '''
Create a detailed daily routine plan based on the following information:
- Fixed commitments: $fixedCommitments
- Goals: $goals
- Diet preferences: $dietPreferences
- Main challenges: $challenges
- Additional preferences: $additionalPreferences

Format the response strictly as a JSON object with the following structure:

{
  "title": "Descriptive title of the program",
  "description": "A paragraph summary of the program's purpose, without line breaks or special characters.",
  "category": "Overall theme or category of the program (e.g., Balanced, Night Owl, Fitness Focused)",
  "sliceItems": [
    {
      "sliceTitle": "Focus area name (e.g., Productivity, Exercise, Mental Health)",
      "sliceValue": "Percentage of focus in the program as an integer (0-100)",
      "_id": "Unique identifier for each slice item"
    }
  ],
  "author": "TimeSync AI",
  "points": [
    "Brief points summarizing key objectives of this program in a single line, e.g., 'Enhanced Productivity', 'Consistent Work Sessions'"
  ],
  "routineItems": [
    {
      "title": "Title of the activity (e.g., Wake Up Early) in a single line",
      "description": "A paragraph description with no line breaks or special characters.",
      "time": "Time range in the format 'HH:MM - HH:MM AM/PM' (e.g., '5:00 - 7:00 AM')",
      "isDone": false,
      "_id": "Unique identifier for each routine item"
    }
  ],
  "updatedAt": "Timestamp in ISO format"
}

Guidelines:
1. Ensure JSON output is **strictly JSON-compliant** with no line breaks, unescaped characters.**.
2. Provide **specific meal suggestions** for breakfast, lunch, and dinner, following dietary preferences.
3. Format descriptions and points as concise, single-line strings only.
4. Ensure each slice item has a relevant **percentage focus area** and each routine item has a **time range** and short **single-line description**.
  ''';

  final body = jsonEncode({
    "model": "gpt-3.5-turbo",
    "messages": [
      {"role": "user", "content": prompt}
    ],
    "max_tokens": 1000,
    "temperature": 0.7,
  });

  try {
    final response = await http
        .post(
          Uri.parse(url),
          headers: headers,
          body: body,
        )
        .timeout(const Duration(seconds: 30));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final messageContent = data['choices'][0]['message']['content'];
      Map<String, dynamic> jsonResponse = {};

      try {
        jsonResponse = jsonDecode(messageContent);
      } catch (e) {
        print("Error decoding message content as JSON: $e");
        return null;
      }
      return ProgramModel.fromJson(jsonResponse);
    } else {
      print("Failed to fetch routine plan: ${response.body}");
      return null;
    }
  } catch (e) {
    print("Error fetching routine plan: $e");
    return null;
  }
}

String sanitizeJson(String jsonString) {
  jsonString = jsonString.trim();
  jsonString = jsonString.replaceAll(RegExp(r'\\\"'), '\"');
  jsonString = jsonString.replaceAll(RegExp(r'\"'), '"');
  return jsonString;
}
