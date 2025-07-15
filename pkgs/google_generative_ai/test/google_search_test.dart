// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_generative_ai/src/function_calling.dart';
import 'package:google_generative_ai/src/model.dart';
import 'package:test/test.dart';

import 'utils/matchers.dart';
import 'utils/stub_client.dart';

void main() {
  group('GenerativeModel with googleSearch tool', () {
    const defaultModelName = 'some-model';

    (ClientController, GenerativeModel) createModel({
      String modelName = defaultModelName,
      List<Tool>? tools,
    }) {
      final client = ClientController();
      final model = createModelWithClient(
        model: modelName,
        client: client.client,
        tools: tools,
      );
      return (client, model);
    }

    test('returns grounding metadata when googleSearch is used', () async {
      final (client, model) =
          createModel(tools: [Tool(googleSearch: GoogleSearch())]);
      final prompt = 'Why is the sky blue?';
      final response = await client.checkRequest(
        () => model.generateContent([Content.text(prompt)]),
        response: {
          'candidates': [
            {
              'content': {
                'role': 'model',
                'parts': [
                  {'text': 'The sky is blue due to Rayleigh scattering.'}
                ],
              },
              'groundingMetadata': {
                'groundingMetadata': {
                  'webSearchQueries': ['why is the sky blue'],
                  'groundingChunks': [
                    {
                      'uri': 'https://en.wikipedia.org/wiki/Rayleigh_scattering',
                      'title': 'Rayleigh scattering - Wikipedia'
                    }
                  ]
                }
              }
            }
          ],
        },
      );

      final groundingMetadata = response.candidates.first.groundingMetadata;
      expect(groundingMetadata, isNotNull);
      expect(groundingMetadata!.webSearchQueries, equals(['why is the sky blue']));
      expect(groundingMetadata.groundingChunks, hasLength(1));
      final chunk = groundingMetadata.groundingChunks.first;
      expect(chunk.uri.toString(),
          equals('https://en.wikipedia.org/wiki/Rayleigh_scattering'));
      expect(chunk.title, equals('Rayleigh scattering - Wikipedia'));

      print('Snippet: ${response.text}');
      print('Sources:');
      for (final chunk in groundingMetadata.groundingChunks) {
        print('- ${chunk.title}: ${chunk.uri}');
      }
    });
  });
}