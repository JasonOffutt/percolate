class CentralAZ.UserPortal.Views.Edit extends Backbone.View
	tagname: 'div'
	classname: 'edit-details'
	template: 'edit-user-info'
	events:
		'click .user-save': 'saveClicked'
		'click .cancel': 'cancelClicked'

	initialize: (options) ->
		@ev = options.ev
		@model = options.model
		@initChildViews()
		@selectedCampus = CentralAZ.UserPortal.campuses.get @model.get 'CampusID'
		_.bindAll @
		@ev.on 'campus:change', @campusChanged
		@ev.on 'view:rendered', @renderFinished

	render: -> 
		CentralAZ.UserPortal.Helpers.TemplateManager.get @template, (tmp) =>
			html = Mustache.to_html tmp, @model.toJSON()
			@$el.html html
			@onRenderComplete()
		@

	initChildViews: ->
		@childViews = []
		CentralAZ.UserPortal.campuses.forEach (campus) =>
			view = new CentralAZ.UserPortal.Views.CampusSelect ev: @ev, model: campus
			@childViews.push view

	onRenderComplete: ->
		$ul = @$el.find('#campus-picker')
		lastID = CentralAZ.UserPortal.campuses.last().get 'campusID'
		_.each @childViews, (view) =>
			$ul.append view.render().$el
			id = view.model.get 'campusID'
			if id is lastID then @bindUi()

	# Any post-rendering mojo happens in here (e.g. - wiring up jQueryUI widgets, etc)
	bindUi: ->
		$ul = @$el.find('#campus-picker')
		@$el.find('#birthdate').datepicker
			showOn: 'button'
			buttonImage: ''
			buttonImageOnly: true
			changeMonth: true
			changeYear: true
		@$el.find('#gender').buttonset()
		# Super ugly hack to force jQueryUI into submission and avoid race conditions in async UI
		timer = setInterval ->
			if not $ul.find('label.campus').hasClass 'ui-widget' then $ul.buttonset()
			else clearInterval timer
		, 10

	campusChanged: (campus) -> @selectedCampus = campus

	saveClicked: ->
		birthdate = new Date Date.parse @$el.find('#birthdate').val()
		@model.set
			FirstName: @$el.find('#first-name').val()
			LastName: @$el.find('#last-name').val()
			Birthdate: birthdate.getTime()
			Gender: @$el.find('[name="gender"]:checked').val()
			AddressLine1: @$el.find('#address-1').val()
			AddressLine2: @$el.find('#address-2').val()
			City: @$el.find('#city').val()
			State: @$el.find('#state').val()
			ZipCode: @$el.find('#zip-code').val()
			HomePhone: @$el.find('#home-phone').val()
			MobilePhone: @$el.find('#mobile-phone').val()
			Campus: @selectedCampus
			CampusID: @selectedCampus.get 'campusID'
		@ev.trigger 'user:save', @model
		@ev.trigger 'campus:update', @model.get 'Campus'
		false

	cancelClicked: -> 
		@ev.trigger 'user:view'
		false

	onClose: -> 
		@ev.off 'campus:change'
		@ev.off 'view:rendered'
		_.each @childViews, (view) -> view.close()
