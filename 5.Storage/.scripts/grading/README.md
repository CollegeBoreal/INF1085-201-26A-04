# Setup

## :one: LMS Assignment ID = 81

```json
{
  "id": 81,
  "cmid": 91,
  "name": "5.Storage"
}
```

## :two: Rubric Definition CMID = 91

```bash
curl -X POST "https://${LMS_URL}/webservice/rest/server.php" \
-d "wstoken=${API_SYNC_TOKEN}" \
-d "wsfunction=core_grading_get_definitions" \
-d "moodlewsrestformat=json" \
-d "cmids[0]=91" \
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
      "cmid": 91,
      "contextid": 804,
      "component": "mod_assign",
      "areaname": "submissions",
      "activemethod": "rubric",
      "definitions": [
        {
          "id": 80,
          "method": "rubric",
          "name": "5.Storage",
          "description": "5.Storage",
          "descriptionformat": 1,
          "status": 20,
          "copiedfromid": null,
          "timecreated": 1794966229,
          "usercreated": 3,
          "timemodified": 1794966264,
          "usermodified": 3,
          "timecopied": 0,
          "rubric": {
            "rubric_criteria": [
              {
                "id": 313,
                "sortorder": 1,
                "description": "README.md",
                "descriptionformat": 1,
                "levels": [
                  {
                    "id": 827,
                    "score": 0,
                    "definition": "❌",
                    "definitionformat": 1
                  },
                  {
                    "id": 828,
                    "score": 1,
                    "definition": "🥈",
                    "definitionformat": 1
                  },
                  {
                    "id": 829,
                    "score": 2,
                    "definition": "🥇",
                    "definitionformat": 1
                  }
                ]
              },
              {
                "id": 314,
                "sortorder": 2,
                "description": "images",
                "descriptionformat": 1,
                "levels": [
                  {
                    "id": 830,
                    "score": 0,
                    "definition": "❌",
                    "definitionformat": 1
                  },
                  {
                    "id": 831,
                    "score": 1,
                    "definition": "✔️",
                    "definitionformat": 1
                  }
                ]
              },
              {
                "id": 315,
                "sortorder": 3,
                "description": "Appréciation",
                "descriptionformat": 1,
                "levels": [
                  {
                    "id": 832,
                    "score": 0,
                    "definition": "❌",
                    "definitionformat": 1
                  },
                  {
                    "id": 833,
                    "score": 1,
                    "definition": "🥉",
                    "definitionformat": 1
                  },
                  {
                    "id": 834,
                    "score": 2,
                    "definition": "🥈",
                    "definitionformat": 1
                  },
                  {
                    "id": 835,
                    "score": 3,
                    "definition": "🥇",
                    "definitionformat": 1
                  },
                  {
                    "id": 836,
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
