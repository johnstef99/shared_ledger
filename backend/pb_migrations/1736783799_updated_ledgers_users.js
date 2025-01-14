/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_464947611")

  // update collection data
  unmarshal({
    "createRule": "@request.auth.id ?= @collection.ledgers.user_id\n&&\nledger_id ?= @collection.ledgers.id",
    "deleteRule": "@request.auth.id ?= @collection.ledgers.user_id\n&&\nledger_id ?= @collection.ledgers.id",
    "listRule": "(@request.auth.id ?= @collection.ledgers.user_id\n&&\nledger_id ?= @collection.ledgers.id)\n||\n(\n  @request.auth.email = user_email\n)",
    "updateRule": "@request.auth.id ?= @collection.ledgers.user_id\n&&\nledger_id ?= @collection.ledgers.id",
    "viewRule": "(@request.auth.id ?= @collection.ledgers.user_id\n&&\nledger_id ?= @collection.ledgers.id)\n||\n(\n  @request.auth.email = user_email\n)"
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_464947611")

  // update collection data
  unmarshal({
    "createRule": null,
    "deleteRule": null,
    "listRule": "@request.auth.id ?= @collection.ledgers.user_id",
    "updateRule": null,
    "viewRule": null
  }, collection)

  return app.save(collection)
})
