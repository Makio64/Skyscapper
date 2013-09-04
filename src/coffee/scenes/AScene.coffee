class AScene

	stage 				: null
	callback			: null

	constructor:(@stage)->
		return

	transitionIn:(@callback)->
		@callback()
		return

	transitionOut:(@callback)->
		@callback()
		return

	onResize:(width,height)->
		return

	onEnter:()->
		return
	
	onExit:()->
		return

	update:(dt)->
		return

	dispose:()->
		@stage 		= null
		@callback 	= null
		return