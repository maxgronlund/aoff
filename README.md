# AOFF

Minimalistic site for AOFF. Only basic esential features to manage an organic purchasing association.

Goals:
* Make a system with a minimum CO2 footprint
* Make it super easy to use by limit features to a bare minimum
* Make the system super responsive

This accomplshed with:

* Minimal CSS
* Minimal JS
* Compile to Erlang

## Getting started
First you have to set up some environment variables

    export POSTGRES_USER='YOU POSTGRES USER'
    export POSTGRES_USERNAME='YOUR POSTGRES USERNAME'
    export POSTGRES_PASSWORD='YOU POSTGRES PASSWORD'
    export AOFF_AWS_S3_BUCKET='aoff'
    export AOFF_AWS_ACCESS_KEY_ID='ASK MAX-GRØNLUND FOR THIS'
    export AOFF_AWS_SECRET_ACCESS_KEY='ASK MAX-GRØNLUND FOR THIS'
    export AOFF_AWS_REGION='eu-west-1'
    export AOFF_SEND_GRID_API_KEY='ASK MAX-GRØNLUND FOR THIS'
    export EPAY_MERCHANT_NR='ASK MAX-GRØNLUND FOR THIS'
    export EPAY_ENDPOINT='https://aoff.dk'

Then you can create the database
```
$ mix ecto.create
```

Then you can migrate the database
```
$ mix ecto.migrage
```
Seed the database
```
$ mix run apps/aoff/priv/repo/seeds.exs
```

## Image aspect ratio
The [aspect ratio](https://en.wikipedia.org/wiki/Aspect_ratio_(image)) for images is based on the [golden ratio](https://en.wikipedia.org/wiki/Golden_ratio)

### Image
- stamp: 100x62
- thumb: 310x192
- original 720x445


## Gettext
Translations: when a new translaton is added or one is modified

```
mix gettext.extract --merge
```
Then look in side apps/aoff_web/priv/gettext/da/LC_MESSAGES/default.po

## Operations
The system relies on a couple of external serveces:

- Heroku: production server
- Sendgrid: send email
- Amazon S3: Storage for images and large files
- Bambora: Payment gateway
- Cloudflare: DNS and firewall
- CPSMS: sending emails


Run migration on heroku
```
heroku run "POOL_SIZE=2 mix ecto.migrate"
```

Run phoenix from the console
```
heroku run "POOL_SIZE=2 iex -S mix"
```

## NOTICE
- The landing page will chrash if there are no dates in the DB

 ## Deploy
```
 git push heroku master
```

## Push to git
```
git push origin master
```

heroku run "POOL_SIZE=2 mix run apps/aoff/priv/repo/seeds.exs" --app aoff

## ngrok
Test payment on local host
install ngrok in your user folder

./ngrok http 4000

setup EPAY_ENDPOINT in your environt variables

##Reload terminal
$ source ~/.zshrc


##Backup
https://devcenter.heroku.com/articles/heroku-postgres-backups

List backups
```
$ heroku pg:backups --app aoff
```

Dowhload backup, re
```
$ heroku pg:backups:download --app aoff
```

Schedule backups
```
heroku pg:backups:schedule DATABASE_URL --at '02:00 Europe/Copenhagen' --app aoff
```

Restore on localhost, replace POSTGRES_USER and DATABASE_NAME
```
$ pg_restore --verbose --clean --no-acl --no-owner -h localhost -U maxgronlund -d aoff_dev latest.dump
```

## Smiley
https://www.findsmiley.dk/om_smiley/info_til_virksomheder/Sider/Generelt/Hent_smileyer.aspx

