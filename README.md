# shrnk

Yet another URL shortening app.


## Development
### Installation

Clone the repository:
```
git clone <git/ssh:/path/to/repo>
```

Install ruby dependencies:
```
bundle install
```

Install javascript dependencies:
```
yarn install
```

Copy and populate configuration files:
```
cp config/*.yml.example config/*.yml
```

Setup the database:
```
bin/rails db:setup
```

#### MaxMindDB

A local MaxMind DB is used to record the city and country of a visitor via IP address.

##### Download and reference local database

Download the local database [here](http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz). ([full site](https://dev.maxmind.com/geoip/geoip2/geolite2/))

After unpacking the file, move `GeoLite2-City.mmdb'` to `lib`.