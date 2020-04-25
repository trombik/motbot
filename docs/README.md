# Memories of Thailand bot, `motbot`

## Rationale

Thailand has two versions of its history; a history you are familiar with in
general, i.e. a history that is studied and peer-reviewed by academics, told
and discussed by people and media outlets, and another that is poorly
researched, rarely discussed, and hardly criticised, i.e. an official state
narrative. The former is banned in Thailand, and even foreign media outlets do
not dare to talk about it. The latter is what Thais are _told_ to believe, and
what most of non-Thais are told as the _true_ Thai history. Thai history needs
to be freed.

History repeats itself because people forget experiences from the history.
Sadly, we do. I do. Thais do. You cannot forget if you do not know what
happened in the first place, which is often the case in Thailand where
discussion and critical thinking is considered as act of challenging superior,
or even a threat to _national security_. Thai history needs to be told,
shared, and kept in our memory.

We need something that tells, and reminds people of, events, incidents, and
experiences from media reports, and academic studies of Thai history.

## Purpose

The purpose of this twitter bot is to encourage Thais and non-Thais to
understand historical events of Thailand in the past and the current context.

## Repository

The source code of the bot is managed by [`git`](https://git-scm.com/), and
hosted on [GitHub](https://github.com/).

The repository is owned by [`trombik`](https://github.com/trombik).

## What it does

The bot tweets historical events on the date, and time where available, they
happened. An example:

```text
Ten years ago today, this classic photo was taken at ...

[a picture follows]
```

When a user mentions the bot in a tweet with a pre-defined hash tag, it
forwards the tweet to the project owner as a possible user submission. An
example:

```text
@motbot, this might interest you as a candidate...

#mot_submission
[a URL follows]
```

The bot blocks users when it considers the user is spamming.

## What it doesn't

The bot does not follow anyone.

The bot does not reply to users when mentioned without a pre-defined hash tag.

## Tweets

The bot has a database of tweets. A record of a tweet consists of:

- text of the tweet
- zero or more of media contents or URLs
- date of the event
- meta data of the tweet, such as `status: disabled`, `creator: @ytrombik`,
  `tags: redshirts, 2007`

New entry to the database is accepted by submission via GitHub Issues, or
GitHub Pull Request. A submitter MUST have a GitHub account, and, optionally,
twitter account.

Anyone without GitHub account MAY suggest new entry by mentioning the bot in
their tweet.

### Criteria of submission by users

An entry in the database MUST meet the following requirements:

- it MUST NOT violate [Twitter Terms of Service"](https://twitter.com/en/tos).
  This always supersedes other requirements.
- it MUST have a public resource to verify the content of the tweet, usually,
  an URL.
- its text SHOULD be neutral point of view. Everyone is biased, but try to be
  neutral.
- its text MAY include a context to explain the background
- its text MUST be original, MUST not be copy of others
- its media content MUST be either:
  - an URL to the media
  - an original material of the submitter
  - a copy of other's material with verifiable source, under permission of the
    original copyright holder, or within "Fair use" or "Fair dealing". The
    original copyright holder will be mentioned in the tweet

Additionally, when a user submits by mentioning the bot in Twitter,

- The user MUST have tweeted at least 3000 tweets in the past
- The user account MUST be older than one year
- The tweet MUST contain a URL

## Roles and responsibilities

### The owner of the repository

The owner of the repository:

- Owes ultimate responsibility to the project and its consequences.
- Accepts or rejects user submissions
- Adds or removes project members
