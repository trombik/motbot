# Design

`heroku` was chosen as a platform to run the application because `heroku`
provides free `dyno` hours up to 1000 hours per month. The application does
not need to run all the time, and it will consume few `dyno` hours. The free
scheduler does not grantees reliability, but the application does not need it.

## Table of Contents

<!-- toc -->

- [Components](#components)
  - [Application](#application)
  - [Scheduler](#scheduler)
- [Implementation](#implementation)

<!-- tocstop -->

## Components

The application consists of two components.

### Application

An instance of `motbot`, running in a `heroku` `dyno` container.

### Scheduler

A job manager that runs the application, provisioned on the `heroku` app.

## Implementation

A scheduler periodically runs the application at a certain interval. The
interval can be modified from the `heroku` dashboard.

When the application wakes up, it compares the date and time of the events
with the current time (UTC+7), and selects events that match the current date.

The application posts the events to Twitter using the APIs.

The application searches tweets that:

- mention the bot,
- and contain a certain hashtag

The application post the results of the search to FIXME.

The application terminates, and sleeps.
