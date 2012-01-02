class Backoffice.Views.Election.ElectionMenuView extends Backbone.View
  el: '.menu'
  template: JST['backoffice/templates/election/election_menu']

  initialize: () ->
    @election = @model # readability++
    @render @options.menu_entry

  render: (menu_entry) ->
    $(@el).html @template @
    $(".#{menu_entry}").addClass 'current'
