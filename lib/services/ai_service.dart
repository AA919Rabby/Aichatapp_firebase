import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {

  final String apiKey = 'Enter you api key';

  Future<String> sendMessage(String prompt) async {
    try {
      final model = GenerativeModel(

        model: 'Enter your model name',
        apiKey: apiKey,
      );
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? "I'm not sure how to answer that.";
    } catch (e) {
      return "AI Error: $e";
    }
  }
}