class SndFX

	cache 			: {}

	#general
	context			: null
	masterGain		: null
	_volume			: 1

	# list of sounds and buffers
	buffers 		: null
	snds			: null

	codecs			: null
	
	onload 			: null
	urls			: null
	loadCount		: 0

	webAudio 		: false

	constructor:()->
		console.log "SndFX"
		if SndFX.instance then throw new Error("You can't create an instance of SndFX")
		
		if window.AudioContext 
			@webAudio = true
			@context = new AudioContext()
		else if window.webkitAudioContext
			@webAudio = true
			@context = new webkitAudioContext()
		else
			@webAudio = false

		if @webAudio
			@masterGain = @createGain()
			@masterGain.gain.value = 1
			@masterGain.connect(@context.destination)

		audioTest = new Audio();
		@codecs =
			mp3: !!audioTest.canPlayType('audio/mpeg;').replace(/^no$/,''),
			opus: !!audioTest.canPlayType('audio/ogg; codecs="opus"').replace(/^no$/,''),
			ogg: !!audioTest.canPlayType('audio/ogg; codecs="vorbis"').replace(/^no$/,''),
			wav: !!audioTest.canPlayType('audio/wav; codecs="1"').replace(/^no$/,''),
			m4a: !!(audioTest.canPlayType('audio/x-m4a;') || audioTest.canPlayType('audio/aac;')).replace(/^no$/,''),
			webm: !!audioTest.canPlayType('audio/webm; codecs="vorbis"').replace(/^no$/,'')
		
		@cache = {}
		@buffers = {}
		@snds = []
		return


	volume: (vol) ->
		vol = parseFloat(vol)
		if (vol && vol >= 0 && vol <= 1)
			@_volume = vol

			if (@webAudio)
				@masterGain.gain.value = vol
			else
				for snd in @sounds
					snd.volume(vol)

		if @webAudio then return @masterGain.gain.value 
		else return @_volume


	load:(@urls, callback=null)->

		for i in [0...urls.length] by 1
			urls[i] = @replaceSuffix(urls[i])

		@onload = callback
		@loadCount = 0
		loader = @

		if @webAudio
			for i in [0...urls.length] by 1
				@loadBuffer(urls[i], i)
		else
			for i in [0...urls.length] by 1
				@loadAudio(urls[i])
		return

	replaceSuffix:(url)->
		if @codecs.mp3
			return url
		
		suffix = ""
		if @codecs.ogg
			suffix = "ogg"
		else if @codecs.wav
			suffix = "wav"
		else
			return url

		url = url.replace("mp3",suffix)
		return url
		


	loadBuffer:(url, index)->
		console.log url
		request = new XMLHttpRequest();
		request.open("GET", url, true);
		request.responseType = "arraybuffer";
		loader = @;

		request.onload = ()->
			loader.context.decodeAudioData(
				request.response
				(buffer)=>
					if (!buffer)
						alert('error decoding file data: ' + url)
						return
					
					loader.buffers[loader.replaceSuffix(url)] = buffer

					if (++loader.loadCount == loader.urls.length and loader.onload != null)
						loader.onload()

				(error)=>
					console.error('decodeAudioData error', error)
			)

		request.onerror = ()->
			alert('BufferLoader: XHR error')

		request.send()
		return


	loadAudio:(url)->
		loader = @;

		sound = new Audio()
		@cache[url] = sound
		sound.addEventListener("canplaythrough",()->
			if (++loader.loadCount == loader.urls.length and loader.onload != null)
				loader.onload()
		,false)
		sound.src = url
		sound.load()
		return


	getByID:(id)->
		for snd in @sounds
			if snd.id == id
				return snd

		return null


	createGain:()->
		if @context.createGain
			return @context.createGain()
		else
			return @context.createGainNode()


	createPanner:()->
		if @context.createPanner
			return @context.createPanner()
		else
			return @context.createPannerNode()


	remove:(snd)->
		idx = @sounds.indexOf(snd)
		if idx == -1
			return
		@sounds.splice(idx,1)
		

	update:(dt)->
		for snd in @sounds
			snd.update(dt)
		
	@instance		= new SndFX()