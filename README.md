# Quotes Crawler

Scripts for automatic crawling of quotes from different durations into a single JSON file

> [!WARNING]
> This project comes with no guarantee as it has no official support from the quotes sources, and therefore may breaks in case of API change.

## Currently supported sources

- [x] [GPF](https://www.gpf.or.th/thai2019/About/main.php?page=memberfund&lang=en&menu=statistic): all securities, entire duration since inception, up to 15 minutes delay ([more details](#gpf))
- [ ] [ThaiBMA](https://www.thaibma.or.th/EN/homeEN.aspx)
  - [ ] [ThaiBMA Bond Indices](https://www.thaibma.or.th/EN/Market/Index/)
  - [ ] [Bond Price](https://www.thaibma.or.th/EN/Market/BondPrice/BondPrice.aspx)

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

### ThaiBMA

#### ThaiBMA Bond Indices

_under construction_

The scripts combine JSONs from `thaibma.or.th`'s API (https://www.thaibma.or.th/api/), which is the source of monthly datasets shown in [ThaiBMA's bond indices page](https://www.thaibma.or.th/EN/Market/Index/), into a single file for each `bondType` query key. The resulting JSON is in the original format queried from the API; an excerpt is provided below with keys:

```
[
  ⋮
  {
    "Asof": "2025-08-20T00:00:00",
    "TtmGroupName": "Government Bond Index",
    "CleanPriceIndex": 116.469515,
    "CleanPriceIndexChange": 0.088899,
    "GrossPriceIndex": 117.067798,
    "GrossPriceIndexChange": 0.097083,
    "TotalReturnIndex": 373.916809,
    "TotalReturnIndexChange": 0.310081,
    "AvgYTMIndex": 1.695399,
    "AvgDurationIndex": 9.660105,
    "AvgConvexityIndex": 188.933305,
    "AvgTtmIndex": 11.929309,
    "AvgSimpleIndex": 1.448403,
    "NetTotalReturnIndex": 113.804805,
    "NetTotalReturnIndexChange": 0.093254,
    "Rating": null,
    "RatingOrder": null
  },
  ⋮
]
```

##### [Bond Index](https://www.thaibma.or.th/EN/Market/Index/BondIndex.aspx)

###### ThaiBMA Bond Index

from `https://www.thaibma.or.th/api/index/` to [thaibma_index_data.JSON](...)

| Index | Value of `TtmGroupName` | Key | Remarks |
|-------|-------------------------|-----|---------|
| Government Bond Weighted Average Execution Clean Price Index | Government Bond Index | CleanPriceIndex |  |
| Government Bond Weighted Average Execution Gross Price Index | Government Bond Index | GrossPriceIndex |  |
| Government Bond Weighted Average Execution Total Return Index | Government Bond Index | TotalReturnIndex |  |
| Government Bond Weighted Average Execution Net Total Return Index | Government Bond Index | NetTotalReturnIndex |  |
| Government Bond Weighted Average Execution Clean Price Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 ( 1 < TTM <= 3 ) | CleanPriceIndex |  |
| Government Bond Weighted Average Execution Gross Price Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 ( 1 < TTM <= 3 ) | GrossPriceIndex |  |
| Government Bond Weighted Average Execution Total Return Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 ( 1 < TTM <= 3 ) | TotalReturnIndex |  |
| Government Bond Weighted Average Execution Net Total Return Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 ( 1 < TTM <= 3 ) | NetTotalReturnIndex |  |
| Government Bond Weighted Average Execution Clean Price Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 ( 3 < TTM <= 7 ) | CleanPriceIndex |  |
| Government Bond Weighted Average Execution Gross Price Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 ( 3 < TTM <= 7 ) | GrossPriceIndex |  |
| Government Bond Weighted Average Execution Total Return Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 ( 3 < TTM <= 7 ) | TotalReturnIndex |  |
| Government Bond Weighted Average Execution Net Total Return Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 ( 3 < TTM <= 7 ) | NetTotalReturnIndex |  |
| Government Bond Weighted Average Execution Clean Price Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 ( 7 < TTM <= 10 ) | CleanPriceIndex |  |
| Government Bond Weighted Average Execution Gross Price Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 ( 7 < TTM <= 10 ) | GrossPriceIndex |  |
| Government Bond Weighted Average Execution Total Return Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 ( 7 < TTM <= 10 ) | TotalReturnIndex |  |
| Government Bond Weighted Average Execution Net Total Return Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 ( 7 < TTM <= 10 ) | NetTotalReturnIndex |  |
| Government Bond Weighted Average Execution Clean Price Index Group 4 ( > 10 ) | Group 4 ( > 10 ) | CleanPriceIndex |  |
| Government Bond Weighted Average Execution Gross Price Index Group 4 ( > 10 ) | Group 4 ( > 10 ) | GrossPriceIndex |  |
| Government Bond Weighted Average Execution Total Return Index Group 4 ( > 10 ) | Group 4 ( > 10 ) | TotalReturnIndex |  |
| Government Bond Weighted Average Execution Net Total Return Index Group 4 ( > 10 ) | Group 4 ( > 10 ) | NetTotalReturnIndex |  |
| Government Bond Weighted Average Execution Clean Price Index Group 5 ( ≤ 10 ) | Group 5 ( <= 10 ) | CleanPriceIndex |  |
| Government Bond Weighted Average Execution Gross Price Index Group 5 ( ≤ 10 ) | Group 5 ( <= 10 ) | GrossPriceIndex |  |
| Government Bond Weighted Average Execution Total Return Index Group 5 ( ≤ 10 ) | Group 5 ( <= 10 ) | TotalReturnIndex |  |
| Government Bond Weighted Average Execution Net Total Return Index Group 5 ( ≤ 10 ) | Group 5 ( <= 10 ) | NetTotalReturnIndex |  |
| Government Bond Weighted Average Execution Clean Price Index Group 6 ( ≤ 1 ) | Group 6 ( <= 1 ) | CleanPriceIndex |  |
| Government Bond Weighted Average Execution Gross Price Index Group 6 ( ≤ 1 ) | Group 6 ( <= 1 ) | GrossPriceIndex |  |
| Government Bond Weighted Average Execution Total Return Index Group 6 ( ≤ 1 ) | Group 6 ( <= 1 ) | TotalReturnIndex |  |
| Government Bond Weighted Average Execution Net Total Return Index Group 6 ( ≤ 1 ) | Group 6 ( <= 1 ) | NetTotalReturnIndex |  |
| Government Bond Weighted Average Execution Clean Price Index Group 7 ( 10 < TTM ≤ 30 ) | Group 7 ( 10 < TTM <= 30 ) | CleanPriceIndex |  |
| Government Bond Weighted Average Execution Gross Price Index Group 7 ( 10 < TTM ≤ 30 ) | Group 7 ( 10 < TTM <= 30 ) | GrossPriceIndex |  |
| Government Bond Weighted Average Execution Total Return Index Group 7 ( 10 < TTM ≤ 30 ) | Group 7 ( 10 < TTM <= 30 ) | TotalReturnIndex |  |
| Government Bond Weighted Average Execution Net Total Return Index Group 7 ( 10 < TTM ≤ 30 ) | Group 7 ( 10 < TTM <= 30 ) | NetTotalReturnIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Clean Price Index | SOE (G) Bond Index | CleanPriceIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Gross Price Index | SOE (G) Bond Index | GrossPriceIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Total Return Index | SOE (G) Bond Index | TotalReturnIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Net Total Return Index | SOE (G) Bond Index | NetTotalReturnIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Clean Price Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 ( 1 < TTM <= 3 ) | CleanPriceIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Gross Price Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 ( 1 < TTM <= 3 ) | GrossPriceIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Total Return Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 ( 1 < TTM <= 3 ) | TotalReturnIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Net Total Return Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 ( 1 < TTM <= 3 ) | NetTotalReturnIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Clean Price Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 ( 3 < TTM <= 7 ) | CleanPriceIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Gross Price Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 ( 3 < TTM <= 7 ) | GrossPriceIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Total Return Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 ( 3 < TTM <= 7 ) | TotalReturnIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Net Total Return Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 ( 3 < TTM <= 7 ) | NetTotalReturnIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Clean Price Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 ( 7 < TTM <= 10 ) | CleanPriceIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Gross Price Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 ( 7 < TTM <= 10 ) | GrossPriceIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Total Return Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 ( 7 < TTM <= 10 ) | TotalReturnIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Net Total Return Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 ( 7 < TTM <= 10 ) | NetTotalReturnIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Clean Price Index Group 4 ( > 10 ) | Group 4 ( > 10 ) | CleanPriceIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Gross Price Index Group 4 ( > 10 ) | Group 4 ( > 10 ) | GrossPriceIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Total Return Index Group 4 ( > 10 ) | Group 4 ( > 10 ) | TotalReturnIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Net Total Return Index Group 4 ( > 10 ) | Group 4 ( > 10 ) | NetTotalReturnIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Clean Price Index Group 5 ( ≤ 10 ) | Group 5 ( <= 10 ) | CleanPriceIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Gross Price Index Group 5 ( ≤ 10 ) | Group 5 ( <= 10 ) | GrossPriceIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Total Return Index Group 5 ( ≤ 10 ) | Group 5 ( <= 10 ) | TotalReturnIndex |  |
| State-Owned Enterprise Guaranteed Bond Weighted Average Execution Net Total Return Index Group 5 ( ≤ 10 ) | Group 5 ( <= 10 ) | NetTotalReturnIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Clean Price Index | SOE (NG) Bond Index | CleanPriceIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Gross Price Index | SOE (NG) Bond Index | GrossPriceIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Total Return Index | SOE (NG) Bond Index | TotalReturnIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Net Total Return Index | SOE (NG) Bond Index | NetTotalReturnIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Clean Price Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 ( 1 < TTM <= 3 ) | CleanPriceIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Gross Price Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 ( 1 < TTM <= 3 ) | GrossPriceIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Total Return Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 ( 1 < TTM <= 3 ) | TotalReturnIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Net Total Return Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 ( 1 < TTM <= 3 ) | NetTotalReturnIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Clean Price Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 ( 3 < TTM <= 7 ) | CleanPriceIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Gross Price Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 ( 3 < TTM <= 7 ) | GrossPriceIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Total Return Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 ( 3 < TTM <= 7 ) | TotalReturnIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Net Total Return Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 ( 3 < TTM <= 7 ) | NetTotalReturnIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Clean Price Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 ( 7 < TTM <= 10 ) | CleanPriceIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Gross Price Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 ( 7 < TTM <= 10 ) | GrossPriceIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Total Return Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 ( 7 < TTM <= 10 ) | TotalReturnIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Net Total Return Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 ( 7 < TTM <= 10 ) | NetTotalReturnIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Clean Price Index Group 4 ( > 10 ) | Group 4 ( > 10 ) | CleanPriceIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Gross Price Index Group 4 ( > 10 ) | Group 4 ( > 10 ) | GrossPriceIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Total Return Index Group 4 ( > 10 ) | Group 4 ( > 10 ) | TotalReturnIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Net Total Return Index Group 4 ( > 10 ) | Group 4 ( > 10 ) | NetTotalReturnIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Clean Price Index Group 5 ( ≤ 10 ) | Group 5 ( <= 10 ) | CleanPriceIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Gross Price Index Group 5 ( ≤ 10 ) | Group 5 ( <= 10 ) | GrossPriceIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Total Return Index Group 5 ( ≤ 10 ) | Group 5 ( <= 10 ) | TotalReturnIndex |  |
| State-Owned Enterprise Non-Guaranteed Bond Weighted Average Execution Net Total Return Index Group 5 ( ≤ 10 ) | Group 5 ( <= 10 ) | NetTotalReturnIndex |  |

###### ThaiBMA Investment Grade Corporate Bond Index

from `https://www.thaibma.or.th/api/index/?isShowSubGroup=false` to [thaibma_index_isShowSubGroup-false_data.JSON](...)

| Index | Value of `TtmGroupName` | Key | Remarks |
|-------|-------------------------|-----|---------|
| Corporate Bond ≥ BBB+ Weighted Average Execution Clean Price Index | Corporate Bond Index (BBB+ up)  | CleanPriceIndex | obsoleted since 31 Dec 2021 |
| Corporate Bond ≥ BBB+ Weighted Average Execution Gross Price Index | Corporate Bond Index (BBB+ up)  | GrossPriceIndex | obsoleted since 31 Dec 2021 |
| Corporate Bond ≥ BBB+ Weighted Average Execution Total Return Index | Corporate Bond Index (BBB+ up)  | TotalReturnIndex | obsoleted since 31 Dec 2021 |
| Corporate Bond ≥ BBB+ Weighted Average Execution Net Total Return Index | Corporate Bond Index (BBB+ up)  | NetTotalReturnIndex | obsoleted since 31 Dec 2021 |
| Corporate Bond ≥ BBB Weighted Average Execution Clean Price Index | Corporate Bond Index (BBB up)  | CleanPriceIndex | obsoleted since 31 Dec 2021 |
| Corporate Bond ≥ BBB Weighted Average Execution Gross Price Index | Corporate Bond Index (BBB up)  | GrossPriceIndex | obsoleted since 31 Dec 2021 |
| Corporate Bond ≥ BBB Weighted Average Execution Total Return Index | Corporate Bond Index (BBB up)  | TotalReturnIndex | obsoleted since 31 Dec 2021 |
| Corporate Bond ≥ BBB Weighted Average Execution Net Total Return Index | Corporate Bond Index (BBB up)  | NetTotalReturnIndex | obsoleted since 31 Dec 2021 |

##### [Composite Bond Index](https://www.thaibma.or.th/EN/Market/Index/CompositeIndex.aspx)

from `https://www.thaibma.or.th/api/CompositeIndex/?IndexType=Composite(Corp)` to [thaibma_CompositeIndex_IndexType-Composite(Corp)_data.JSON](...)

| Index | Value of `TtmGroupName` | Key | Remarks |
|-------|-------------------------|-----|---------|
| Composite Bond Clean Price Index | Composite Bond Index | CleanPriceIndex |  |
| Composite Bond Gross Price Index | Composite Bond Index | GrossPriceIndex |  |
| Composite Bond Total Return Index | Composite Bond Index | TotalReturnIndex |  |

##### [Zero Rate Return (ZRR) Index](https://www.thaibma.or.th/EN/Market/Index/ZRRIndex.aspx)

from `https://www.thaibma.or.th/api/zrrindex/?ratingName=RF` to [thaibma_zrrindex_ratingName-RF_data.JSON](...)

| Index | Value of `TtmName` | Key | Remarks |
|-------|-------------------------|-----|---------|
| 1-Month Bond Zero Rate Return Index | 1-Month | ZrrIndex |  |
| 3-Month Bond Zero Rate Return Index | 3-Month | ZrrIndex |  |
| 6-Month Bond Zero Rate Return Index | 6-Month | ZrrIndex |  |
| 1-Year Bond Zero Rate Return Index | 1-Year | ZrrIndex |  |
| 2-Year Bond Zero Rate Return Index | 2-Year | ZrrIndex |  |
| 3-Year Bond Zero Rate Return Index | 3-Year | ZrrIndex |  |
| 4-Year Bond Zero Rate Return Index | 4-Year | ZrrIndex |  |
| 5-Year Bond Zero Rate Return Index | 5-Year | ZrrIndex |  |

##### [Treasury Bill Index](https://www.thaibma.or.th/EN/Market/Index/TBillIndex.aspx)

from `https://www.thaibma.or.th/api/index?bondtype=TB` to [thaibma_index_bondtype-TB_data.JSON](...)

| Index | Value of `TtmGroupName` | Key | Remarks |
|-------|-------------------------|-----|---------|
| Treasury Bill Clean Price Index |  | CleanPriceIndex | obsoleted since 29 Jun 2011 |

##### [Commercial Paper Index](https://www.thaibma.or.th/EN/Market/Index/CPIndex.aspx)

from `https://www.thaibma.or.th/api/index/?bondType=CP` to [thaibma_index_bondtype-CP_data.JSON](...)

| Index | Value of `TtmGroupName` | Key | Remarks |
|-------|-------------------------|-----|---------|
| Commercial Paper ≥ AA- Clean Price Index | Commercial Paper Index (AA- up)  | CleanPriceIndex |  |
| Commercial Paper ≥ AA- Gross Price Index | Commercial Paper Index (AA- up)  | GrossPriceIndex |  |
| Commercial Paper ≥ AA- Total Return Index | Commercial Paper Index (AA- up)  | TotalReturnIndex |  |
| Commercial Paper ≥ A- Clean Price Index | Commercial Paper Index (A- up)  | CleanPriceIndex |  |
| Commercial Paper ≥ A- Gross Price Index | Commercial Paper Index (A- up)  | GrossPriceIndex |  |
| Commercial Paper ≥ A- Total Return Index | Commercial Paper Index (A- up)  | TotalReturnIndex |  |
| Commercial Paper ≥ BBB- Clean Price Index | Commercial Paper Index (BBB- up)  | CleanPriceIndex |  |
| Commercial Paper ≥ BBB- Gross Price Index | Commercial Paper Index (BBB- up)  | GrossPriceIndex |  |
| Commercial Paper ≥ BBB- Total Return Index | Commercial Paper Index (BBB- up)  | TotalReturnIndex |  |

##### [Short-term Government Bond Index](https://www.thaibma.or.th/EN/Market/Index/ShortTermIndex.aspx)

from `https://www.thaibma.or.th/api/index/?bondType=shortterm` to [thaibma_index_bondtype-shortterm_data.JSON](...)

| Index | Value of `TtmGroupName` | Key | Remarks |
|-------|-------------------------|-----|---------|
| Short-term Government Bond Clean Price Index | Short-term Government Bond Index  | CleanPriceIndex |  |
| Short-term Government Bond Gross Price Index | Short-term Government Bond Index  | GrossPriceIndex |  |
| Short-term Government Bond Total Return Index | Short-term Government Bond Index  | TotalReturnIndex |  |

##### [MTM Government Bond Index](https://www.thaibma.or.th/EN/Market/Index/MTMGovIndex.aspx)

from `https://www.thaibma.or.th/api/index/?bondType=GOV-MTM` to [thaibma_index_bondtype-GOV-MTM_data.JSON](...)

| Index | Value of `TtmGroupName` | Key | Remarks |
|-------|-------------------------|-----|---------|
| Government Bond Marked-to-Market Clean Price Index | MTM Government Bond Index | CleanPriceIndex |  |
| Government Bond Marked-to-Market Gross Price Index | MTM Government Bond Index | GrossPriceIndex |  |
| Government Bond Marked-to-Market Total Return Index | MTM Government Bond Index | TotalReturnIndex |  |
| Government Bond Marked-to-Market Net Total Return Index | MTM Government Bond Index | NetTotalReturnIndex |  |
| Government Bond Marked-to-Market Clean Price Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 ( 1 < TTM <= 3 ) | CleanPriceIndex |  |
| Government Bond Marked-to-Market Gross Price Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 ( 1 < TTM <= 3 ) | GrossPriceIndex |  |
| Government Bond Marked-to-Market Total Return Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 ( 1 < TTM <= 3 ) | TotalReturnIndex |  |
| Government Bond Marked-to-Market Net Total Return Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 ( 1 < TTM <= 3 ) | NetTotalReturnIndex |  |
| Government Bond Marked-to-Market Clean Price Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 ( 3 < TTM <= 7 ) | CleanPriceIndex |  |
| Government Bond Marked-to-Market Gross Price Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 ( 3 < TTM <= 7 ) | GrossPriceIndex |  |
| Government Bond Marked-to-Market Total Return Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 ( 3 < TTM <= 7 ) | TotalReturnIndex |  |
| Government Bond Marked-to-Market Net Total Return Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 ( 3 < TTM <= 7 ) | NetTotalReturnIndex |  |
| Government Bond Marked-to-Market Clean Price Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 ( 7 < TTM <= 10 ) | CleanPriceIndex |  |
| Government Bond Marked-to-Market Gross Price Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 ( 7 < TTM <= 10 ) | GrossPriceIndex |  |
| Government Bond Marked-to-Market Total Return Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 ( 7 < TTM <= 10 ) | TotalReturnIndex |  |
| Government Bond Marked-to-Market Net Total Return Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 ( 7 < TTM <= 10 ) | NetTotalReturnIndex |  |
| Government Bond Marked-to-Market Clean Price Index Group 4 ( > 10 ) | Group 4 ( > 10 ) | CleanPriceIndex |  |
| Government Bond Marked-to-Market Gross Price Index Group 4 ( > 10 ) | Group 4 ( > 10 ) | GrossPriceIndex |  |
| Government Bond Marked-to-Market Total Return Index Group 4 ( > 10 ) | Group 4 ( > 10 ) | TotalReturnIndex |  |
| Government Bond Marked-to-Market Net Total Return Index Group 4 ( > 10 ) | Group 4 ( > 10 ) | NetTotalReturnIndex |  |
| Government Bond Marked-to-Market Clean Price Index Group 5 ( ≤ 10 ) | Group 5 ( <= 10 ) | CleanPriceIndex |  |
| Government Bond Marked-to-Market Gross Price Index Group 5 ( ≤ 10 ) | Group 5 ( <= 10 ) | GrossPriceIndex |  |
| Government Bond Marked-to-Market Total Return Index Group 5 ( ≤ 10 ) | Group 5 ( <= 10 ) | TotalReturnIndex |  |
| Government Bond Marked-to-Market Net Total Return Index Group 5 ( ≤ 10 ) | Group 5 ( <= 10 ) | NetTotalReturnIndex |  |
| Government Bond Marked-to-Market Clean Price Index Group 6 ( ≤ 1 ) | Group 6 ( <= 1 ) | CleanPriceIndex |  |
| Government Bond Marked-to-Market Gross Price Index Group 6 ( ≤ 1 ) | Group 6 ( <= 1 ) | GrossPriceIndex |  |
| Government Bond Marked-to-Market Total Return Index Group 6 ( ≤ 1 ) | Group 6 ( <= 1 ) | TotalReturnIndex |  |
| Government Bond Marked-to-Market Net Total Return Index Group 6 ( ≤ 1 ) | Group 6 ( <= 1 ) | NetTotalReturnIndex |  |
| Government Bond Marked-to-Market Clean Price Index Group 7 ( 10 < TTM ≤ 30 ) | Group 7 ( 10 < TTM <= 30 ) | CleanPriceIndex |  |
| Government Bond Marked-to-Market Gross Price Index Group 7 ( 10 < TTM ≤ 30 ) | Group 7 ( 10 < TTM <= 30 ) | GrossPriceIndex |  |
| Government Bond Marked-to-Market Total Return Index Group 7 ( 10 < TTM ≤ 30 ) | Group 7 ( 10 < TTM <= 30 ) | TotalReturnIndex |  |
| Government Bond Marked-to-Market Net Total Return Index Group 7 ( 10 < TTM ≤ 30 ) | Group 7 ( 10 < TTM <= 30 ) | NetTotalReturnIndex |  |

##### [MTM Corporate Bond Index](https://www.thaibma.or.th/EN/Market/Index/MTMCorpIndex.aspx)

from `https://www.thaibma.or.th/api/index/?bondType=corporate` to [thaibma_index_bondtype-corporate_data.JSON](...)

| Index | Value of `TtmGroupName` | Value of `Rating` | Value of `RatingOrder` | Key | Remarks |
|-------|-------------------------|-------------------|------------------------|-----|---------|
| Corporate Bond ≥ A- Marked-to-Market Clean Price Index | MTM Corporate Bond Index (A- up)  | ทุกช่วงอายุ | 7 | CleanPriceIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Gross Price Index | MTM Corporate Bond Index (A- up)  | ทุกช่วงอายุ | 7 | GrossPriceIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Total Return Index | MTM Corporate Bond Index (A- up)  | ทุกช่วงอายุ | 7 | TotalReturnIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Net Total Return Index | MTM Corporate Bond Index (A- up)  | ทุกช่วงอายุ | 7 | NetTotalReturnIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Clean Price Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 [ 1 < TTM <= 3 ] | 1 < TTM <= 3 | 7 | CleanPriceIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Gross Price Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 [ 1 < TTM <= 3 ] | 1 < TTM <= 3 | 7 | GrossPriceIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Total Return Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 [ 1 < TTM <= 3 ] | 1 < TTM <= 3 | 7 | TotalReturnIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Net Total Return Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 [ 1 < TTM <= 3 ] | 1 < TTM <= 3 | 7 | NetTotalReturnIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Clean Price Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 [ 3 < TTM <= 7 ] | 3 < TTM <= 7 | 7 | CleanPriceIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Gross Price Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 [ 3 < TTM <= 7 ] | 3 < TTM <= 7 | 7 | GrossPriceIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Total Return Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 [ 3 < TTM <= 7 ] | 3 < TTM <= 7 | 7 | TotalReturnIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Net Total Return Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 [ 3 < TTM <= 7 ] | 3 < TTM <= 7 | 7 | NetTotalReturnIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Clean Price Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 [ 7 < TTM <= 10 ] | 7 < TTM <= 10 | 7 | CleanPriceIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Gross Price Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 [ 7 < TTM <= 10 ] | 7 < TTM <= 10 | 7 | GrossPriceIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Total Return Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 [ 7 < TTM <= 10 ] | 7 < TTM <= 10 | 7 | TotalReturnIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Net Total Return Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 [ 7 < TTM <= 10 ] | 7 < TTM <= 10 | 7 | NetTotalReturnIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Clean Price Index Group 4 ( TTM ≤ 10 ) | Group 4 [ TTM <= 10 ] | TTM <= 10 | 7 | CleanPriceIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Gross Price Index Group 4 ( TTM ≤ 10 ) | Group 4 [ TTM <= 10 ] | TTM <= 10 | 7 | GrossPriceIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Total Return Index Group 4 ( TTM ≤ 10 ) | Group 4 [ TTM <= 10 ] | TTM <= 10 | 7 | TotalReturnIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Net Total Return Index Group 4 ( TTM ≤ 10 ) | Group 4 [ TTM <= 10 ] | TTM <= 10 | 7 | NetTotalReturnIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Clean Price Index Group 5 ( TTM ≤ 1 ) | Group 5 [ TTM <= 1 ] | TTM <= 1 | 7 | CleanPriceIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Gross Price Index Group 5 ( TTM ≤ 1 ) | Group 5 [ TTM <= 1 ] | TTM <= 1 | 7 | GrossPriceIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Total Return Index Group 5 ( TTM ≤ 1 ) | Group 5 [ TTM <= 1 ] | TTM <= 1 | 7 | TotalReturnIndex |  |
| Corporate Bond ≥ A- Marked-to-Market Net Total Return Index Group 5 ( TTM ≤ 1 ) | Group 5 [ TTM <= 1 ] | TTM <= 1 | 7 | NetTotalReturnIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Clean Price Index | MTM Corporate Bond Index (BBB+ up)  | ทุกช่วงอายุ | 8 | CleanPriceIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Gross Price Index | MTM Corporate Bond Index (BBB+ up)  | ทุกช่วงอายุ | 8 | GrossPriceIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Total Return Index | MTM Corporate Bond Index (BBB+ up)  | ทุกช่วงอายุ | 8 | TotalReturnIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Net Total Return Index | MTM Corporate Bond Index (BBB+ up)  | ทุกช่วงอายุ | 8 | NetTotalReturnIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Clean Price Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 [ 1 < TTM <= 3 ] | 1 < TTM <= 3 | 8 | CleanPriceIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Gross Price Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 [ 1 < TTM <= 3 ] | 1 < TTM <= 3 | 8 | GrossPriceIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Total Return Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 [ 1 < TTM <= 3 ] | 1 < TTM <= 3 | 8 | TotalReturnIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Net Total Return Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 [ 1 < TTM <= 3 ] | 1 < TTM <= 3 | 8 | NetTotalReturnIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Clean Price Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 [ 3 < TTM <= 7 ] | 3 < TTM <= 7 | 8 | CleanPriceIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Gross Price Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 [ 3 < TTM <= 7 ] | 3 < TTM <= 7 | 8 | GrossPriceIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Total Return Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 [ 3 < TTM <= 7 ] | 3 < TTM <= 7 | 8 | TotalReturnIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Net Total Return Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 [ 3 < TTM <= 7 ] | 3 < TTM <= 7 | 8 | NetTotalReturnIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Clean Price Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 [ 7 < TTM <= 10 ] | 7 < TTM <= 10 | 8 | CleanPriceIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Gross Price Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 [ 7 < TTM <= 10 ] | 7 < TTM <= 10 | 8 | GrossPriceIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Total Return Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 [ 7 < TTM <= 10 ] | 7 < TTM <= 10 | 8 | TotalReturnIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Net Total Return Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 [ 7 < TTM <= 10 ] | 7 < TTM <= 10 | 8 | NetTotalReturnIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Clean Price Index Group 4 ( TTM ≤ 10 ) | Group 4 [ TTM <= 10 ] | TTM <= 10 | 8 | CleanPriceIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Gross Price Index Group 4 ( TTM ≤ 10 ) | Group 4 [ TTM <= 10 ] | TTM <= 10 | 8 | GrossPriceIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Total Return Index Group 4 ( TTM ≤ 10 ) | Group 4 [ TTM <= 10 ] | TTM <= 10 | 8 | TotalReturnIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Net Total Return Index Group 4 ( TTM ≤ 10 ) | Group 4 [ TTM <= 10 ] | TTM <= 10 | 8 | NetTotalReturnIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Clean Price Index Group 5 ( TTM ≤ 1 ) | Group 5 [ TTM <= 1 ] | TTM <= 1 | 8 | CleanPriceIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Gross Price Index Group 5 ( TTM ≤ 1 ) | Group 5 [ TTM <= 1 ] | TTM <= 1 | 8 | GrossPriceIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Total Return Index Group 5 ( TTM ≤ 1 ) | Group 5 [ TTM <= 1 ] | TTM <= 1 | 8 | TotalReturnIndex |  |
| Corporate Bond ≥ BBB+ Marked-to-Market Net Total Return Index Group 5 ( TTM ≤ 1 ) | Group 5 [ TTM <= 1 ] | TTM <= 1 | 8 | NetTotalReturnIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Clean Price Index | MTM Corporate Bond Index (BBB up)  | ทุกช่วงอายุ | 9 | CleanPriceIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Gross Price Index | MTM Corporate Bond Index (BBB up)  | ทุกช่วงอายุ | 9 | GrossPriceIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Total Return Index | MTM Corporate Bond Index (BBB up)  | ทุกช่วงอายุ | 9 | TotalReturnIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Net Total Return Index | MTM Corporate Bond Index (BBB up)  | ทุกช่วงอายุ | 9 | NetTotalReturnIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Clean Price Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 [ 1 < TTM <= 3 ] | 1 < TTM <= 3 | 9 | CleanPriceIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Gross Price Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 [ 1 < TTM <= 3 ] | 1 < TTM <= 3 | 9 | GrossPriceIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Total Return Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 [ 1 < TTM <= 3 ] | 1 < TTM <= 3 | 9 | TotalReturnIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Net Total Return Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 [ 1 < TTM <= 3 ] | 1 < TTM <= 3 | 9 | NetTotalReturnIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Clean Price Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 [ 3 < TTM <= 7 ] | 3 < TTM <= 7 | 9 | CleanPriceIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Gross Price Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 [ 3 < TTM <= 7 ] | 3 < TTM <= 7 | 9 | GrossPriceIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Total Return Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 [ 3 < TTM <= 7 ] | 3 < TTM <= 7 | 9 | TotalReturnIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Net Total Return Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 [ 3 < TTM <= 7 ] | 3 < TTM <= 7 | 9 | NetTotalReturnIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Clean Price Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 [ 7 < TTM <= 10 ] | 7 < TTM <= 10 | 9 | CleanPriceIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Gross Price Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 [ 7 < TTM <= 10 ] | 7 < TTM <= 10 | 9 | GrossPriceIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Total Return Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 [ 7 < TTM <= 10 ] | 7 < TTM <= 10 | 9 | TotalReturnIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Net Total Return Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 [ 7 < TTM <= 10 ] | 7 < TTM <= 10 | 9 | NetTotalReturnIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Clean Price Index Group 4 ( TTM ≤ 10 ) | Group 4 [ TTM <= 10 ] | TTM <= 10 | 9 | CleanPriceIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Gross Price Index Group 4 ( TTM ≤ 10 ) | Group 4 [ TTM <= 10 ] | TTM <= 10 | 9 | GrossPriceIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Total Return Index Group 4 ( TTM ≤ 10 ) | Group 4 [ TTM <= 10 ] | TTM <= 10 | 9 | TotalReturnIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Net Total Return Index Group 4 ( TTM ≤ 10 ) | Group 4 [ TTM <= 10 ] | TTM <= 10 | 9 | NetTotalReturnIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Clean Price Index Group 5 ( TTM ≤ 1 ) | Group 5 [ TTM <= 1 ] | TTM <= 1 | 9 | CleanPriceIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Gross Price Index Group 5 ( TTM ≤ 1 ) | Group 5 [ TTM <= 1 ] | TTM <= 1 | 9 | GrossPriceIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Total Return Index Group 5 ( TTM ≤ 1 ) | Group 5 [ TTM <= 1 ] | TTM <= 1 | 9 | TotalReturnIndex |  |
| Corporate Bond ≥ BBB Marked-to-Market Net Total Return Index Group 5 ( TTM ≤ 1 ) | Group 5 [ TTM <= 1 ] | TTM <= 1 | 9 | NetTotalReturnIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Clean Price Index | MTM Corporate Bond Index (BBB- up)  | ทุกช่วงอายุ | 10 | CleanPriceIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Gross Price Index | MTM Corporate Bond Index (BBB- up)  | ทุกช่วงอายุ | 10 | GrossPriceIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Total Return Index | MTM Corporate Bond Index (BBB- up)  | ทุกช่วงอายุ | 10 | TotalReturnIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Net Total Return Index | MTM Corporate Bond Index (BBB- up)  | ทุกช่วงอายุ | 10 | NetTotalReturnIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Clean Price Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 [ 1 < TTM <= 3 ] | 1 < TTM <= 3 | 10 | CleanPriceIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Gross Price Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 [ 1 < TTM <= 3 ] | 1 < TTM <= 3 | 10 | GrossPriceIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Total Return Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 [ 1 < TTM <= 3 ] | 1 < TTM <= 3 | 10 | TotalReturnIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Net Total Return Index Group 1 ( 1 < TTM ≤ 3 ) | Group 1 [ 1 < TTM <= 3 ] | 1 < TTM <= 3 | 10 | NetTotalReturnIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Clean Price Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 [ 3 < TTM <= 7 ] | 3 < TTM <= 7 | 10 | CleanPriceIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Gross Price Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 [ 3 < TTM <= 7 ] | 3 < TTM <= 7 | 10 | GrossPriceIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Total Return Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 [ 3 < TTM <= 7 ] | 3 < TTM <= 7 | 10 | TotalReturnIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Net Total Return Index Group 2 ( 3 < TTM ≤ 7 ) | Group 2 [ 3 < TTM <= 7 ] | 3 < TTM <= 7 | 10 | NetTotalReturnIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Clean Price Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 [ 7 < TTM <= 10 ] | 7 < TTM <= 10 | 10 | CleanPriceIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Gross Price Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 [ 7 < TTM <= 10 ] | 7 < TTM <= 10 | 10 | GrossPriceIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Total Return Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 [ 7 < TTM <= 10 ] | 7 < TTM <= 10 | 10 | TotalReturnIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Net Total Return Index Group 3 ( 7 < TTM ≤ 10 ) | Group 3 [ 7 < TTM <= 10 ] | 7 < TTM <= 10 | 10 | NetTotalReturnIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Clean Price Index Group 4 ( TTM ≤ 10 ) | Group 4 [ TTM <= 10 ] | TTM <= 10 | 10 | CleanPriceIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Gross Price Index Group 4 ( TTM ≤ 10 ) | Group 4 [ TTM <= 10 ] | TTM <= 10 | 10 | GrossPriceIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Total Return Index Group 4 ( TTM ≤ 10 ) | Group 4 [ TTM <= 10 ] | TTM <= 10 | 10 | TotalReturnIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Net Total Return Index Group 4 ( TTM ≤ 10 ) | Group 4 [ TTM <= 10 ] | TTM <= 10 | 10 | NetTotalReturnIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Clean Price Index Group 5 ( TTM ≤ 1 ) | Group 5 [ TTM <= 1 ] | TTM <= 1 | 10 | CleanPriceIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Gross Price Index Group 5 ( TTM ≤ 1 ) | Group 5 [ TTM <= 1 ] | TTM <= 1 | 10 | GrossPriceIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Total Return Index Group 5 ( TTM ≤ 1 ) | Group 5 [ TTM <= 1 ] | TTM <= 1 | 10 | TotalReturnIndex |  |
| Corporate Bond ≥ BBB- Marked-to-Market Net Total Return Index Group 5 ( TTM ≤ 1 ) | Group 5 [ TTM <= 1 ] | TTM <= 1 | 10 | NetTotalReturnIndex |  |

##### [Fixed-Term Corporate Bond Index](https://www.thaibma.or.th/EN/Market/Index/FixedTermCorpIndex.aspx)

from `https://www.thaibma.or.th/api/index/?bondType=FixedTerm-Corporate` to [thaibma_index_bondtype-FixedTerm-Corporate_data.JSON](...)

| Index | Value of `TtmGroupName` | Value of `Rating` | Value of `RatingOrder` | Key | Remarks |
|-------|-------------------------|-------------------|------------------------|-----|---------|
|  | Group 1 [ttm=1] | Fixed-Term Corporate Bond Index (A- up)  | 7 | CleanPriceIndex |  |
|  | Group 1 [ttm=1] | Fixed-Term Corporate Bond Index (A- up)  | 7 | GrossPriceIndex |  |
|  | Group 1 [ttm=1] | Fixed-Term Corporate Bond Index (A- up)  | 7 | TotalReturnIndex |  |
|  | Group 1 [ttm=1] | Fixed-Term Corporate Bond Index (A- up)  | 7 | NetTotalReturnIndex |  |
|  | Group 2 [ttm=2] | Fixed-Term Corporate Bond Index (A- up)  | 7 | CleanPriceIndex |  |
|  | Group 2 [ttm=2] | Fixed-Term Corporate Bond Index (A- up)  | 7 | GrossPriceIndex |  |
|  | Group 2 [ttm=2] | Fixed-Term Corporate Bond Index (A- up)  | 7 | TotalReturnIndex |  |
|  | Group 2 [ttm=2] | Fixed-Term Corporate Bond Index (A- up)  | 7 | NetTotalReturnIndex |  |
|  | Group 3 [ttm=3] | Fixed-Term Corporate Bond Index (A- up)  | 7 | CleanPriceIndex |  |
|  | Group 3 [ttm=3] | Fixed-Term Corporate Bond Index (A- up)  | 7 | GrossPriceIndex |  |
|  | Group 3 [ttm=3] | Fixed-Term Corporate Bond Index (A- up)  | 7 | TotalReturnIndex |  |
|  | Group 3 [ttm=3] | Fixed-Term Corporate Bond Index (A- up)  | 7 | NetTotalReturnIndex |  |
|  | Group 4 [ttm=4] | Fixed-Term Corporate Bond Index (A- up)  | 7 | CleanPriceIndex |  |
|  | Group 4 [ttm=4] | Fixed-Term Corporate Bond Index (A- up)  | 7 | GrossPriceIndex |  |
|  | Group 4 [ttm=4] | Fixed-Term Corporate Bond Index (A- up)  | 7 | TotalReturnIndex |  |
|  | Group 4 [ttm=4] | Fixed-Term Corporate Bond Index (A- up)  | 7 | NetTotalReturnIndex |  |
|  | Group 5 [ttm=5] | Fixed-Term Corporate Bond Index (A- up)  | 7 | CleanPriceIndex |  |
|  | Group 5 [ttm=5] | Fixed-Term Corporate Bond Index (A- up)  | 7 | GrossPriceIndex |  |
|  | Group 5 [ttm=5] | Fixed-Term Corporate Bond Index (A- up)  | 7 | TotalReturnIndex |  |
|  | Group 5 [ttm=5] | Fixed-Term Corporate Bond Index (A- up)  | 7 | NetTotalReturnIndex |  |
|  | Group 1 [ttm=1] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | CleanPriceIndex |  |
|  | Group 1 [ttm=1] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | GrossPriceIndex |  |
|  | Group 1 [ttm=1] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | TotalReturnIndex |  |
|  | Group 1 [ttm=1] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | NetTotalReturnIndex |  |
|  | Group 2 [ttm=2] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | CleanPriceIndex |  |
|  | Group 2 [ttm=2] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | GrossPriceIndex |  |
|  | Group 2 [ttm=2] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | TotalReturnIndex |  |
|  | Group 2 [ttm=2] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | NetTotalReturnIndex |  |
|  | Group 3 [ttm=3] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | CleanPriceIndex |  |
|  | Group 3 [ttm=3] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | GrossPriceIndex |  |
|  | Group 3 [ttm=3] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | TotalReturnIndex |  |
|  | Group 3 [ttm=3] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | NetTotalReturnIndex |  |
|  | Group 4 [ttm=4] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | CleanPriceIndex |  |
|  | Group 4 [ttm=4] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | GrossPriceIndex |  |
|  | Group 4 [ttm=4] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | TotalReturnIndex |  |
|  | Group 4 [ttm=4] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | NetTotalReturnIndex |  |
|  | Group 5 [ttm=5] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | CleanPriceIndex |  |
|  | Group 5 [ttm=5] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | GrossPriceIndex |  |
|  | Group 5 [ttm=5] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | TotalReturnIndex |  |
|  | Group 5 [ttm=5] | Fixed-Term Corporate Bond Index (BBB+ up)  | 8 | NetTotalReturnIndex |  |
|  | Group 1 [ttm=1] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | CleanPriceIndex |  |
|  | Group 1 [ttm=1] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | GrossPriceIndex |  |
|  | Group 1 [ttm=1] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | TotalReturnIndex |  |
|  | Group 1 [ttm=1] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | NetTotalReturnIndex |  |
|  | Group 2 [ttm=2] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | CleanPriceIndex |  |
|  | Group 2 [ttm=2] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | GrossPriceIndex |  |
|  | Group 2 [ttm=2] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | TotalReturnIndex |  |
|  | Group 2 [ttm=2] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | NetTotalReturnIndex |  |
|  | Group 3 [ttm=3] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | CleanPriceIndex |  |
|  | Group 3 [ttm=3] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | GrossPriceIndex |  |
|  | Group 3 [ttm=3] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | TotalReturnIndex |  |
|  | Group 3 [ttm=3] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | NetTotalReturnIndex |  |
|  | Group 4 [ttm=4] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | CleanPriceIndex |  |
|  | Group 4 [ttm=4] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | GrossPriceIndex |  |
|  | Group 4 [ttm=4] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | TotalReturnIndex |  |
|  | Group 4 [ttm=4] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | NetTotalReturnIndex |  |
|  | Group 5 [ttm=5] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | CleanPriceIndex |  |
|  | Group 5 [ttm=5] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | GrossPriceIndex |  |
|  | Group 5 [ttm=5] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | TotalReturnIndex |  |
|  | Group 5 [ttm=5] | Fixed-Term Corporate Bond Index (BBB up)  | 9 | NetTotalReturnIndex |  |
|  | Group 1 [ttm=1] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | CleanPriceIndex |  |
|  | Group 1 [ttm=1] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | GrossPriceIndex |  |
|  | Group 1 [ttm=1] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | TotalReturnIndex |  |
|  | Group 1 [ttm=1] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | NetTotalReturnIndex |  |
|  | Group 2 [ttm=2] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | CleanPriceIndex |  |
|  | Group 2 [ttm=2] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | GrossPriceIndex |  |
|  | Group 2 [ttm=2] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | TotalReturnIndex |  |
|  | Group 2 [ttm=2] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | NetTotalReturnIndex |  |
|  | Group 3 [ttm=3] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | CleanPriceIndex |  |
|  | Group 3 [ttm=3] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | GrossPriceIndex |  |
|  | Group 3 [ttm=3] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | TotalReturnIndex |  |
|  | Group 3 [ttm=3] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | NetTotalReturnIndex |  |
|  | Group 4 [ttm=4] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | CleanPriceIndex |  |
|  | Group 4 [ttm=4] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | GrossPriceIndex |  |
|  | Group 4 [ttm=4] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | TotalReturnIndex |  |
|  | Group 4 [ttm=4] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | NetTotalReturnIndex |  |
|  | Group 5 [ttm=5] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | CleanPriceIndex |  |
|  | Group 5 [ttm=5] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | GrossPriceIndex |  |
|  | Group 5 [ttm=5] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | TotalReturnIndex |  |
|  | Group 5 [ttm=5] | Fixed-Term Corporate Bond Index (BBB- up)  | 10 | NetTotalReturnIndex |  |

##### [ESG Bond Index](https://www.thaibma.or.th/EN/Market/Index/ESGIndex.aspx)

from `https://www.thaibma.or.th/api/index/?bondType=esg` to [thaibma_index_bondtype-esg_data.JSON](...)

| Index | Value of `TtmGroupName` | Value of `Rating` | Value of `RatingOrder` | Key | Remarks |
|-------|-------------------------|-------------------|------------------------|-----|---------|
|  | ESG Bond Index | ทุกช่วงอายุ | 1 | CleanPriceIndex |  |
|  | ESG Bond Index | ทุกช่วงอายุ | 1 | GrossPriceIndex |  |
|  | ESG Bond Index | ทุกช่วงอายุ | 1 | TotalReturnIndex |  |
|  | ESG Bond Index | ทุกช่วงอายุ | 1 | NetTotalReturnIndex |  |
|  | Group 1 ( 1 < TTM <= 3 ) | 1 < TTM <= 3 | 1 | CleanPriceIndex |  |
|  | Group 1 ( 1 < TTM <= 3 ) | 1 < TTM <= 3 | 1 | GrossPriceIndex |  |
|  | Group 1 ( 1 < TTM <= 3 ) | 1 < TTM <= 3 | 1 | TotalReturnIndex |  |
|  | Group 1 ( 1 < TTM <= 3 ) | 1 < TTM <= 3 | 1 | NetTotalReturnIndex |  |
|  | Group 2 ( 3 < TTM <= 7 ) | 3 < TTM <= 7 | 1 | CleanPriceIndex |  |
|  | Group 2 ( 3 < TTM <= 7 ) | 3 < TTM <= 7 | 1 | GrossPriceIndex |  |
|  | Group 2 ( 3 < TTM <= 7 ) | 3 < TTM <= 7 | 1 | TotalReturnIndex |  |
|  | Group 2 ( 3 < TTM <= 7 ) | 3 < TTM <= 7 | 1 | NetTotalReturnIndex |  |
|  | Group 3 ( 7 < TTM <= 10 ) | 7 < TTM <= 10 | 1 | CleanPriceIndex |  |
|  | Group 3 ( 7 < TTM <= 10 ) | 7 < TTM <= 10 | 1 | GrossPriceIndex |  |
|  | Group 3 ( 7 < TTM <= 10 ) | 7 < TTM <= 10 | 1 | TotalReturnIndex |  |
|  | Group 3 ( 7 < TTM <= 10 ) | 7 < TTM <= 10 | 1 | NetTotalReturnIndex |  |
|  | Group 4 (TTM > 10) | TTM > 10 | 1 | CleanPriceIndex |  |
|  | Group 4 (TTM > 10) | TTM > 10 | 1 | GrossPriceIndex |  |
|  | Group 4 (TTM > 10) | TTM > 10 | 1 | TotalReturnIndex |  |
|  | Group 4 (TTM > 10) | TTM > 10 | 1 | NetTotalReturnIndex |  |
|  | Government Bond ESG Index | ทุกช่วงอายุ | 2 | CleanPriceIndex |  |
|  | Government Bond ESG Index | ทุกช่วงอายุ | 2 | GrossPriceIndex |  |
|  | Government Bond ESG Index | ทุกช่วงอายุ | 2 | TotalReturnIndex |  |
|  | Government Bond ESG Index | ทุกช่วงอายุ | 2 | NetTotalReturnIndex |  |
|  | SOE Bond ESG Index | ทุกช่วงอายุ | 3 | CleanPriceIndex |  |
|  | SOE Bond ESG Index | ทุกช่วงอายุ | 3 | GrossPriceIndex |  |
|  | SOE Bond ESG Index | ทุกช่วงอายุ | 3 | TotalReturnIndex |  |
|  | SOE Bond ESG Index | ทุกช่วงอายุ | 3 | NetTotalReturnIndex |  |
|  | Corporate Bond ESG Index | ทุกช่วงอายุ | 4 | CleanPriceIndex |  |
|  | Corporate Bond ESG Index | ทุกช่วงอายุ | 4 | GrossPriceIndex |  |
|  | Corporate Bond ESG Index | ทุกช่วงอายุ | 4 | TotalReturnIndex |  |
|  | Corporate Bond ESG Index | ทุกช่วงอายุ | 4 | NetTotalReturnIndex |  |
|  | Group 1 ( 1 < TTM <= 3 ) | 1 < TTM <= 3 | 4 | CleanPriceIndex |  |
|  | Group 1 ( 1 < TTM <= 3 ) | 1 < TTM <= 3 | 4 | GrossPriceIndex |  |
|  | Group 1 ( 1 < TTM <= 3 ) | 1 < TTM <= 3 | 4 | TotalReturnIndex |  |
|  | Group 1 ( 1 < TTM <= 3 ) | 1 < TTM <= 3 | 4 | NetTotalReturnIndex |  |
|  | Group 2 ( 3 < TTM <= 7 ) | 3 < TTM <= 7 | 4 | CleanPriceIndex |  |
|  | Group 2 ( 3 < TTM <= 7 ) | 3 < TTM <= 7 | 4 | GrossPriceIndex |  |
|  | Group 2 ( 3 < TTM <= 7 ) | 3 < TTM <= 7 | 4 | TotalReturnIndex |  |
|  | Group 2 ( 3 < TTM <= 7 ) | 3 < TTM <= 7 | 4 | NetTotalReturnIndex |  |
|  | Group 3 ( 7 < TTM <= 10 ) | 7 < TTM <= 10 | 4 | CleanPriceIndex |  |
|  | Group 3 ( 7 < TTM <= 10 ) | 7 < TTM <= 10 | 4 | GrossPriceIndex |  |
|  | Group 3 ( 7 < TTM <= 10 ) | 7 < TTM <= 10 | 4 | TotalReturnIndex |  |
|  | Group 3 ( 7 < TTM <= 10 ) | 7 < TTM <= 10 | 4 | NetTotalReturnIndex |  |
|  | Group 4 (TTM > 10) | TTM > 10 | 4 | CleanPriceIndex |  |
|  | Group 4 (TTM > 10) | TTM > 10 | 4 | GrossPriceIndex |  |
|  | Group 4 (TTM > 10) | TTM > 10 | 4 | TotalReturnIndex |  |
|  | Group 4 (TTM > 10) | TTM > 10 | 4 | NetTotalReturnIndex |  |

##### [ASEAN3 Government Bond Index](https://www.thaibma.or.th/EN/Market/Index/A3GBI.aspx)

from `https://www.thaibma.or.th/api/a3gbi` to [thaibma_a3gbi_data.JSON](...)

| Index | Value of `IndexNo` | Value of `IndexSeriesTitle` | Key | Remarks |
|-------|--------------------|-----------------------------|-----|---------|
|  | 1 | ASEAN3 Government Bond Index | IndexValue |  |
|  | 1 | ASEAN3 Government Bond Index | AverageCleanPrice |  |
|  | 2 | ASEAN3 Government Rupiah Bond Index | IndexValue |  |
|  | 2 | ASEAN3 Government Rupiah Bond Index | AverageCleanPrice |  |
|  | 3 | ASEAN3 Government Ringgit Bond Index | IndexValue |  |
|  | 3 | ASEAN3 Government Ringgit Bond Index | AverageCleanPrice |  |
|  | 4 | ASEAN3 Government Baht Bond Index | IndexValue |  |
|  | 4 | ASEAN3 Government Baht Bond Index | AverageCleanPrice |  |

#### Bond Price

_planned_

## License

_© Copyright & 🄯 Copyleft 2025 สาริศ ธนาโสภณ (A37). The scripts and documentation in this project are released under [GPLv3](https://github.com/saris-a37/quotes-crawler/blob/main/LICENSE)._
