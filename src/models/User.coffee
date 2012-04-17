class CentralAZ.UserPortal.Models.User extends CentralAZ.UserPortal.Models.Person
	idAttribute: 'PersonID'
	initialize: (options) ->
		if not options then return
		if options.Birthdate then @displayDate()
		if options.EmailAddresses
			@set EmailAddresses: new CentralAZ.UserPortal.Models.EmailAddressCollection options.EmailAddresses
		if options.Family
			@set Family: new CentralAZ.UserPortal.Models.FamilyMemberCollection options.Family
		if options.Gender then @initGender()

	initGender: ->
		gender = @get 'Gender'
		@set
			isMale: gender is 'Male'
			isFemale: gender is 'Female'

	validate:
		FirstName:
			required: true
			minlength: 2
			maxlength: 100
		LastName:
			required: true
			minlength: 2
			maxlength: 100
		HomePhone:
			required: true
			pattern: /^(?:\([2-9]\d{2}\)\ ?|[2-9]\d{2}(?:\-?|\ ?))[2-9]\d{2}[- ]?\d{4}$/
		AddressLine1:
			required: true
		City:
			required: true
		State:
			required: true
		ZipCode:
			required: true
		# with a little 'b' so we don't overwrite the user's actual 'Birthdate' field in validation
		#birthdate:
		#	required: true
		#	pattern: /^[0-9]{1,2}[\/,\-,\.][0-9]{1,2}[\/,\-,\.][0-9]{4}$/