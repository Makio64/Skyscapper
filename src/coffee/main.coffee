City = require('City')

class Main

	constructor:()->

		# ---------------------------------------------------------------------- INIT STAGE 2D / 3D

		@lastTime = Date.now()
		w = window.innerWidth
		h = window.innerHeight
		@camera = new THREE.PerspectiveCamera( 70, w / h, 0.1, 10000 )
		@camera.position = new THREE.Vector3(0,300,700)
		@cameraIndex = 1
		@scene = new THREE.Scene()
		@scene.add(@camera)
		@renderer = new THREE.WebGLRenderer({antialias: true})
		@renderer.setSize(w, h)
		@changeTick = 0
		@changeTickDuration = 700
		@currentCity = 0

		document.querySelector("#container").appendChild(@renderer.domElement)

		@city = new City(@scene)
		@citys = [@city.nyc,@city.paris,@city.hk,@city.tokyo,@city.seoul,@city.dubay]

		document.querySelector("#paris").addEventListener("click",()=>
			@city.updateHeight(@city.paris)
			@select(@city.paris)
		)
		document.querySelector("#hk").addEventListener("click",()=>
			@city.updateHeight(@city.hk)
			@select(@city.hk)
		)
		document.querySelector("#nyc").addEventListener("click",()=>
			@city.updateHeight(@city.nyc)
			@select(@city.ny)
		)
		document.querySelector("#tokyo").addEventListener("click",()=>
			@city.updateHeight(@city.tokyo)
			@select(@city.tokyo)
		)
		document.querySelector("#dubay").addEventListener("click",()=>
			@city.updateHeight(@city.dubay)
			@select(@city.dubay)
		)
		document.querySelector("#seoul").addEventListener("click",()=>
			@city.updateHeight(@city.seoul)
			@select(@city.seoul)
		)
		document.querySelector("#camera").addEventListener("click",()=>
			@nextCamera()
		)
		document.querySelector("#switchAuto").addEventListener("click",()=>
			@switchAuto = !@switchAuto
			if @switchAuto
				document.querySelector("#switchAuto a").innerHTML = "on"
				@changeTick = @changeTickDuration
			else
				document.querySelector("#switchAuto a").innerHTML = "off"
		)
		window.addEventListener("resize", @resize,false)
		@nextCamera()
		@nextCity()
		requestAnimationFrame( @animate )
		return

	nextCamera:()=>
		@cameraIndex++
		@cameraIndex%=3
		switch @cameraIndex
			when 0
				TweenMax.to(@camera.position,1.6,{x:0,y:300,z:700,ease:Strong.easeOut})
				TweenMax.to(@city.global3D.rotation,1.3,{y:@city.global3D.rotation.y+Math.PI,ease:Sine.easeOut})
			when 1
				TweenMax.to(@camera.position,1.6,{x:0,y:600,z:0.5,ease:Strong.easeOut})
				TweenMax.to(@city.global3D.rotation,1.3,{y:@city.global3D.rotation.y+Math.PI,ease:Sine.easeOut})
			when 2
				TweenMax.to(@camera.position,1.6,{x:0,y:200,z:400,ease:Strong.easeOut})
				TweenMax.to(@city.global3D.rotation,1.3,{y:@city.global3D.rotation.y+Math.PI,ease:Sine.easeOut})
		return


	animate:()=>
		@city.update()
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
		requestAnimationFrame( @animate )
		return

	resize:()=>
		w = window.innerWidth
		h = window.innerHeight
		@camera.aspect = w / h;
		@camera.updateProjectionMatrix();
		@renderer.setSize( w, h );
		return

	nextCity:()->
		@currentCity++
		@currentCity %= @citys.length
		@city.updateHeight(@citys[@currentCity])
		@select(@citys[@currentCity])
		return

	select:(city)->
		divs = document.querySelectorAll("div.city a")
		for div in divs
			div.className = ""
		document.querySelector("div#"+city[0].idBtn+" a").className = "selected"
		return

	document.addEventListener('DOMContentLoaded', ()=>
		console.log('hello :)')
		new Main()
	)

module.exports = Main
