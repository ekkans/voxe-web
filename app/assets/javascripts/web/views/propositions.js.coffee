class window.PropositionsView extends Backbone.View
  
  tag: ->
    app.models.tag
  
  candidacies: ->
    app.collections.selectedCandidacies.toJSON()

  categories: ->
    categories = []
    candidacies = @candidacies()
    tags_propositions = @tags_propositions()
    _.each @tag().tags.toJSON(), (c) ->
      category = {}
      category.id = c.id
      category.name = c.name
      sections = []
      _.each c.tags, (s) ->
        section = {}
        section.id = s.id
        section.name = s.name
        section.candidacies = _.map candidacies, (c)->
          candidacy = {}
          candidacy.id = c.id
          candidacy.candidates = c.candidates
          if tags_propositions[section.id] && tags_propositions[section.id][candidacy.id]
            candidacy.propositions = tags_propositions[section.id][candidacy.id]
            candidacy
        sections.push section
      category.sections = sections
      categories.push category
    categories
  
  tags_propositions: ->
    hash = {}
    _.each app.collections.propositions.models, (proposition) ->
      candidacy = proposition.candidacy()
      _.each proposition.tags(), (tag) ->
        hash[tag.id] = {} unless hash[tag.id]
        hash[tag.id][candidacy.id] = [] unless hash[tag.id][candidacy.id]
        hash[tag.id][candidacy.id].push proposition.toJSON()
    hash
      
  initialize: ->
    app.collections.propositions.bind "reset", @render, @
    app.collections.selectedCandidacies.bind "reset", @loadPropositions, @
    app.models.tag.bind "change", @loadPropositions, @
  
  loadPropositions: ->
    if @candidacies().length != 0 && @tag().id
      $("#selected-theme #loader").fadeIn()
      candidacyIds = _.map app.collections.selectedCandidacies.models, (candidate) ->
           candidate.id
      candidacyIds = candidacyIds.join ','
      app.collections.propositions.fetch data: {electionIds: app.models.election.id, tagIds: app.models.tag.id, candidacyIds: candidacyIds}
  
  events:
    "click p": "selectProposition"
  
  selectProposition:(e) ->
    proposition = {id: $(e.currentTarget).attr("proposition-id")}
    app.models.proposition.set proposition
  
  render: ->
    loadHtml = ->
      $(@el).html Mustache.to_html($('#propositions-template').html(), tag: @tag(), categories: @categories())
      $('#propositions').fadeIn()
    loadHtml = _.bind(loadHtml, @)
    $("#selected-theme #loader").fadeOut(loadHtml)
