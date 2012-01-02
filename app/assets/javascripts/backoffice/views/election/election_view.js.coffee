class Backoffice.Views.ElectionView extends Backbone.View
  el: '.content'
  template: JST['backoffice/templates/election/layout']
  content_el: '.election-content'

  initialize: ->
    @election = new ElectionModel(id: @options.election_id)
    @election.bind 'change', @render, @
    @election.fetch()

  render: () ->
    menu_entry = @options.menu_entry
    $(@el).html @template @
    new Backoffice.Views.Election.ElectionMenuView(model: @election, menu_entry: menu_entry)
    switch menu_entry
      when 'contributors'
        new Backoffice.Views.Election.ContributorsView(el: @content_el, model: @election)
      when 'candidacies'
        new Backoffice.Views.Election.CandidaciesView(el: @content_el, model: @election)
      else
        console.error 'wrong route'
    $('.change-election').click ->
      Backoffice.RouterInstance.navigate 'elections', true

  go_to: (menu_entry) ->
    @options.menu_entry = menu_entry
    @render()
