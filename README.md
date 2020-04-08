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


## Image aspect ratio
The [aspect ratio](https://en.wikipedia.org/wiki/Aspect_ratio_(image)) for images is based on the [golden ratio](https://en.wikipedia.org/wiki/Golden_ratio)

###Image
- stamp: 100x62
- thumb: 310x192
- original 720x445


##TODO
* Apply order number when payment has been going thrue
* Hide dublet order items, make nice query for the page instead


## Gettext
.pot (Portable Object Template).

[guide from platformatec](http://blog.plataformatec.com.br/2016/03/using-gettext-to-internationalize-a-phoenix-application/).

Create the default.pot file. with the text from the interface.
Dont't edit this file!

```
mix gettext.extract
```

### .po file (Portable Object)
To get started and generete the structure based on the .pot files. Run.

```mix gettext.merge priv/gettext```



To update the po files when something is added.

```mix gettext.extract --merge```


 heroku run "POOL_SIZE=2 mix hello.task"

 ## Deploy

 git push heroku master

 migrations:
  heroku run "POOL_SIZE=2 mix ecto.migrate"