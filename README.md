# zusammen

Telegram bot to operate http domain list.
See [listen.rb](https://github.com/elhowm/zusammen/blob/master/app/interactors/bot/listen.rb#L3) for commands list.

## Setup

1. Set correct values in .env.docker
2. Generate .htpasswd for nginx if you want to use it
3. See docker-compose.yml for details
4. `rake run`

## Debug

`rake console`

## Run tests

`rspec`
