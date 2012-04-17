class CentralAZ.UserPortal.Models.EmailAddress extends Backbone.Model
	idAttribute: 'EmailID'
	validate:
		Address:
			type: 'email'