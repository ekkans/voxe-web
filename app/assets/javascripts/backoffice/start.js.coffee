window.Backoffice =
  Views: {}
  Router: {}

$ ->
  Backoffice.RouterInstance = new Backoffice.Router()

  Backbone.history.start(pushState: true)
