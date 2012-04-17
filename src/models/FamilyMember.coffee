class CentralAZ.UserPortal.Models.FamilyMember extends CentralAZ.UserPortal.Models.Person
	idAttribute: 'PersonID'
	initialize: (options) -> 
		if options.Birthdate then @displayDate()
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
		#birthdate:
		#	required: true
		#	pattern: /^[0-9]{1,2}[\/,\-,\.][0-9]{1,2}[\/,\-,\.][0-9]{4}$/