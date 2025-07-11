# Features to port from `firebase_vertexai` to `google_generative_ai`

This document lists important Gemini AI-related features found in the `firebase_vertexai` package that are currently missing or less developed in the `google_generative_ai` package. These features should be considered for implementation in `google_generative_ai` to bring it up to parity.

## Core Gemini AI Features:

*   **Live API Audio Streaming / Live Streaming Feature:**
    *   Enables real-time, bidirectional streaming with the Gemini model, including audio input and audio/text output. This is a significant advancement for interactive applications.
    *   (Referenced in `firebase_vertexai/CHANGELOG.md` versions 1.8.0, 1.5.0, and demonstrated in `example/lib/pages/bidi_page.dart`).
    *   **Technical Details:** Involves new `LiveGenerativeModel`, `LiveGenerationConfig`, `SpeechConfig`, and `LiveSession` classes, along with `LiveServerMessage`, `LiveServerContent`, `LiveServerToolCall`, `LiveServerToolCallCancellation`, and `LiveServerResponse` for handling streaming responses. It also uses `InlineDataPart` for audio chunks.

*   **Imagen Support:**
    *   Integration with the Imagen model for image generation capabilities. This allows for direct image creation based on text prompts.
    *   (Referenced in `firebase_vertexai/CHANGELOG.md` version 1.4.0, and demonstrated in `example/lib/pages/imagen_page.dart`).
    *   **Technical Details:** Requires new `ImagenModel` class, `ImagenInlineImage`, `ImagenGCSImage`, `ImagenGenerationConfig`, `ImagenSafetySettings`, `ImagenAspectRatio`, `ImagenFormat`, `ImagenSafetyFilterLevel`, and `ImagenPersonFilterLevel` classes.

*   **Repetition Penalties in GenerationConfig:**
    *   Adds `presencePenalty` and `frequencyPenalty` parameters to `GenerationConfig`, offering finer control over the generated content's originality and diversity by penalizing repeated tokens or phrases.
    *   (Referenced in `firebase_vertexai/CHANGELOG.md` version 1.5.0, and observed in `firebase_vertexai/test/model_test.dart`).

*   **HarmBlockMethod in SafetySetting:**
    *   Introduces `HarmBlockMethod` to `SafetySetting`, allowing specification of whether safety blocking should be based on `probability` or `severity` of harmful content.
    *   (Referenced in `firebase_vertexai/CHANGELOG.md` version 1.5.0, and observed in `firebase_vertexai/test/chat_test.dart`, `firebase_vertexai/test/model_test.dart`).
    *   **Technical Details:** Involves new `HarmBlockMethod` and `HarmSeverity` enums.

*   **Enhanced Content Modality Support (beyond basic text/image):**
    *   More explicit and potentially broader support for various content modalities, including document and video processing, as demonstrated in examples.
    *   (Referenced in `firebase_vertexai/CHANGELOG.md` version 1.5.0, and demonstrated in `example/lib/pages/document.dart`, `example/lib/pages/video_page.dart`).
    *   **Technical Details:** This would involve extending the `Part` hierarchy to include specific types for document and video data (e.g., `FileData` with `mimeType` for GCS URIs), and updating content parsing logic.

*   **Detailed Token-Based Usage Metrics:**
    *   Provides more granular token usage details in `CountTokensResponse` and `GenerateContentResponse`, including `promptTokensDetails` and `candidatesTokensDetails` broken down by modality.
    *   (Referenced in `firebase_vertexai/CHANGELOG.md` version 1.3.0, and observed in `firebase_vertexai/test/api_test.dart`, `firebase_vertexai/test/response_parsing_test.dart`).
    *   **Technical Details:** Involves new `ModalityTokenCount` class and updates to `UsageMetadata`.

*   **Image Response in Chat:**
    *   Ability to receive image responses directly within a chat session, enhancing multimodal conversational experiences.
    *   (Demonstrated in `example/lib/pages/chat_page.dart`).
    *   **Technical Details:** Requires handling `ResponseModalities.image` in `GenerationConfig` and parsing image data from the model's response.

## Schema and Function Calling Enhancements:

*   **Extended Schema Properties:**
    *   The `Schema` class includes additional properties like `title`, `minimum`, `maximum`, and `propertyOrdering` for more comprehensive and precise schema definitions.
    *   (Observed in `firebase_vertexai/test/schema_test.dart`).

*   **Schema.anyOf Support:**
    *   Adds support for `anyOf` in schema definitions, allowing for more flexible and complex data structures where a value can conform to one of several schemas.
    *   (Observed in `firebase_vertexai/test/schema_test.dart`).

## New Content Objects/Parts in `firebase_vertexai` (not in `google_generative_ai`):

*   `Citation` (used within `CitationMetadata` for source attribution)
*   `ModalityTokenCount` (provides token counts broken down by content modality)
*   `ResponseModalities` (enum for specifying desired output types from the model)
*   `ImagenInlineImage`, `ImagenGCSImage`, `ImagenGenerationConfig`, `ImagenSafetySettings`, `ImagenAspectRatio`, `ImagenFormat`, `ImagenSafetyFilterLevel`, `ImagenPersonFilterLevel` (all related to Imagen image generation)
*   `LiveGenerativeModel`, `LiveGenerationConfig`, `SpeechConfig`, `LiveServerMessage`, `LiveServerContent`, `LiveServerToolCall`, `LiveServerToolCallCancellation`, `LiveServerResponse`, `LiveSession` (all related to Live API streaming)
*   `HarmBlockMethod` (for safety settings)
*   `HarmSeverity` (for safety ratings)
*   `FileData` (a more complete file data part including mime type, compared to `FilePart` in `google_generative_ai`)

## Features from Gemini API REST API that CAN be added to `google_generative_ai`:

Based on the Gemini API REST API documentation (`https://ai.google.dev/gemini-api/reference`), the following features are supported and could be integrated into `google_generative_ai` to enhance its capabilities:

*   **Live API Audio Streaming:** The Gemini API supports real-time, bidirectional streaming, which aligns with the `Live API Audio Streaming` feature in `firebase_vertexai`.
*   **Image Generation (Imagen):** The Gemini API includes capabilities for image generation, which corresponds to the `Imagen Support` found in `firebase_vertexai`.
*   **Repetition Penalties:** The REST API allows for `presencePenalty` and `frequencyPenalty` parameters in generation configurations.
*   **HarmBlockMethod and HarmSeverity:** The API provides options for specifying safety blocking methods (probability or severity) and detailed harm severity levels.
*   **Expanded Content Modalities:** The API supports various content types beyond basic text and images, including documents and videos, which can be integrated into the `Part` system.
*   **Detailed Token Usage Metrics:** The API returns granular token usage information, including breakdowns by modality, which can be exposed through `UsageMetadata`.
*   **Image Responses:** The API supports returning image data as part of the model's response, enabling multimodal output.
*   **Extended Schema Properties:** The API's function calling capabilities leverage comprehensive schema definitions, including properties like `title`, `minimum`, `maximum`, and `propertyOrdering`.
*   **Schema.anyOf Support:** The API's schema definitions support `anyOf` for more flexible function calling arguments.

## Features likely exclusive to Firebase Vertex AI service:

*   **Firebase Authentication Integration:** This is a Firebase-specific authentication mechanism and is not directly applicable to a general Gemini API client using API keys.
*   **Specific Firebase Project/Location Paths:** The API endpoints used by `firebase_vertexai` often include Firebase project and location identifiers (`projects/{project_id}/locations/{location_id}/publishers/google/models/...`). While the underlying Gemini models are the same, the routing and management through Firebase's infrastructure are distinct from direct API key usage.