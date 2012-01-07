#= require ../libs/underscore-1.2.0
#= require ../libs/backbone-0.5.3
#= require_tree ../libs/bootstrap-1.3.0
#= require hamlcoffee
#= require_self
#= require_tree ../backbone/models
#= require_tree ../backbone/collections
#= require_tree ./templates
#= require_tree ./views

window.Backoffice =
  Views:
    Election: {}
  ViewInstances:
    Election: {}
  Router: Backbone.Router.extend(
    routes:
      '': 'index'
      'countries': 'countries'
      'elections': 'elections'
      'elections/:id': 'election'
      'elections/:election_id/:menu_entry': 'election'
      'elections/:election_id/tags/:id': 'tag'
      'elections/:election_id/propositions/candidacies/:id': 'propositions_candidacy_tags'
      'elections/:election_id/propositions/candidacies/:candidacy_id/tags/:id': 'propositions_candidacy_tag'

    index: ->
      @.navigate 'elections', true
    countries: ->
      new Backoffice.Views.CountriesView()
    elections: ->
      if Backoffice.ViewInstances.Elections
        Backoffice.ViewInstances.Elections.render()
      else
        Backoffice.ViewInstances.Elections = new Backoffice.Views.ElectionsView()
    election: (id, menu_entry) ->
      if menu_entry
        if Backoffice.ViewInstances.Election[id]
          Backoffice.ViewInstances.Election[id].go_to(menu_entry: menu_entry)
        else
          Backoffice.ViewInstances.Election[id] = new Backoffice.Views.ElectionView(election_id: id, menu_entry: menu_entry)
      else
        console.error 'wrong route'
    tag: (election_id, tag_id) ->
      if Backoffice.ViewInstances.Election[election_id]
        Backoffice.ViewInstances.Election[election_id].go_to menu_entry: 'tag', tag_id: tag_id
      else
        Backoffice.ViewInstances.Election[election_id] = new Backoffice.Views.ElectionView(election_id: election_id, menu_entry: 'tag', tag_id: tag_id)
    propositions_candidacy_tags: (election_id, candidacy_id) ->
      if Backoffice.ViewInstances.Election[election_id]
        Backoffice.ViewInstances.Election[election_id].go_to menu_entry: 'propositions_candidacy_tags', candidacy_id: candidacy_id
      else
        Backoffice.ViewInstances.Election[election_id] = new Backoffice.Views.ElectionView(election_id: election_id, menu_entry: 'propositions_candidacy_tags', candidacy_id: candidacy_id)
    propositions_candidacy_tag: (election_id, candidacy_id, tag_id) ->
      if Backoffice.ViewInstances.Election[election_id]
        Backoffice.ViewInstances.Election[election_id].go_to menu_entry: 'propositions_candidacy_tag', candidacy_id: candidacy_id, tag_id: tag_id
      else
        Backoffice.ViewInstances.Election[election_id] = new Backoffice.Views.ElectionView(election_id: election_id, menu_entry: 'propositions_candidacy_tag', candidacy_id: candidacy_id, tag_id: tag_id)
  )

@remove_fields = (link) ->
  $(link).prev("input[type=hidden]").val("1")
  $(link).closest(".fields").hide()

@add_fields = (link, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id))

$ ->
  # $(".tabs").tabs()

  # Setup Backbone !
  Backoffice.RouterInstance = new Backoffice.Router()

  $('.backbone-link').live 'click', (e) ->
    e.preventDefault()
    backoffice.navigate $(@).attr('data-path'), true

  Backbone.history.start()
