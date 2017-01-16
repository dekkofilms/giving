## Giving

#### Coming to the App Store soon!

<p align="center">
  <img src="http://i.imgur.com/bSHR8sj.png" max-width="100%">
</p>

#### This is an iOS app built in Swift by Taylor King.

This app was built to not only make giving easy, but more of a routine that is consistent in our lives. There are many awesome organizations and charities that would hopefully benefit from such an app.

Technologies & API's used:

* Node.js
* Postgres
* Swift
* Heroku
* Alamofire
* Plaid
* Stripe

## Challenges:

* This is my first big iOS app that I tackled in Swift, and I really really enjoyed writing in Swift when I have mainly been a Javascript developer. I learned a lot about a strong typed language, and interacting with a GUI for the first time building it in Xcode.

* Linking a user's bank account was a minor hurdle just because the API I worked with didn't actually have native swift integration for the app, so the work around was using a WKWebview in Xcode that loads up a page within my app, and then it works as functions.

* Rounding up NEW transactions was a fun and interesting challenge. I interacted with Webhooks that Plaid provides. They check 4-6 times a day for new activity in users banks', and I was specifically interested in their Webhook code 2. When that gets fired off, the coding magic happens.

## Walkthrough:

### 1. Link up your bank account in a secure and safe way!

<p align="center">
<img src="http://i.imgur.com/N3gc9dZ.png" width="300px">
</p>

### 2. Choose a few of your favorite charities

<p align="center">
<img src="http://i.imgur.com/TozCDRi.gif">
</p>


### 3. That's it!

This is an app designed to safely and securely round up all of your approved transactions to the nearest dollar, and give what's left over to awesome charities and non-profits that you choose. It will automatically push your round ups to the organizations that you choose once you hit a threshold of $5.00 or more.

<p align="center">
<img src="http://i.imgur.com/OqBpdVd.png" width="300px">
</p>

## Backend

My backend link is <a href="https://github.com/dekkofilms/backend/tree/master">here</a>.

## Thanks! Let's start giving!
