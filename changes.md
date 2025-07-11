# Changes Made to `google_generative_ai` Package

This document summarizes the changes made to the `google_generative_ai` package to bring it closer to feature parity with the `firebase_vertexai` package, based on the Gemini API capabilities.

## Implemented Features:

1.  **Enhanced Content Part Handling:**
    *   **`pkgs/google_generative_ai/lib/src/content.dart`:**
        *   Renamed `DataPart` to `InlineDataPart` for clarity and consistency with API terminology.
        *   Modified `_parsePart` to correctly parse `FunctionResponse`, `InlineDataPart`, and `FileData` objects from the model's response. Previously, these were either unimplemented or missing.
        *   Updated `Content.data` static method to use `InlineDataPart`.
        *   Introduced `FileData` class to represent file data with `mimeType` and `fileUri` (similar to `FilePart` but with explicit `mimeType`).

2.  **Advanced Generation Configuration Options:**
    *   **`pkgs/google_generative_ai/lib/src/api.dart`:**
        *   Added `presencePenalty` and `frequencyPenalty` parameters to the `GenerationConfig` class, allowing finer control over token repetition in generated content.
        *   Updated `GenerationConfig.toJson()` to include serialization of `presencePenalty` and `frequencyPenalty`.

3.  **Improved Safety Settings:**
    *   **`pkgs/google_generative_ai/lib/src/api.dart`:**
        *   Added `method` parameter (of type `HarmBlockMethod`) to the `SafetySetting` class, enabling specification of whether safety blocking is based on probability or severity.
        *   Introduced the `HarmBlockMethod` enum with `unspecified`, `probability`, and `severity` values.
        *   Updated `SafetySetting.toJson()` to include serialization of the `method`.

4.  **Detailed Token Usage Metrics:**
    *   **`pkgs/google_generative_ai/lib/src/api.dart`:**
        *   Added `promptTokensDetails` and `candidatesTokensDetails` to the `UsageMetadata` class, providing granular token counts broken down by content modality.
        *   Introduced the `ModalityTokenCount` class to represent token counts for a specific content modality.
        *   Added the `ContentModality` enum with values like `unspecified`, `text`, `image`, `video`, `audio`, and `document`.
        *   Updated `_parseUsageMetadata` to correctly parse `promptTokensDetails` and `candidatesTokensDetails`.
        *   Updated `parseCountTokensResponse` to parse `promptTokensDetails`.
        *   Added `_parseModalityTokenCount` helper function for parsing `ModalityTokenCount` objects.

5.  **Response Modalities for Multimodal Output:**
    *   **`pkgs/google_generative_ai/lib/src/api.dart`:**
        *   Introduced the `ResponseModalities` enum with `unspecified`, `text`, `image`, and `audio` values, allowing users to specify desired output types from the model.
        *   Added `responseModalities` parameter to `GenerationConfig`.
        *   Updated `GenerationConfig.toJson()` to include serialization of `responseModalities`.
    *   **`pkgs/google_generative_ai/lib/src/model.dart`:**
        *   Updated `_generateContentRequest`, `generateContent`, and `generateContentStream` methods to accept `responseModalities`.

6.  **Updated Citation Structure:**
    *   **`pkgs/google_generative_ai/lib/src/api.dart`:**
        *   Renamed `CitationSource` to `Citation` and updated its usage within `CitationMetadata` to align with the `firebase_vertexai` package's structure.
        *   Updated parsing logic (`_parseCitationMetadata` and `_parseCitation`) to reflect this change.

## Export File Updates:

*   **`pkgs/google_generative_ai/lib/google_generative_ai.dart`:**
    *   Updated export statements to reflect the renaming of `DataPart` to `InlineDataPart` and `FilePart` to `FileData`.
    *   Added exports for newly introduced enums and classes: `HarmBlockMethod`, `ResponseModalities`, `ModalityTokenCount`, and `ContentModality`.
    *   Updated export for `Citation` instead of `CitationSource`.
