class Backoffice.Router extends Backbone.Router
  routes:
    '': 'home'

  home: ->
    Backoffice.RouterInstance.navigate('elections', trigger: true)
