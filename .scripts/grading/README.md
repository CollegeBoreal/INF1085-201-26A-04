# Setup

## :a: Class - INF1092-201-26E-01 - Introduction à l'administration des systèmes

```
https://${LMS_URL}/course/view.php?id=10
```

## :b: Assignments for:

- [ ] courseids[0]=10

- [ ] Retrieve all assignments from LMS

```powershell
$body = @{
    wstoken            = $env:API_SYNC_TOKEN
    wsfunction         = 'mod_assign_get_assignments'
    moodlewsrestformat = 'json'
    'courseids[0]'     = '10'
}

$response = Invoke-RestMethod `
    -Uri "https://$env:LMS_URL/webservice/rest/server.php" `
    -Method Post `
    -Body $body `
    -ContentType 'application/x-www-form-urlencoded'

$response.courses |
    ForEach-Object { $_.assignments } |
    Select-Object id, cmid, name |
    ConvertTo-Json -Depth 10
```

```bash
curl -X POST "https://${LMS_URL}/webservice/rest/server.php" \
-d "wstoken=${API_SYNC_TOKEN}" \
-d "wsfunction=mod_assign_get_assignments" \
-d "moodlewsrestformat=json" \
-d "courseids[0]=10" | jq '.courses[].assignments[] | {id, cmid, name}'
```
```
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1704    0  1587  100   117   2463    181 --:--:-- --:--:-- --:--:--  2645
```
<details><summary>📑</summary>

```json
{
  "id": 54,
  "cmid": 63,
  "name": "0.PlanDeCours"
}
{
  "id": 63,
  "cmid": 73,
  "name": "1.Diagnostics"
}
{
  "id": 64,
  "cmid": 74,
  "name": "2.Proxmox"
}
{
  "id": 65,
  "cmid": 75,
  "name": "3.VMs"
}

```

</details>
