class window.PropositionView extends Backbone.View
  events:
    "click a.close": "close"
    
  initialize: ->
    app.models.proposition.bind "change", @render, @
  
  close: ->
    $('.modal').fadeOut(200)
    
  candidacies:(proposition) ->
    _.map proposition.candidacy(), (c) ->
      c = app.collections.candidacies.get c
      c = c.toJSON()
      candidacy = {}
      candidacy.candidates = c.candidates
      candidacy
  
  proposition: ->
    proposition = app.collections.propositions.get app.models.proposition.id
    proposition.set {candidacies: @candidacies(proposition)}
    proposition
  
  render: ->
    proposition = @proposition()
    $("#quote", @el).html Mustache.to_html($('#proposition-template').html(), proposition: proposition)
    $('.modal').fadeIn(200)