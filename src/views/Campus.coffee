class CentralAZ.UserPortal.Views.Campus extends Backbone.View
	tagName: 'strong'
	template: 'campus'
	initialize: (options) ->
		@ev = options.ev
		@model = options.model
		_.bindAll @
	render: -> @fromTemplate()