class Main

	scene 			: null
	renderer 		: null
	camera 			: null
	city 			: null

	dt 				: 0
	lastTime 		: 0

	changeTick			: 0
	changeTickDuration 	: 600
	citys 				: null
	currentCity			: 0
	switchAuto			: false

	constructor:()->		
		@lastTime = Date.now()


		w = window.innerWidth
		h = window.innerHeight

		@camera = new THREE.PerspectiveCamera( 70, w / h, 0.1, 10000 )
		@camera.position = new THREE.Vector3(0,300,700)

		@cameraIndex = 0

		# @controls = new THREE.TrackballControls( @camera );
		# @controls.rotateSpeed = 1.0;
		# @controls.zoomSpeed = 1.2;
		# @controls.panSpeed = 0.8;
		# @controls.noZoom = false;
		# @controls.noPan = false;
		# @controls.staticMoving = true;
		# @controls.dynamicDampingFactor = 0.3;
		# @controls.keys = [ 65, 83, 68 ];

		@scene = new THREE.Scene()
		@scene.add(@camera)
		
		@renderer = new THREE.WebGLRenderer({antialias: true})
		@renderer.setSize(w, h)
		# @renderer.setClearColor(0x111FF1,0)

		$("#container").append(@renderer.domElement)
		
		@city = new City(@scene)

		@citys = [@city.ny,@city.paris,@city.hk,@city.tokyo,@city.dubay]

		$("#paris").click(()=>
			@city.updateHeight(@city.paris)
			@select(@city.paris)
		)
		$("#hk").click(()=>
			@city.updateHeight(@city.hk)
			@select(@city.hk)
		)
		$("#ny").click(()=>
			@city.updateHeight(@city.ny)
			@select(@city.ny)
		)
		$("#tokyo").click(()=>
			@city.updateHeight(@city.tokyo)
			@select(@city.tokyo)
		)
		$("#dubay").click(()=>
			@city.updateHeight(@city.dubay)
			@select(@city.dubay)
		)
		$("#camera").click(()=>
			@cameraIndex++
			@cameraIndex%=3
			switch @cameraIndex
				when 0
					TweenLite.to(@camera.position,1.6,{x:0,y:300,z:700,ease:Strong.easeOut})
					TweenLite.to(@city.global3D.rotation,1.3,{y:@city.global3D.rotation.y+Math.PI,ease:Sine.easeOut})
				when 1
					TweenLite.to(@camera.position,1.6,{x:0,y:600,z:0.5,ease:Strong.easeOut})
					TweenLite.to(@city.global3D.rotation,1.3,{y:@city.global3D.rotation.y+Math.PI,ease:Sine.easeOut})
				when 2
					TweenLite.to(@camera.position,1.6,{x:0,y:200,z:400,ease:Strong.easeOut})
					TweenLite.to(@city.global3D.rotation,1.3,{y:@city.global3D.rotation.y+Math.PI,ease:Sine.easeOut})

		)
		$("#switchAuto").click(()=>
			@switchAuto = !@switchAuto
			if @switchAuto
				$("#switchAuto a").html("on")
				@changeTick = @changeTickDuration
			else
				$("#switchAuto a").html("off")
		)

		window.addEventListener("resize",@resize,false)

		requestAnimFrame( @animate )
		return
		

	animate:()=>
		@city.update()
		# @controls.update()
		t = Date.now()
		dt = t - @lastTime

		if @switchAuto
			@changeTick += dt
			if @changeTick >= @changeTickDuration
				@changeTick = 0
				@nextCity()

		@lastTime = t
		@camera.lookAt(@scene.position)
		@renderer.render(@scene, @camera)

		requestAnimFrame( @animate )
		return


	resize:()=>
		@camera.aspect = window.innerWidth / window.innerHeight;
		@camera.updateProjectionMatrix();

		@renderer.setSize( window.innerWidth, window.innerHeight );	
		return


	nextCity:()->
		@currentCity++
		@currentCity %= @citys.length
		@city.updateHeight(@citys[@currentCity])
		@select(@citys[@currentCity])
		return


	select:(city)->
		$("div.city a").removeClass("selected")
		$("div#"+city[0].idBtn+" a").addClass("selected")
		return



main = null
$(document).ready ->
	main = new Main()
	return