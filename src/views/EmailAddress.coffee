class CentralAZ.UserPortal.Views.EmailAddress extends Backbone.View
	tagName: 'li'
	template: 'email-address'
	events: 
		'click .ea-edit': 'editClicked'
		'click .ea-delete': 'deleteClicked'
	initialize: (options) ->
		@ev = options.ev
		@model = options.model
		@parent = options.parent
		_.bindAll @
		@model.on 'change', @onChanged
	render: -> @fromTemplate()
	editClicked: ->
		id = @$el.children('a').attr 'data-id'
		@ev.trigger 'emailAddress:edit', parseInt id
		false
	deleteClicked: ->
		if confirm "Are you sure you want to remove '#{@model.get 'Address'}' from your profile?"
			@ev.trigger 'emailAddress:delete', @model
		false
	onChanged: -> @render()
	onClose: -> @model.off 'change'