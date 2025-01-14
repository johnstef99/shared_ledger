/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_1212822754")

  // update collection data
  unmarshal({
    "createRule": "user_id = @request.auth.id",
    "deleteRule": "user_id = @request.auth.id",
    "listRule": "@request.auth.id != null",
    "updateRule": "user_id = @request.auth.id",
    "viewRule": "@request.auth.id != null"
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_1212822754")

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
