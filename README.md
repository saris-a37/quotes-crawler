# Quotes Crawler

Scripts for automatic crawling of quotes from different durations into a single JSON file

> [!WARNING]
> This project comes with no guarantee as it has no official support from the quotes sources, and therefore may breaks in case of API change.

## Currently supported sources

- [x] [GPF](https://www.gpf.or.th/thai2019/About/main.php?page=memberfund&lang=en&menu=statistic): all securities, entire duration since inception, up to 15 minutes delay ([more details](#gpf))

### GPF

The script combines JSONs from `gpf.or.th`'s API (https://www.gpf.or.th/thai2019/About/memberfund-api.php), which is the source of monthly datasets shown in [GPF's fund value page](https://www.gpf.or.th/thai2019/About/main.php?page=memberfund&lang=en&menu=statistic), into a single file [gpf_data.json](https://raw.githubusercontent.com/saris-a37/quotes-crawler/refs/heads/main/GPF/gpf_data.json). The JSON format is exactly the same as originally queried from the API. All past and present GPF's securities listed on its website is currently supported. Data include all quotes available since each security's inception. Note that there may be up to 15 minutes delay in data fetching.

## License

_© Copyright & 🄯 Copyleft 2025 สาริศ ธนาโสภณ (A37). The scripts and documentation in this project are released under [GPLv3](https://github.com/saris-a37/quotes-crawler/blob/main/LICENSE)._
