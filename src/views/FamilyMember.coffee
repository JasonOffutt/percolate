class CentralAZ.UserPortal.Views.FamilyMember extends Backbone.View
	tagName: 'li'
	template: 'family-member'
	events:
		'click .fm-edit': 'editClicked'
	initialize: (options) ->
		@ev = options.ev
		@model = options.model
		@parent = options.parent
		_.bindAll @
		@model.on 'change', @onChanged
	render: -> @fromTemplate()
	editClicked: ->
		id = @$el.children('div').attr 'data-id'
		@ev.trigger 'familyMember:edit', parseInt id
		false
	onChanged: -> @render()
	onClose: -> @model.off 'change'