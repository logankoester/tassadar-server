# As a service

For your convenience, a free API is provided, limited to 100 requests/hr. Visit [Tassadar on Mashape](https://www.mashape.com/logankoester/tassadar) to grab an API key and the SDK for your language, then enjoy!

---

# Run your own

This simple rack-based web service uses the pure-ruby [Tassadar](https://github.com/agoragames/tassadar) library to parse uploaded Starcraft II replay files and send a JSON response.

This service is designed to enable Tassadar in polyglot or browser-based projects where Ruby may not be the significant language.

    $ gem install tassadar-server

## Usage

#### Options

The server can be configured using the following environment variables:

|-----------------+-------------+---------|
| Option          | Description | Details |
|:----------------|:------------|--------:|
| THROTTLE | Allowed requests per hour | for each user |
| REDIS_URL | Redis server | Required if THROTTLE is enabled |
| WHITELIST | Comma-separated list of allowed IP addresses | Optional |
| USER_HEADER | Header containing unique user id | Defaults to IP address |

#### Start the server

    $ rackup ./config.ru

You can also mount tassadar-server into a Rails 3 application, or use unicorn to set up a cluster of workers for increased load.

#### Parse a replay

    $ http -f POST http://localhost:9292/sc2/replay file@example.SC2Replay
    POST /sc2/replay HTTP/1.1
    Host: localhost:9292
    Content-Type: multipart/form-data; boundary=cd85979359044d7cac045667d
    cf591c3
    Accept-Encoding: gzip, deflate, compress
    Accept: */*
    Content-Type: application/json
    Content-Length: 633
    Server: WEBrick/1.3.1 (Ruby/1.9.3/2012-04-20)
    Date: Thu, 03 Jan 2013 01:32:21 GMT
    Connection: Keep-Alive

~~~
    { "replay": {
        "game": {
            "category": "Ladder",
            "map": "Delta Quadrant",
            "speed": "Faster",
            "time": "2011-07-05 18:01:08 -0400",
            "type": "1v1",
            "winner": {
                "actual_race": "Zerg",
                "chosen_race": "Zerg",
                "handicap": 100,
                "id": 2569192,
                "name": "redgar",
                "won": true,
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 66,
                    "blue": 255
                }
            }
        },
        "players": [
            {
                "player": {
                    "actual_race": "Terran",
                    "chosen_race": "Terran",
                    "handicap": 100,
                    "id": 1918894,
                    "name": "guitsaru",
                    "won": false,
                    "color": {
                        "alpha": 255,
                        "red": 180,
                        "green": 20,
                        "blue": 30
                    }
                }
            },
            {
                "player": {
                    "actual_race": "Zerg",
                    "chosen_race": "Zerg",
                    "handicap": 100,
                    "id": 2569192,
                    "name": "redgar",
                    "won": true,
                    "color": {
                        "alpha": 255,
                        "red": 0,
                        "green": 66,
                        "blue": 255
                    }
                }
            }
        ]
    }
}
~~~

---

# As a Ruby gem

A fast Starcraft 2 replay parser written in pure Ruby.

    $ gem install tassadar
    
## Installation

Add this line to your application's Gemfile:

    gem 'tassadar'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tassadar

## Usage

Create a replay object:

    replay = Tassadar::SC2::Replay.new(path_to_replay)

All of the important information is in the game object:

    replay.game
    => #<Tassadar::SC2::Game:0x007f9e41e31408 @winner=#<Tassadar::SC2::Player:0x007f9e41e31728 @name="redgar", @id=2569192, @won=true, @color={:alpha=>255, :red=>0, :green=>66, :blue=>255}, @chosen_race="Zerg", @actual_race="Zerg", @handicap=100>, @time=2011-07-05 17:01:08 -0500, @map="Delta Quadrant">

Or the player objects:

    replay.players.first
    => #<Tassadar::SC2::Player:0x007f9e41e31a48 @name="guitsaru", @id=1918894, @won=false, @color={:alpha=>255, :red=>180, :green=>20, :blue=>30}, @chosen_race="Terran", @actual_race="Terran", @handicap=100>

---

# Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
