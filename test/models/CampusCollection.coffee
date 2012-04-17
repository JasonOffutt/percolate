class CentralAZ.UserPortal.Models.CampusCollection extends Backbone.Collection
	model: CentralAZ.UserPortal.Models.Campus

	comparator: (campus) -> campus.get 'campusID'

	url: -> 'webservices/custom/cccev/web2/campusservice.asmx/GetCampusList'

	fetch: (options) ->
		promise = $.trafficCop @url(),
			contentType: 'application/json'
			dataType: 'json'
		promise.done (data) =>
			#console.log data
			campuses = data.d
			@add campus for campus in campuses
		promise