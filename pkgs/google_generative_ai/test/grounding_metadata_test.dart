import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:test/test.dart';

void main() {
  group('GroundingMetadata live API test', () {
    late GenerativeModel model;
    late String apiKey;

    setUp(() {
      apiKey = File('API_KEY.txt').readAsStringSync();
      if (apiKey.isEmpty) {
        throw Exception(
            'API key is empty. Please provide a valid API key in API_KEY.txt.');
      }
      model = GenerativeModel(
        model: 'gemini-2.5-flash-lite-preview-06-17',
        apiKey: apiKey,
        tools: [Tool(googleSearch: GoogleSearch())],
      );
    });

    test('should receive and correctly parse grounding metadata', () async {
      final response = await model.generateContent([
        Content.text('What is the capital of France?'),
      ]);

      print('AAA: ${response.groundingMetadata}');
      expect(response.groundingMetadata, isNotNull);
      final groundingMetadata = response.groundingMetadata!;

      // Verify serialization and deserialization
      final json = groundingMetadata.toJson();
      final decoded = GroundingMetadata.fromJson(json);

      expect(decoded.webSearchQueries, groundingMetadata.webSearchQueries);
      expect(decoded.searchEntryPoint, groundingMetadata.searchEntryPoint);
      expect(decoded.groundingChunks.length,
          groundingMetadata.groundingChunks.length);
      expect(decoded.groundingSupports.length,
          groundingMetadata.groundingSupports.length);

      // Further checks for content if available
      if (groundingMetadata.webSearchQueries.isNotEmpty) {
        expect(groundingMetadata.webSearchQueries.first, isNotEmpty);
      }
      if (groundingMetadata.groundingChunks.isNotEmpty) {
        expect(groundingMetadata.groundingChunks.first.uri, isNotNull);
        expect(groundingMetadata.groundingChunks.first.title, isNotNull);
      }
    });
  });
}
