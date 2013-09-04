class GameScene extends AScene


	constructor:(stage)->
		super(stage)
		return


	onEnter:()->
		# Test image loading
		imageData = CanvasUtils.dataFromImage(DataManager.instance.get("./data/spritesheet.png"))
		console.log "Web Audio API Enable: "+SndFX.instance.webAudio
		snd = new Snd("./sfx/loop.mp3",{volume:1})
		snd.play(0,true)
		
		filter = SndFX.instance.context.createBiquadFilter()
		filter.type = 0
		filter.frequency.value = 440
		snd.connectTo(filter, true)

		console.log filter.frequency

		gui = new dat.GUI();
		gui.add(filter,"type", [ 'highpass', 'lowpass', 'bandpass', 'lowshelf', 'highshelf', 'peaking', 'notch', 'allpass' ]).name("filter.type")
		gui.add(filter.frequency,"value").min(0).max(1000).name("filter.frequency")
		gui.add(filter.Q,"value").min(0.0001).max(10).name("filter.quality")
		gui.add(snd.gainNode.gain,"value").min(0).max(1).name("volume")

		@stage.mousemove = (e)->
			x = (e.global.x/window.innerWidth-.5)*10
			y = (e.global.y/window.innerHeight-.5)*10
			snd.panner.setPosition(x,0,0)

		Game.stage = @stage

		return