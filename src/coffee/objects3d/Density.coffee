class Density

	constructor:(@container, @count = 100, @space=6000, @radius = 200, @height = 20)->

		geometry = new THREE.Geometry()
		randomRadius = 20

		M_PI2 = Math.PI*2
		angle = 0
		console.log 1/@space

		@radius *= (1/@space*500)
		@radius += 200

		for i in [0...@count] by 1
			vertex = new THREE.Vector3()
			angle += @space
			vertex.x = Math.cos(angle)*(@radius+randomRadius*i/100)
			vertex.z = Math.sin(angle)*(@radius+randomRadius*i/100)
			vertex.y = @height * (@count-i)/300 - 20
			geometry.vertices[i] = vertex
		
		@material = new THREE.ParticleBasicMaterial( { opacity:0, size: 1, sizeAttenuation: false, transparent: true } )
		@material.color.setHSL( .5, 0, 1 )

		TweenLite.to(@material,.6,{opacity:1})

		@particles = new THREE.ParticleSystem( geometry, @material )
		@particles.sortParticles = true
		@container.add( @particles )
		return


	remove:()->
		TweenLite.to(@material,.6,{opacity:0,onComplete:@dispose})
		return


	dispose:()=>		
		@container.remove(@particles)
		return
