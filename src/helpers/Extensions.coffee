Backbone.View.prototype.close = ->
	@remove()
	@unbind()
	if typeof @onClose is 'function' then @onClose()

Backbone.View.prototype.fromTemplate = ->
	CentralAZ.UserPortal.Helpers.TemplateManager.get @template, (tmp) =>
		html = Mustache.to_html tmp, @model.toJSON()
		@$el.html html
	@

Backbone.sync = (method, model) ->
	isPerson = model instanceof CentralAZ.UserPortal.Models.User
	modelData = model.toJSON()
	methodType = 'POST'
	switch method
		when 'delete'
			path = 'DeleteEmail'
			data = id: model.id
		when 'create'
			if isPerson
				path = 'CreateFamilyMember'
				data = person: modelData
			else
				path = 'CreateEmail'
				data = email: modelData
		when 'update'
			if isPerson and model.get 'IsCurrentUser'
				path = 'UpdateUser'
				data = user: modelData
			else if isPerson and not model.get 'IsCurrentUser'
				path = 'UpdateFamilyMember'
				data = person: modelData
			else 
				path = 'UpdateEmail'
				data = email: modelData
		when 'read'
			path = 'UserInfo'
			data = {}
			methodType = 'GET'
		else return console.log method
	
	promise = $.trafficCop "webservices/custom/cccev/core/UserPortalService.asmx/#{path}",
		type: methodType
		dataType: 'json'
		contentType: 'application/json; charset=utf-8'
		data: JSON.stringify data
	promise.error (xhr, text, err) ->
		# TODO: Elengantly handle errors that come back display error feedback and...
		#  - if method is 'update', reset back to its previous state and display edit screen (see previousAttributes method)
		#  - if method is 'delete', re-add back to the collection
		#  - if method is 'create', remove from collection and display creation screen
		#  - if method is 'read', ???
		# ** Will need to fire events based on model, method and error so they can be dealt with effectively
		console.log 'Uh oh!'
		console.log xhr
		console.log text
		console.log err
	promise

(($) ->
	inProgress = {}
	$.trafficCop = (url, options) ->
		reqOptions = url
		if arguments.length is 2 then reqOptions = $.extend true, options, url: url
		key = JSON.stringify reqOptions
		if inProgress[key] then inProgress[key][i](reqOptions[i]) for i of success: 1, error: 1, complete: 1
		else inProgress[key] = $.ajax(reqOptions).always -> delete inProgress[key]
		inProgress[key]
)(jQuery)