# Setup

## :one: LMS Assignment ID = 80

```json
{
  "id": 80,
  "cmid": 90,
  "name": "4.Root"
}
```

## :two: Rubric Definition CMID = 90

```bash
curl -X POST "https://${LMS_URL}/webservice/rest/server.php" \
-d "wstoken=${API_SYNC_TOKEN}" \
-d "wsfunction=core_grading_get_definitions" \
-d "moodlewsrestformat=json" \
-d "cmids[0]=90" \
-d "areaname=submissions" | jq .
```
```
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2397    0  2261  100   136   3849    231 --:--:-- --:--:-- --:--:--  4076
```
<details><summary>📑</summary>

```json
{
  "areas": [
    {
      "cmid": 90,
      "contextid": 803,
      "component": "mod_assign",
      "areaname": "submissions",
      "activemethod": "rubric",
      "definitions": [
        {
          "id": 79,
          "method": "rubric",
          "name": "4.Root",
          "description": "4.Root",
          "descriptionformat": 1,
          "status": 20,
          "copiedfromid": null,
          "timecreated": 1794966168,
          "usercreated": 3,
          "timemodified": 1794966209,
          "usermodified": 3,
          "timecopied": 0,
          "rubric": {
            "rubric_criteria": [
              {
                "id": 310,
                "sortorder": 1,
                "description": "README.md",
                "descriptionformat": 1,
                "levels": [
                  {
                    "id": 817,
                    "score": 0,
                    "definition": "❌",
                    "definitionformat": 1
                  },
                  {
                    "id": 818,
                    "score": 1,
                    "definition": "🥈",
                    "definitionformat": 1
                  },
                  {
                    "id": 819,
                    "score": 2,
                    "definition": "🥇",
                    "definitionformat": 1
                  }
                ]
              },
              {
                "id": 311,
                "sortorder": 2,
                "description": "images",
                "descriptionformat": 1,
                "levels": [
                  {
                    "id": 820,
                    "score": 0,
                    "definition": "❌",
                    "definitionformat": 1
                  },
                  {
                    "id": 821,
                    "score": 1,
                    "definition": "✔️",
                    "definitionformat": 1
                  }
                ]
              },
              {
                "id": 312,
                "sortorder": 3,
                "description": "Appréciation",
                "descriptionformat": 1,
                "levels": [
                  {
                    "id": 822,
                    "score": 0,
                    "definition": "❌",
                    "definitionformat": 1
                  },
                  {
                    "id": 823,
                    "score": 1,
                    "definition": "🥉",
                    "definitionformat": 1
                  },
                  {
                    "id": 824,
                    "score": 2,
                    "definition": "🥈",
                    "definitionformat": 1
                  },
                  {
                    "id": 825,
                    "score": 3,
                    "definition": "🥇",
                    "definitionformat": 1
                  },
                  {
                    "id": 826,
                    "score": 4,
                    "definition": "🏆",
                    "definitionformat": 1
                  }
                ]
              }
            ]
          }
        }
      ]
    }
  ],
  "warnings": []
}

```

</details>
