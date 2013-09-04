class City


	buildings		: null
	plateform		: null
	max				: 402
	scene			: null
	paris			: null
	hk				: null
	ny				: null
	tokyo			: null
	dubay			: null
	clouds			: null



	constructor:(@scene)->

		@global3D = new THREE.Object3D()
		@global3D.add()

		ambient = new THREE.AmbientLight( 0x303030 );
		@scene.add( ambient );

		directionalLight = new THREE.DirectionalLight( 0xffffff );
		directionalLight.position.set( 30, 90, 100 ).normalize();
		@scene.add( directionalLight );

		# pointLight = new THREE.PointLight( 0xffaa00 );
		pointLight = new THREE.PointLight( 0xFF00AA );
		pointLight.position.y = 100
		@scene.add( pointLight );

		# clouds = []
		# for i in [0...10] by 1
		# 	cloud = new Cloud()
		# 	clouds.push(cloud)
		# 	scene.add(cloud)
		
		@hk 		= [{heigth: 450,count:1,color:0x700000},	{heigth: 400,count:1,color:0x434B6E}, {heigth: 350,count:4,color:0x57596B},	{heigth: 300,count:6,color:0x645666},	{heigth: 250,count:15,color:0x2B2C36},	{heigth: 200,count:62,color:0xFF00FF},{heigth: 150,count:294,color:0xFFFF00}]
		@ny	 		= [{heigth: 500,count:1,color:0x7381C7}, {heigth: 450,count:1,color:0x797E99},	{heigth: 400,count:1,color:0x67739E}, {heigth: 350,count:2,color:0x67739E},	{heigth: 300,count:6,color:0x3F446B},	{heigth: 250,count:13,color:0x67739E},	{heigth: 200,count:59,color:0x2B3269},{heigth: 150,count:227,color:0x4A58C2}]
		@paris		= [{heigth: 300,count:1,color:0x67739E}, {heigth: 250,count:1,color:0x67739E},	{heigth: 200,count:3,color:0xCFC5A9}, {heigth: 150,count:19,color:0x94968A} ]
		@tokyo 		= [{heigth: 250,count:1,color:0x67739E}, {heigth: 200,count:27,color:0xFF1010}, {heigth: 150,count:125,color:0xFF4D4D}]	
		@dubay		= [{heigth: 800,count:1,color:0x67739E}, {heigth: 700,count:1,color:0x67739E},{heigth: 600,count:1,color:0x67739E},{heigth: 500,count:1,color:0x67739E},{heigth: 450,count:1,color:0x700000},	{heigth: 400,count:2,color:0x434B6E}, {heigth: 350,count:8,color:0x57596B},	{heigth: 300,count:18,color:0x645666},	{heigth: 250,count:40,color:0x2B2C36},	{heigth: 200,count:73,color:0xFF00FF},{heigth: 150,count:153,color:0xFFFF00}]
		@buildings 	= []
		
		buildIndex  = 0
		count 		= 0

		radius 		= 0
		angle		= 0
		step 		= M_2PI/1
		stepsPower  = 1
		k = 0


		for i in [0..@max] by 1

			if @hk.length > buildIndex 
				heigth = @hk[buildIndex].heigth
				color =  @hk[buildIndex].color
			else 
				color = 0xFFFFFF
				heigth = 1


			angle = step*k
			building = new Building(heigth,color)
			building.updatePosition(radius,angle)
			@buildings.push(building)
			@scene.add(building)

			k++
			if k >= stepsPower
				stepsPower += 5
				step = M_2PI/stepsPower
				k = 0
				radius += 15
			
			count++
			if @hk.length > buildIndex and count >= @hk[buildIndex].count
				count = 0
				buildIndex++

		radius+=5
			
		socleGeo 	= new THREE.CylinderGeometry( radius, radius, 4, 40 )
		socleMat 	= new THREE.MeshBasicMaterial({color:0,wireframeLinewidth:1,vertexColors: THREE.VertexColors})
		plateform 	= new THREE.Object3D()
		materials = [
			new THREE.MeshBasicMaterial( { color: 0, opacity:.5, transparent: true } ),
			new THREE.MeshBasicMaterial( { color: 0x222222, opacity:0.1, wireframe: true, transparent: true } )
		]

		socle = THREE.SceneUtils.createMultiMaterialObject( socleGeo, materials );
		socle.position.y = -2
		@scene.add( socle )
		socleGeo 	= new THREE.CylinderGeometry( radius/1.5, 0, 50, 30,5 )
		socleMat 	= new THREE.MeshBasicMaterial({color:0,wireframeLinewidth:1,vertexColors: THREE.VertexColors})
		plateform 	= new THREE.Object3D()
		materials = [
			new THREE.MeshBasicMaterial( { color: 0, opacity:.5, transparent: true } ),
			new THREE.MeshBasicMaterial( { color: 0x222222, opacity:0.1, wireframe: true, transparent: true } )
		]
		socle = THREE.SceneUtils.createMultiMaterialObject( socleGeo, materials );
		socle.position.y = -30
		@scene.add( socle )

		return


	update:()->

		return

	updateHeight:(city)->
		buildIndex  = 0
		count 		= 0

		for i in [0..@max] by 1

			if city.length > buildIndex 
				heigth = city[buildIndex].heigth
				color =  city[buildIndex].color
			else 
				color = 0xFFFFFF
				heigth = 1

			building = @buildings[i]
			building.update(heigth,color)

			count++
			if city.length > buildIndex and count >= city[buildIndex].count
				count = 0
				buildIndex++

		return

	