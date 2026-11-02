

```bash
for i in {161..200}; do; ping -c 1 -W 1 10.7.236.$i >/dev/null && echo "10.7.236.$i UP"; done
```

10.7.236.200 UP
