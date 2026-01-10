import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  final String apiKey = "AIzaSyD3Z2RTYiCy6u8r9WcS9x82fRI9r-zqN-Q";

  Future<String> sendMessage(String prompt) async {
    try {
      final model = GenerativeModel(model: 'gemini-flash-latest',
          apiKey: apiKey);
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? "I'm not sure how to answer that.";
    } catch (e)
    {
      return "AI Error: $e";
    }
  }
}