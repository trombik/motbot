# Tweet

The application reads tweets from files, and posts them when appropriate. This
document describe the file format.

<!-- toc -->

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

Break lines at 80 characters.

#### `possibly_sensitive`

Set this key to `true` if `media_files` contain sensitive content.

From [the official API document](https://developer.twitter.com/en/docs/tweets/post-and-engage/api-reference/post-statuses-update):

> If you upload Tweet media that might be considered sensitive content such as
> nudity, or medical procedures, you must set this value to true.

#### `media_files`

Relative path from `assets/media` to images to upload and attach to the tweet.
The referenced file MUST exist in the path.

The maximum number of images is four.

Supported image format includes:

- PNG
- GIF
- JPEG
