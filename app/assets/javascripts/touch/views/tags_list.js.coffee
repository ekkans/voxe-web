class window.TagsListView extends Backbone.View
  
  initialize: ->
    # model == Election
    @model.bind "change", @render, @
    
  events:
    "click a.nav": "candidaciesClick"
    "click ul.tags li": "themeClick"
    
  candidaciesClick: ->
    app.router.navigate "#{@model.namespace()}", true
      
  themeClick: (e)->
    li = $(e.target).closest('li')
    tagId = li.attr("tag-id")
    @model.tags.setSelected tagId
    app.router.navigate "#{@model.namespace()}/#{@model.candidacies.toParam()}/#{@model.tags.selected().namespace()}", true
    
  render: ->
    $(@el).html Mustache.to_html($('#tags-list-template').html(), tags: @model.tags.toJSON())
    new iScroll $('.table-view-container', @el).get(0)
    setTimeout hideURLbar, 0
    @