# TFL - Oyster history scraper

This project will download your TFL history from the official TFL website in CSV format.

# Installation

```
bundle install
```

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

# Docker

Build docker image with:
```
docker build -t tfl-history .
```
Then you can run with a volume mount like this:

```
docker run -v "$PWD:/usr/src/app" tfl
```

Make sure you set the config.yaml to some path that you have write access.
