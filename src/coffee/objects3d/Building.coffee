class Building extends THREE.Mesh

	angle			: 0
	radius			: 0
	r 			: 0
	g 			: 0
	b 			: 0

	constructor:(h,@color)->
		opacity = .1
		@color = 0xFFFFFF

		@geometry = new THREE.CubeGeometry(5,1,5)
		@material = new THREE.MeshLambertMaterial({color:@color, opacity:opacity, transparent: true})
		materials = [
			@material,
			new THREE.MeshBasicMaterial( { color: 0x222222, opacity:0.1, wireframe: false, transparent: false } )
		]
		THREE.SceneUtils.createMultiMaterialObject.call( @, @geometry, @material )

		THREE.Mesh.call @, @geometry, @material
		@position.y = 1/2
		return

	updatePosition:(radius, angle)->
		if radius then @radius = radius
		if angle then @angle = angle
		
		@position.x = Math.cos(@angle)*@radius
		@position.z = Math.sin(@angle)*@radius

		return

	update:(height,@color)->
		# if height<250
			# height += Math.floor(Math.random()*29)
		height /= 4
		# console.log @material.color
		TweenLite.to(@, .5, {r:( @color >> 16 & 255 ) / 255,g:( @color >> 8 & 255 ) / 255,b: ( @color & 255 ) / 255})
		TweenLite.to(@geometry.vertices[0], 1, {y : height, onUpdate:@needUpdateRequest})
		TweenLite.to(@geometry.vertices[1], 1, {y : height})
		TweenLite.to(@geometry.vertices[4], 1, {y : height})
		TweenLite.to(@geometry.vertices[5], 1, {y : height})
		return

	needUpdateRequest:()=>
		# @material = new THREE.MeshLambertMaterial({color:@color, opacity:@material.opacity, transparent: true})
		# console.log @material
		@material.color.setRGB(@r,@g,@b)
		@material.opacity = Math.min(Math.max(@geometry.vertices[0].y / 140,.1),.8)
		@geometry.verticesNeedUpdate = true;
		@geometry.elementsNeedUpdate = true;
		@geometry.morphTargetsNeedUpdate = true;
		@geometry.uvsNeedUpdate = true;
		@geometry.normalsNeedUpdate = true;
		@geometry.colorsNeedUpdate = true;
		@geometry.tangentsNeedUpdate = true;
		return