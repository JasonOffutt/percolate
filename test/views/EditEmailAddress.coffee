class CentralAZ.UserPortal.Views.EditEmailAddress extends Backbone.View
	tagName: 'div'
	className: 'edit-email-address'
	template: 'edit-email-address'
	events:
		'click .ea-save': 'saveClicked'
		'click .ea-cancel': 'cancelClicked'
		'click .ea-delete': 'deleteClicked'
	initialize: (options) ->
		@model = options.model
		@ev = options.ev
		_.bindAll @
	render: -> @fromTemplate()
	saveClicked: ->
		@model.set
			Address: @$el.find('#email-address').val()
			Active: @$el.find('#active').is ':checked'
		action = if @model.isNew() then 'create' else 'save'
		@ev.trigger "emailAddress:#{action}", @model
		false
	cancelClicked: ->
		@close()
		false
	deleteClicked: -> # TODO: Fire off delete event.