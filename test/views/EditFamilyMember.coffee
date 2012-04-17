class CentralAZ.UserPortal.Views.EditFamilyMember extends Backbone.View
	tagName: 'div'
	className: 'edit-family-member'
	template: 'edit-family-member'
	events:
		'click .fm-save': 'saveClicked'
		'click .fm-cancel': 'cancelClicked'
	initialize: (options) ->
		@ev = options.ev
		@model = options.model
		_.bindAll @

	render: ->
		CentralAZ.UserPortal.Helpers.TemplateManager.get @template, (tmp) =>
			html = Mustache.to_html tmp, @model.toJSON()
			@$el.html html
			@onRenderComplete()
		@

	onRenderComplete: ->
		@$el.find('.fm-gender').buttonset()
		@$el.find('#birthdate').datepicker
			showOn: 'button'
			buttonImage: ''
			buttonImageOnly: true
			changeMonth: true
			changeYear: true

	saveClicked: ->
		@model.set 
			FirstName: @$el.find('#first-name').val()
			LastName: @$el.find('#last-name').val()
			Birthdate: @$el.find('#birthdate').val()
		action = if @model.isNew() then 'create' else 'save'
		@ev.trigger "familyMember:#{action}", @model
		false
		
	cancelClicked: ->
		@close()
		false
	#onClose: -> # TODO: Unbind any events on the model