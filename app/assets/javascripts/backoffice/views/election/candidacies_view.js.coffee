class Backoffice.Views.Election.CandidaciesView extends Backbone.View
  template: JST['backoffice/templates/election/candidacies']

  events:
    'click .toggle-publish': 'togglePublish'
    'submit .create-candidate': 'createCandidate'

  initialize: ->
    @flash = {}
    @election = @model
    @candidacies = @election.candidacies
    self = @
    @candidacies.each (c) ->
      c.bind 'change', self.render, self
    @render()

  render: ->
    $(@el).html @template @
    $('button.hover', @el).hide()
    @flash = {}

  togglePublish: (event) ->
    candidacy_id = $(event.target).parent().parent().data().candidacyId
    candidacy = @candidacies.find (c) -> c.id == candidacy_id
    candidacy.save {}, data: $.param(candidacy: {published: (not candidacy.get 'published')})

  createCandidate: (event) ->
    event.preventDefault()
    form = $(event.target)
    console.log 'Create Candidate'
    firstName = $('input.first-name', form).val()
    lastName = $('input.last-name', form).val()
    namespace = firstName + '-' + lastName
    candidate = new CandidateModel(first_name: firstName, last_name: lastName, namespace: namespace)
    candidate.save {}, success: (candidate) ->
      # toto link candidacy
      console.log candidate
