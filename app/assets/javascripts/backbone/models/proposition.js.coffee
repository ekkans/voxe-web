class window.PropositionModel extends Backbone.Model
  
  # http://voxe.org/platform/models/proposition
  
  candidacy: ->
    @get "candidacy"
  
  candidacies: ->
    @get "candidacies"
  
  tags: ->
    @get "tags"
    
  id: ->
    @get "id"
    
  text: ->
    @get "text"

  url: ->
    "/api/v1/propositions/#{@id}"

  parse: (response) ->
    response.response.proposition

  addEmbed: (url) ->
    model = @
    $.ajax
      type: 'POST'
      url: "#{@url()}/addembed"
      data: {url: url}
      success: (response) ->
        model.set embeds: response.response.proposition.embeds
        model.trigger 'change'
