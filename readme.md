# TFL - Oyster history scraper

This project will download your TFL history from the official TFL website in CSV format.

# Configuration

In config.yaml:
* username: Username that you use for logging in
* password: Password that you use for logging in
* weeks: How many weeks data you want to download
* location: the location where you want to store the file

# Usage

```
ruby download.rb
```

Then you should find your file in location defined by config.yaml.

The format of the CSV is the following as of (2016-10-06)
```
Date,Start Time,End Time,Journey/Action,Charge,Credit,Balance,Note
```
