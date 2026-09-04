# Setup

## :a: Class - INF1092-201-26E-01 - Introduction à l'administration des systèmes

```
https://${LMS_URL}/course/view.php?id=6
```

## :b: Assignments for:

- [ ] courseids[0]=6

- [ ] Retrieve all assignments from LMS

```bash
curl -X POST "https://${LMS_URL}/webservice/rest/server.php" \
-d "wstoken=${API_SYNC_TOKEN}" \
-d "wsfunction=mod_assign_get_assignments" \
-d "moodlewsrestformat=json" \
-d "courseids[0]=6" | jq '.courses[].assignments[] | {id, cmid, name}'
```
```
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1704    0  1587  100   117   2463    181 --:--:-- --:--:-- --:--:--  2645
```
<details><summary>📑</summary>

```json
{
  "id": 32,
  "cmid": 37,
  "name": "0.PlanDeCours"
}
{
  "id": 37,
  "cmid": 42,
  "name": "1.IDE"
}
{
  "id": 40,
  "cmid": 45,
  "name": "3.IaC"
}
{
  "id": 41,
  "cmid": 46,
  "name": "4.Windows"
}
{
  "id": 42,
  "cmid": 47,
  "name": "5.NVMe"
}
{
  "id": 43,
  "cmid": 48,
  "name": "6.HyperV"
}
{
  "id": 44,
  "cmid": 49,
  "name": "7.IPconfig"
}

```

</details>
