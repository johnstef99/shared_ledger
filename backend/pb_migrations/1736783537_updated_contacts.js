/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_1930317162")

  // update collection data
  unmarshal({
    "listRule": "@request.auth.id = user_id \n|| @request.auth.email = email\n|| (\n  @collection.ledgers_users.user_email ?= @request.auth.email\n  &&\n  @collection.ledgers.user_id = user_id\n  &&\n  @collection.ledgers_users.ledger_id ?= @collection.ledgers.id\n)"
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_1930317162")

  // update collection data
  unmarshal({
    "listRule": "@request.auth.id = user_id"
  }, collection)

  return app.save(collection)
})
