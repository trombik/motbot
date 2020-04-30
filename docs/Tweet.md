# Tweet

The application reads tweets from files, and posts them when appropriate. This
document describe the file format.

<!-- toc -->

## Quick start

See [example.yml](../assets/tweets/example.yml), which has plenty of comments.

Use [template.yml.dist](../assets/tweets/template.yml.dist) as a template.

## File

Tweet files are located under `assets/tweets`.

A file name of Tweet file:

- SHOULD be lower cased
- MUST NOT include spaces
- MUST end with `.yml`
- MUST be ASCII characters
- MUST NOT contain characters other than English alphabets, numbers, `-`
  (dash), `_` (underscore), and `.` (dot)

An example is `this_happened_on_that_day.yml`.

## Format

A Tweet file MUST be in YAML format. [YAML Tutorial: Everything You Need to
Get Started in Minutes](https://rollout.io/blog/yaml-tutorial-everything-you-need-get-started/)
explains the basics.

Use 2 spaces for indent.

Use `LF` for line break.

Use UTF-8 for file encoding.

## Structure

A Tweet file MUST start with `---` (three dashes).

```yaml
---
# Always place three dashes at the beginning of the file!
```

The file MUST have two top level keys, `tweet` and `meta`.

### `tweet`

`tweet` top level key MUST have three keys, `status`, `possibly_sensitive`,
and `media_files`.

#### `status`

`status` is the content of the tweet.

```yaml
---
tweet:
  status: |
    This is the content of the tweet.
```

The content MUST be the original content of `authors` described below.

Break lines at 80 characters.

`status` is mandatory.

#### `media_files`

Relative path from `assets/media` to images to upload and attach to the tweet.
The referenced file MUST exist in the path.

The maximum number of images is four.

Supported image format includes:

- PNG
- GIF
- JPEG

`media_files` is optional.

#### `possibly_sensitive`

Set this key to `true` if `media_files` contains sensitive contents.

From [the official API document](https://developer.twitter.com/en/docs/tweets/post-and-engage/api-reference/post-statuses-update):

> If you upload Tweet media that might be considered sensitive content such as
> nudity, or medical procedures, you must set this value to true.

`possibly_sensitive` is optional.

### `meta`

`meta` top level key includes `timestamp`, `state`, `sources`, and `authors`.

#### `timestamp`

`timestamp` is the time when the event in the tweet happened.

The format includes:

- ISO 8601 format, `YYYY-MM-DDThh:mm:ss` without timezone,
  `YYYY-MM-DDThh:mm:ss+07:00` with timezone. An example is
  `2020-04-26T07:27:55+07:00` (note the `T` between the date and the time).
- `YYYY-MM-DD`

If timezone is omitted, `UTC+7`, or local time zone in Thailand,  is assumed.

`timestamp` is mandatory.

#### `state`

`state` is the state of the tweet. If `state` is `disabled`, the tweet will
not be posted. If the tweet does not have `state`, the tweet will be posted.

Note that, even if you set `state: disabled`, the application does not delete
old tweets.

`state` is optional.

#### `sources`

`sources` is a list of URLs, where users can find the details of the event.

Twitter will show a Twitter card, a descriptive picture of the page, below the
tweet when the site has a Twitter card. You can see if the page has a Twitter
card at [https://cards-dev.twitter.com/validator](https://cards-dev.twitter.com/validator)
(requires a Twitter account). When multiple `sources` are given, Twitter shows
Twitter card of the _last_ one. See which source has better Twitter card by
using the Twitter's validator.

URLs for `sources` SHOULD be chosen with care. Rule of thumb:

- Does the site have _real_ permanent URLs? News sites often change URLs. If
  no, consider the use of [web.archive.org](http://web.archive.org/).
- Is the page behind pay-wall? Pages NOT behind pay-wall are preferred.

The following sites are known to preserve URLs to articles.

- [The Guardian](https://www.theguardian.com/)
- [Reuters](https://www.reuters.com/)
- [BBC](https://www.bbc.com/)
- [Khaosod English](https://www.khaosodenglish.com/)
- [New Mandala](https://www.newmandala.org/)

The following sites are NOT recommended for `sources` because they often
delete articles and change URLs.

- [The Nation Thailand](https://www.nationthailand.com/)
- [Bangkok Post](https://www.bangkokpost.com/)

`sources` is optional.

#### `authors`

`authors` is a list of authors of _the tweet_. Not the author of `sources`.

Valid values of `authors` include:

- Full name
- Twitter account name

`authors` is mandatory.
