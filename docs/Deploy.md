# Deploy

## Environment variables

The following environment variables must be set.

| Name                      | Description                        |
|---------------------------|------------------------------------|
| `TWITTER_CONSUMER_KEY`    | Consumer key                       |
| `TWITTER_CONSUMER_SECRET` | Consumer secret                    |
| `TWITTER_ACCESS_TOKENS`   | Access tokens separated with space |
| `TWITTER_ACCESS_SECRETS`  | Access keys separated with space   |
| `MOTBOT_LANGS`            | Languages separated with space     |
| `TZ`                      | Time zone ("Asia/Bangkok")         |

### `TWITTER_CONSUMER_KEY` and `TWITTER_CONSUMER_SECRET`

`TWITTER_CONSUMER_KEY` and `TWITTER_CONSUMER_SECRET` should be same in all
environment.

### `TWITTER_ACCESS_TOKENS`, `TWITTER_ACCESS_SECRETS`, and `MOTBOT_LANGS`

`TWITTER_ACCESS_TOKENS` is a list of user access tokens, separated by space.
Others are same. The order of tokens, secrets, and languages does matter.

```
export TWITTER_ACCESS_TOKENS="USER_A_TOKEN USER_B_TOKEN"
export TWITTER_ACCESS_SECRETS="USER_A_SECRET USER_B_SECRET"
export MOTBOT_LANGS="USER_A_LANG USER_B_LANG"
```

Supported languages:

* `en`
* `ja`
