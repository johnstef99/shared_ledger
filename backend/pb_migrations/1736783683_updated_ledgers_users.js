/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_464947611")

  // update collection data
  unmarshal({
    "listRule": "@request.auth.id ?= @collection.ledgers.user_id"
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_464947611")

  // update collection data
  unmarshal({
    "listRule": null
  }, collection)

  return app.save(collection)
})
