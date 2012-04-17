class CentralAZ.UserPortal.Presenters.UserPortalPresenter
	container: '#user-portal'
	constructor: (options) ->
		@ev = options.ev
		@model = options.model
		@bind()

	bind: ->
		_.bindAll @
		@ev.on 'user:view', @index
		@ev.on 'user:edit', @editUser
		@ev.on 'user:save', @saveUser

		@ev.on 'emailAddress:new', @newEmailAddress
		@ev.on 'emailAddress:create', @createEmailAddress
		@ev.on 'emailAddress:edit', @editEmailAddress
		@ev.on 'emailAddress:delete', @deleteEmailAddress

		@ev.on 'familyMember:new', @newFamilyMember
		@ev.on 'familyMember:create', @createFamilymember
		@ev.on 'familyMember:edit', @editFamilyMember
		@ev.on 'familyMember:save emailAddress:save', @saveModel

		@ev.on 'state:saving', @showSpinner
		@ev.on 'state:saved', @hideSpinner

		@ev.on 'campus:update', @setSelectedCampus

	showView: (view) ->
		if @currentView then @currentView.close()
		if @modal then @modal.close()
		@currentView = view
		@currentView.render().$el.appendTo $('#user-portal-container')

	showModalView: (view) ->
		if @modal then @modal.close()
		@modal = view
		@modal.render().$el.appendTo $('#user-portal-container')

	closeModal: -> if @modal then @modal.close()

	index: ->
		index = new CentralAZ.UserPortal.Views.Index ev: @ev, model: @model
		@showView index
		
	editUser: ->
		edit = new CentralAZ.UserPortal.Views.Edit ev: @ev, model: @model
		@showView edit

	saveUser: (model) ->
		model.save()
		model.displayDate()
		@ev.trigger 'user:view'

	newFamilyMember: ->
		fm = new CentralAZ.UserPortal.Models.FamilyMember()
		familymemberView = new CentralAZ.UserPortal.Views.EditFamilyMember ev: @ev, model: fm
		@showModalView familymemberView

	createFamilymember: (model) ->
		promise = model.save()
		promise.done (res) =>
			family = @model.get 'Family'
			family.add model
			@closeModal()
			model.set PersonID: res.d

	editFamilyMember: (id) ->
		family = @model.get 'Family'
		fm = family.get id
		editFm = new CentralAZ.UserPortal.Views.EditFamilyMember ev: @ev, model: fm
		@showModalView editFm

	newEmailAddress: ->
		email = new CentralAZ.UserPortal.Models.EmailAddress()
		emailView = new CentralAZ.UserPortal.Views.EditEmailAddress ev: @ev, model: email
		@showModalView emailView

	createEmailAddress: (model) ->
		promise = model.save()
		promise.done (res) =>
			emails = @model.get 'EmailAddresses'
			emails.add model
			@closeModal()
			model.set EmailID: res.d

	editEmailAddress: (id) ->
		email = @model.get('EmailAddresses').get id
		emailView = new CentralAZ.UserPortal.Views.EditEmailAddress ev: @ev, model: email
		@showModalView emailView

	deleteEmailAddress: (email) ->
		emailList = @model.get 'EmailAddresses'
		emailList.remove email
		email.destroy()
		@ev.trigger 'user:view'

	saveModel: (model) ->
		# TODO: show loading and listen for "save complete" event before hiding modal
		model.save()
		@closeModal()

	# Keep record of the 'selected' state of each campus
	setSelectedCampus: (campus) ->
		newID = campus.get 'campusID'
		campus.set selected: true
		CentralAZ.UserPortal.campuses.forEach (c) ->
			id = c.get 'campusID'
			c.set selected: false if id isnt newID

