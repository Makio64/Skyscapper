###
# Usage :
# SndFX.load(urls,onComplete)
# SndFX.addFilter(id, filter)
# SndFX.getFilter(id)
#
# snd.onComplete = onSndEnd
# snd = new Snd(id)
# snd.play()
# snd.stop()
# snd.connectTo(filter)
# 
# source => panner => gain => filters => masterGain
###

class Snd

	id		 		: null
	source			: null
	gain			: null
	destination		: null
	panner			: null
	domAudio		: null
	_volume			: 0

	onComplete		: null

	constructor:(id,options={})->

		@id = id = SndFX.instance.replaceSuffix(id)

		#Setup the default options
		options.autoplay	= options.autoplay 		|| false

		if SndFX.instance.webAudio
			if options.volume == undefined then options.volume = 1.0
		else
			if options.volume == undefined then options.volume= SndFX.instance.volume
		
		console.log options.volume

		options.destination = options.destination 	|| SndFX.instance.masterGain

		#Setup for web audio API
		if SndFX.instance.webAudio
		
			#Create the bufferSource
			@source 			= SndFX.instance.context.createBufferSource()
			@source.buffer 		= SndFX.instance.buffers[id]


			#Create the gain node 			
			@gainNode 				= SndFX.instance.createGain()
			@gainNode.connect( options.destination )

			#Create the panner
			@panner 			= SndFX.instance.createPanner()
			@panner.setPosition(0, 0, 0);
			@panner.connect( @gainNode )
			
			#Connect to the panner
			@source.connect( @panner )
			if options.autoplay
				@play(0)
		
		#Setup for dom audio
		else 
			@domAudio = new Audio()
			@domAudio.autoplay = options.autoplay
			@domAudio.src = id
			@domAudio.load()

		@volume(options.volume)


		return @


	play:(_when=0,_loop=false)->
		
		if SndFX.instance.webAudio
			@source.loop = _loop
			if (!@source.start)
				@source.noteOn(_when)
			else
				@source.start(_when)
		
		else
			@domAudio.loop = _loop
			@domAudio.play()

		return @



	stop:(delay=0)->
		if SndFX.instance.webAudio
			if (!@source.stop)
				@source.noteOff(delay)
			else
				@source.stop(delay)
		else
			@domAudio.pause()
		return @


	setPosition:(x,y=0,z=0)->
		@panner.setPosition(x,y,z)
		return

	volume:(vol = null)->
		if (vol >= 0 && vol <= 1)
			
			vol = parseFloat(vol)
		
			if (SndFX.instance.webAudio)
				# x = parseInt(vol) / parseInt(@gainNode.max)
				# vol = Math.cos(x * 0.5*Math.PI)
				@gainNode.gain.value = vol
			else
				@domAudio.volume = vol
			
			_volume = vol

		else 
			return _volume


	connectTo:(destination,autoConnectDestination=false)->
		if !SndFX.instance.webAudio
			return
		
		@gainNode.disconnect(0)
		@gainNode.connect(destination)
		if autoConnectDestination
			destination.connect(SndFX.instance.masterGain)
		
		return @


	update:(dt)->
		# if webAudio
		return

	dispose:()->
		if SndFX.instance.webAudio
			@panner.disconnect(0)
			@gainNode.disconnect(0)
			@source.disconnect(0)

			@source.stop(0)
			
			@panner 			= null
			@gainNode 				= null
			@source.buffer 		= null
			@source 			= null
		else
			@domAudio.pause()
			@domAudio = null

		SndFX.remove(@)
		
		id = null

		return

