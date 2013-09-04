class Main

	scene 			: null
	renderer 		: null
	camera 			: null
	city 			: null

	dt 				: 0
	lastTime 		: 0


	constructor:()->		
		@lastTime = Date.now()

		w = window.innerWidth
		h = window.innerHeight

		@camera = new THREE.PerspectiveCamera( 70, w / h )
		@camera.position = new THREE.Vector3(190,190,190)
		@controls = new THREE.TrackballControls( @camera );

		@controls.rotateSpeed = 1.0;
		@controls.zoomSpeed = 1.2;
		@controls.panSpeed = 0.8;

		@controls.noZoom = false;
		@controls.noPan = false;

		@controls.staticMoving = true;
		@controls.dynamicDampingFactor = 0.3;

		@controls.keys = [ 65, 83, 68 ];


		@scene = new THREE.Scene()
		@scene.add(@camera)
		
		@renderer = new THREE.WebGLRenderer()
		@renderer.setSize(w, h)
		# @renderer.setClearColor(0x111FF1,0)

		$("#container").append(@renderer.domElement)
		
		@city = new City(@scene)

		$("#paris").click(()=>
			@city.updateHeight(@city.paris)
		)
		$("#hk").click(()=>
			@city.updateHeight(@city.hk)
		)
		$("#ny").click(()=>
			@city.updateHeight(@city.ny)
		)
		$("#tokyo").click(()=>
			@city.updateHeight(@city.tokyo)
		)
		$("#dubay").click(()=>
			@city.updateHeight(@city.dubay)
		)

		requestAnimFrame( @animate )
		return
		

	animate:()=>
		# @city.update()
		@controls.update()
		t = Date.now()
		dt = t - @lastTime
		@lastTime = t
		@camera.lookAt(@scene.position)
		@renderer.render(@scene, @camera)

		requestAnimFrame( @animate )

		return


main = null
$(document).ready ->
	main = new Main()
	return