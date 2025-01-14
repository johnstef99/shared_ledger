/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_3174063690")

  // update collection data
  unmarshal({
    "createRule": "(\n  @request.auth.id ?= @collection.ledgers.user_id\n  &&\n  ledger_id ?= @collection.ledgers.id\n)",
    "deleteRule": "(\n  @request.auth.id ?= @collection.ledgers.user_id\n  &&\n  ledger_id ?= @collection.ledgers.id\n)",
    "listRule": "(\n  @request.auth.id ?= @collection.ledgers.user_id\n  &&\n  ledger_id ?= @collection.ledgers.id\n)\n||\n(\n  ledger_id ?= @collection.ledgers_users.ledger_id\n  &&\n  @request.auth.email ?= @collection.ledgers_users.user_email\n)\n||\n(\n  contact_id ?= @collection.contacts.id\n  &&\n  @request.auth.email ?= @collection.contacts.email\n)",
    "updateRule": "(\n  @request.auth.id ?= @collection.ledgers.user_id\n  &&\n  ledger_id ?= @collection.ledgers.id\n)",
    "viewRule": "(\n  @request.auth.id ?= @collection.ledgers.user_id\n  &&\n  ledger_id ?= @collection.ledgers.id\n)\n||\n(\n  ledger_id ?= @collection.ledgers_users.ledger_id\n  &&\n  @request.auth.email ?= @collection.ledgers_users.user_email\n)\n||\n(\n  contact_id ?= @collection.contacts.id\n  &&\n  @request.auth.email ?= @collection.contacts.email\n)"
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_3174063690")

  // update collection data
  unmarshal({
    "createRule": null,
    "deleteRule": null,
    "listRule": null,
    "updateRule": null,
    "viewRule": null
  }, collection)

  return app.save(collection)
})
