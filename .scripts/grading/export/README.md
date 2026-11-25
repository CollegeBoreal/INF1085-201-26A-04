


## In Moodle

<img src=images/moodle_grade_export.png width=50% height=50% > </img>


```bash
echo "OrgDefinedID, Labos Points Grade, End-of-Line Indicator" > D2L_import.csv
awk -F, 'NR>1 {print $3 "," $7 ",#"}' INF1085-201-26A-04\ Notes-20261125_2242-comma_separated.csv >> D2L_import.csv
```

## In D2L

- [ ] Importer les notes d’appréciation

The CVS file format must be:

where `Points Grade` is the numerical assignement

```csv
OrgDefinedID, Labos Points Grade, End-of-Line Indicator
300098957,43.71,#
```

