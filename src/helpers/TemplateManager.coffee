CentralAZ.UserPortal.Helpers.TemplateManager = 
	templates: {}
	get: (id, callback) ->
		if @templates[id] then return callback.call @, @templates[id]
		url = "usercontrols/custom/cccev/core/templates/#{id}.html"
		promise = $.trafficCop url
		promise.done (template) =>
			@templates[id] = template
			callback.call @, template
