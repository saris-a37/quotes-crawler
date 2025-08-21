# Quotes Crawler

Scripts for automatic crawling of quotes from different durations into a single JSON file

> [!WARNING]
> This project comes with no guarantee as it has no official support from the quotes sources, and therefore may breaks in case of API change.

## Currently supported sources

- [x] [GPF](https://www.gpf.or.th/thai2019/About/main.php?page=memberfund&lang=en&menu=statistic): all securities, entire duration since inception, up to 15 minutes delay ([more details](#gpf))

### GPF

The script combines JSONs from `gpf.or.th`'s API (https://www.gpf.or.th/thai2019/About/memberfund-api.php), which is the source of monthly datasets shown in [GPF's fund value page](https://www.gpf.or.th/thai2019/About/main.php?page=memberfund&lang=en&menu=statistic), into a single file [gpf_data.json](https://raw.githubusercontent.com/saris-a37/quotes-crawler/refs/heads/main/GPF/gpf_data.json). The resulting JSON is in the original format queried from the API; an excerpt is provided below with keys:

```
[
  ⋮
  {
    "SEQ": 4202,
    "UNIT_COST": 24.0214,
    "NET_COST": 383683936482.65,
    "LAUNCH_DATE": "22/01/2019 00:00:00",
    "POSTBY": "sularat",
    "POSTDATE": "24/01/2019 09:46:59",
    "UNIT": 15577604984.00,
    "NET_COST_INC": 886493939024.28,
    "CAL_FROM_DATE": "22/01/2019 00:00:00",
    "CAL_TO_DATE": "22/01/2019 00:00:00",
    "LASTUPDATE": "24/01/2019 09:46:59",
    "NET_COST1": 374196565910.57,
    "UNIT_COST1": 24.0214,
    "UNIT1": 15577604984.0000,
    "NET_COST2": 4657558635.65,
    "UNIT_COST2": 25.8617,
    "UNIT2": 180094736.0508,
    "NET_COST3": 134616787.78,
    "UNIT_COST3": 20.6215,
    "UNIT3": 6527987.2495,
    "NET_COST4": 322132148.98,
    "UNIT_COST4": 19.4306,
    "UNIT4": 16578631.7126,
    "NET_COST5": 843420412.28,
    "UNIT_COST5": 23.3466,
    "UNIT5": 36126100.4040,
    "NET_COST6": 3496307560.04,
    "UNIT_COST6": 27.1234,
    "UNIT6": 128903846.6022,
    "NET_COST7": 33335027.35,
    "UNIT_COST7": 24.0378,
    "UNIT7": 1386777.2866,
    "IsDelete": false,
    "NET_COST8": null,
    "UNIT_COST8": null,
    "UNIT8": null,
    "NET_COST9": null,
    "UNIT_COST9": null,
    "UNIT9": null,
    "NET_COST10": null,
    "UNIT_COST10": null,
    "UNIT10": null,
    "NET_COST11": null,
    "UNIT_COST11": null,
    "UNIT11": null,
    "NET_COST12": null,
    "UNIT_COST12": null,
    "UNIT12": null,
    "NET_COST13": null,
    "UNIT_COST13": null,
    "UNIT13": null,
    "NET_COST14": null,
    "UNIT_COST14": null,
    "UNIT14": null
  },
  ⋮
]
```

| Number in keys | Security (Investment Plan Name) | Remarks |
|--------|--------------------------------|---------|
| 1 | Default Plan |  |
| 2 | EQ35 Plan |  |
| 3 | Fixed Income Plan |  |
| 4 | Money Market Plan |  |
| 5 | EQ20 Plan |  |
| 6 | EQ65 Plan |  |
| 7 | Thai Equity Plan |  |
| 8 | Thai Property Funds Plan |  |
| 9 | Global Equity Plan |  |
| 10 | Principal Protected Investments Choice (PPIC) | matured on 17 Sep 2024 |
| 11 | Global Fixed Income Plan |  |
| 12 | Gold Plan |  |
| 13 | EQ75 Plan |  |
| 14 | Vayupak Plan |  |

All past and present GPF's securities listed on its website is currently supported. Data include all quotes available since each security's inception. There may be up to 15 minutes delay in routine fetching; please be noted that data from this official API is usually delayed by several days already.

## License

_© Copyright & 🄯 Copyleft 2025 สาริศ ธนาโสภณ (A37). The scripts and documentation in this project are released under [GPLv3](https://github.com/saris-a37/quotes-crawler/blob/main/LICENSE)._
