# Postfix Module to relay mail via Sendgrid

A small module that configures Postfix for use with Sendgrid. Almost everything shamelessly lifted from https://github.com/oddhill/oddboxen

## Usage
Enter your Sendgrid credentials in hiera:

postfix::sendgrid::username: username
postfix::sendgrid::password: pw

Then simply:

```include postfix```
