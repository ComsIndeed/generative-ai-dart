import 'dart:convert';

import 'package:google_generative_ai/src/api.dart';
import 'package:test/test.dart';

void main() {
  group('GroundingMetadata', () {
    test('serialization and deserialization with full data', () {
      final groundingMetadata = GroundingMetadata(
        webSearchQueries: ['query1', 'query2'],
        searchEntryPoint: {'key': 'value'},
        groundingChunks: [
          GroundingChunk(uriString: 'uri1', title: 'title1'),
          GroundingChunk(uriString: 'uri2', title: 'title2'),
        ],
        groundingSupports: [
          GroundingSupport(
            segment: Segment(0, 5, 'text1'),
            groundingChunkIndices: [0, 1],
          ),
          GroundingSupport(
            segment: Segment(6, 10, 'text2'),
            groundingChunkIndices: [1],
          ),
        ],
      );

      final json = groundingMetadata.toJson();
      final decoded = GroundingMetadata.fromJson(json);

      expect(decoded.webSearchQueries, groundingMetadata.webSearchQueries);
      expect(decoded.searchEntryPoint, groundingMetadata.searchEntryPoint);
      expect(decoded.groundingChunks.length, 2);
      expect(decoded.groundingChunks[0].uri.toString(), 'uri1');
      expect(decoded.groundingSupports.length, 2);
      expect(decoded.groundingSupports[0].segment.text, 'text1');
    });

    test('serialization and deserialization with empty data', () {
      final groundingMetadata = GroundingMetadata(
        webSearchQueries: [],
        searchEntryPoint: {},
        groundingChunks: [],
        groundingSupports: [],
      );

      final json = groundingMetadata.toJson();
      final decoded = GroundingMetadata.fromJson(json);

      expect(decoded.webSearchQueries, []);
      expect(decoded.searchEntryPoint, {});
      expect(decoded.groundingChunks, []);
      expect(decoded.groundingSupports, []);
    });

    test('deserialization from empty map', () {
      final decoded = GroundingMetadata.fromMap({});
      expect(decoded.webSearchQueries, []);
      expect(decoded.searchEntryPoint, {});
      expect(decoded.groundingChunks, []);
      expect(decoded.groundingSupports, []);
    });
  });
}