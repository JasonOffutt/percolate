# Base class for User and FamilyMember to inherit that contains common functionality
class CentralAZ.UserPortal.Models.Person extends Backbone.Model
	displayDate: ->
		birthdate = new Date @get 'Birthdate'
		@set DisplayDate: "#{birthdate.getMonth() + 1}/#{birthdate.getDate()}/#{birthdate.getFullYear()}"
		today = new Date()
		age = today.getFullYear() - birthdate.getFullYear()
		month =  today.getMonth() - birthdate.getMonth()
		if month < 0 or (month is 0 and today.getDate() < birthdate.getDate()) then age--
		@set Age: ageå