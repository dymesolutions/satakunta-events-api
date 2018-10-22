# Satakunta Events API

[Satakunta Events API](https://satakuntaevents.fi) is a Kotlin implementation, developed by Dyme Solutions Oy, of an open source Linked Events API developed by the City of Helsinki.

## Development requirements

* Java 8+
* PostgreSQL database with PostGIS extension (not needed if using Docker)
* Docker (optional but recommended)

## Configuring

### Database

The database access can be configured in */src/main/resources/hikari.properties* file or by setting the environment variables:

```
DATASOURCE_USER=linkedevents
DATASOURCE_PASSWORD=linkedevents
DATASOURCE_DATABASE=linkedevents
DATASOURCE_PORT=5432
DATASOURCE_HOST=linkedevents-data
```

The environment variables can be set in *docker-compose.yml* file.

### API

The API can be configured in */src/main/resources/app.properties*.

```
server.hostName				API URL configured here to be attached to the @id field of returned data.
server.uiUrl				The URL pointing to your UI server, usually same as hostname
app.defaultOrganization		ID for default organization for new users
app.moderatorEmails			Comma-separated list of E-mails that receive moderator notifications
```

If you're planning to use e-mail services, you will need to configure the e-mail server here.

## Building

* `gradlew build` or `gradlew.bat build`
* `docker-compose build`
* Alternatively run `build-all.sh`

The *docker-compose* command will build the PostGIS database container and the API container.

## Running

* `docker-compose up`

## Running locally without Docker

* `gradlew run` - starts an embedded Jetty server, navigate to `localhost:8080/api/v2/` to reach the API
* `gradlew run -PappArgs=migrate` - start the server and migrate initial data

A superuser is created and can be configured in file */src/main/resources/migrations/users.json*. **Make sure you change the password.**

---

Copyright 2018 Dyme Solutions Oy

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
