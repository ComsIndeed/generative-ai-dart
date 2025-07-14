#!/bin/bash
set -e -E

GEMINI_API_KEY="$GEMINI_API_KEY"
MODEL_ID="gemini-2.5-flash-preview-04-17"
GENERATE_CONTENT_API="streamGenerateContent"

cat << EOF > request.json
{
    "contents": [
      {
        "role": "user",
        "parts": [
          {
            "text": "Look up what the current state of politics is in the Philippines"
          },
        ]
      },
      {
        "role": "model",
        "parts": [
          {
            "text": "The political landscape in the Philippines is currently dynamic and complex, marked by several key factors:\n\n**1. A Multi-Party System and Political Families:** The Philippines operates under a multi-party system with a wide array of political parties. However, political power is often concentrated within powerful families and alliances, leading to a political environment where individual personalities and family influence can be more significant than party platforms. This often results in fluid party loyalties, with politicians frequently switching affiliations to align with the sitting president's party.\n\n**2. The Marcos-Duterte Dynamic:** A significant aspect of the current political climate is the evolving relationship between the administration of President Ferdinand \"Bongbong\" Marcos Jr. and the faction led by Vice President Sara Duterte. What began as an electoral alliance (\"UniTeam\") in 2022 has reportedly transformed into a power struggle with differing economic and policy priorities. This rivalry has intensified, with political maneuvering and disputes threatening institutional stability.\n\n**3. Midterm Elections and Future Implications:** The May 2025 midterm elections were seen as crucial for shaping the country's immediate political future and are viewed as a bellwether for the 2028 presidential elections. The results of these elections, particularly for the Senate seats, are expected to have lasting effects on policy continuity and political stability. The midterm elections also saw the ongoing political feud between the Marcos and Duterte camps play out, with implications for the political future of both families.\n\n**4. Key Political Issues:** Several pressing issues continue to shape the political discourse. These include:\n* **Economic Policies:** The Marcos administration has focused on infrastructure-driven economic growth and attracting foreign investment, while the Duterte faction has leaned towards more populist measures and protectionist policies.\n* **Corruption:** Corruption remains a significant concern, with anticorruption bodies facing challenges in upholding their mandates.\n* **Human Rights and Rule of Law:** While there have been some reported decreases in violence and impunity since 2022, concerns remain regarding abuses by police and military, as well as practices like \"red-tagging\" of government critics. Congressional hearings have continued to investigate human rights abuses linked to the previous administration's \"war on drugs\".\n* **South China Sea:** Geopolitical tensions, particularly in the South China Sea, are a key foreign policy issue that also has domestic political implications.\n* **Social Issues:** Proposed legislation on matters like divorce and discrimination based on sexual orientation, gender identity, and sex characteristics are also part of the political agenda.\n* **Budgetary Allocations:** Issues surrounding the national budget, including cuts to social programs and increased allocations for infrastructure and financial aid potentially serving political interests, have also been raised.\n\n**5. Democratic Institutions and Challenges:** While the Philippines has a democratic system with regular elections, it faces challenges such as the influence of political elites, disinformation campaigns, and vote buying which can undermine fair competition. State institutions are considered relatively weak, and despite strong public support for democracy and high voter turnout, there is a perception of a democracy that is slowly being eroded.\n\nOverall, the political state of the Philippines is characterized by a vibrant but complex multi-party system heavily influenced by political families and alliances. The ongoing power dynamics between the current administration and the Vice President's faction, coupled with key political and social issues, continue to shape the country's political landscape. The recent midterm elections have further highlighted these dynamics and set the stage for future political realignments."
          },
        ]
      },
      {
        "role": "user",
        "parts": [
          {
            "text": "INSERT_INPUT_HERE"
          },
        ]
      },
    ],
    "generationConfig": {
      "thinkingConfig": {
        "thinkingBudget": 0,
      },
      "responseMimeType": "text/plain",
    },
    "tools": [
      {
        "googleSearch": {
        }
      },
    ],
}
EOF

curl \
-X POST \
-H "Content-Type: application/json" \
"https://generativelanguage.googleapis.com/v1beta/models/${MODEL_ID}:${GENERATE_CONTENT_API}?key=${GEMINI_API_KEY}" -d '@request.json'
