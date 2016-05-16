class Density

	constructor:(@container, @count = 100, @space=6000, @radius = 200, @height = 20)->

		geometry = new THREE.Geometry()
		randomRadius = 20

		M_PI2 = Math.PI*2
		angle = 0
		@radius *= (1/@space*500)
		@radius += 200

		for i in [0...@count] by 1
			vertex = new THREE.Vector3()
			angle += @space
			vertex.x = Math.cos(angle)*(@radius+randomRadius*i/100)
			vertex.z = Math.sin(angle)*(@radius+randomRadius*i/100)
			vertex.y = @height * (@count-i)/300 - 20
			geometry.vertices[i] = vertex

		@material = new THREE.PointsMaterial( { opacity:0, size: window.devicePixelRatio, sizeAttenuation: false, transparent: true } )
		@material.color.setHSL( .5, 0, 1 )

		TweenMax.to(@material,.6,{opacity:1})

		@particles = new THREE.Points( geometry, @material )
		@particles.sortParticles = true
		@container.add( @particles )
		return

	remove:()->
		TweenMax.to(@material,.6,{opacity:0,onComplete:@dispose})
		return

	dispose:()=>
		@container.remove(@particles)
		return

module.exports = Density
