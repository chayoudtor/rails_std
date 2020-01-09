## Basic CRUD application

### To start project
```
$ docker-compose up --build -d
$ docker-compose run web rails db:create
$ docker-compose run web rails db:migrate

Check out http://localhost:3000 
```