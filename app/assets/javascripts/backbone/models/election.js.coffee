class window.ElectionModel extends Backbone.Model
  
  # http://voxe.org/platform/models/election
  
  name: ->
    @get "name"
  
  candidacies: ->
    @get "candidacies"
    
  tags: ->
    @get "tags"
  
  toJSON: ->
    object = _.clone(@attributes)
    for key,value of object      
      if value instanceof Backbone.Model
        object[key] = value.toJSON()
    object
  
  parse: (response)->
    response.response.election
  
  url: ->
    "/api/v1/elections/#{@id}"
