Market Place API
================
Code from the APIs on Rails book: http://apionrails.icalialabs.com/book/

Outstanding Questions:
* API Authorization
* API Authentication (OAuth vs Token Auth)

#####CURL examples:
Authenticate
```
curl -H 'Accept: application/vnd.marketplace.v1' \
-H 'Content-Type: application/json' \
-v -X POST http://api.lvh.me:3000/sessions -d "{\"email\":\"berniece@walsh.name\", \"password\":\"admin1234\"}"
```

Index orders using auth token
```
curl -H 'Accept: application/vnd.marketplace.v1' \
-H 'Content-Type: application/json' \
-H 'Authorization: 4i2XHx8dUq5s2CkFpyah' \
-v -X GET http://api.lvh.me:3000/users/1/orders
```

Create order
```
curl -H 'Accept: application/vnd.marketplace.v1' \
-H 'Content-Type: application/json' \
-H 'Authorization: 4i2XHx8dUq5s2CkFpyah' \
-v -X POST http://api.lvh.me:3000/users/1/orders -d "{\"order\":{\"product_ids_and_quantities\": [[1, 2], [2, 2]]}}"
```