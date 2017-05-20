# Homeless Children's Playtime Project

## About

*The mission of the [Homeless Children's Playtime Project](http://www.playtimeproject.org/) is to nurture healthy child development and reduce the effects of trauma among children living in temporary housing programs in Washington, DC.*

*Playtime seeks to create a city that provides every opportunity for children in families experiencing homelessness to succeed by ensuring consistent opportunities to play and learn, offering support services for families, and advocating for affordable housing and safe shelter.*

### About this App

The goal of this application is to allow supporters to donate toys and other items that help advance the work of Playtime Project's work in family shelters throughout DC. This application will allow donors to view the organization's Amazon wish lists, add items, track contributions, and aid staff in following up with donors.

## Contribution policy

For any changes, please create a feature branch and open a PR for it when you feel it's ready to merge. Even if there's no real disagreement about a PR, at least one other person on the team needs to look over a PR before merging. The purpose of this review requirement is to ensure shared knowledge of the app and its changes and to take advantage of the benefits of working together changes without any single person being a bottleneck to making progress.

## Getting Started

The team leads are currently compiling the tasks for this project. These will be made available soon. It is likely that we'll be doing a Rails build, but we are holding off on any design decisions until our team is assembled. We welcome you to join us. We need a wide variety of skillsets and experience levels. If you have any experience working with Amazon's API, it would be fantastic to have your help.

### Getting Amazon OAuth working locally

* Create an Application in Amazon [here](https://github.com/wingrunr21/omniauth-amazon#prereqs)
* Copy RAILS_ROOT/.env.sample to .env
* Edit .env and add the values from your Amazon App page
* Start your Rails app. You're ready to OAuth!


### Getting Amazon Advertising API working locally
* sign up to use the Advertising API [Amazon](https://affiliate-program.amazon.com/gp/flex/advertising/api/sign-in.html)
* you will need to then need to add the following to your .env families
** AWS_ACCESS_KEY: YOUR_ACCESS_KEY_GOES_HERE
** AWS_SECRET_KEY: YOUR_SECRET_KEY_GOES_HERE
** AWS_ASSOCIATES_TAG: playtim009-20

## Deploying

### Environment

* `AMAZON_CLIENT_ID`: for OAuth
* `AMAZON_CLIENT_SECRET`: for OAuth
