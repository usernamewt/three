<template>
    <div ref="tDom" style="width: 100vw;height: 100vh;">

    </div>
</template>
<script setup>
 /* eslint-disable */
    import * as THREE from 'three';
    import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
    import { DRACOLoader } from 'three/examples/jsm/loaders/DRACOLoader';
    import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
    import { onMounted, ref } from 'vue';
    import { Water } from 'three/examples/jsm/objects/Water2';
    import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader';
    let tDom = ref(null);
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(
        75,window.innerWidth/window.innerHeight,0.1,2000
    )
    camera.position.set(-50,50,130);
    camera.aspect = window.innerWidth/window.innerHeight;
    camera.updateProjectionMatrix();
    scene.add(camera);
    const renderer = new THREE.WebGLRenderer({
        antialias:true,
        logarithmicDepthBuffer:true
    });
    renderer.setSize(window.innerWidth,window.innerHeight);
    function render(){
        requestAnimationFrame(render);
        renderer.render(scene,camera);
    }
    render();
    console.log(tDom.value);
    onMounted(()=>{
        tDom.value.appendChild(renderer.domElement);
        const controller = new OrbitControls(camera,renderer.domElement);
        const plant = new THREE.Mesh(
            new THREE.PlaneGeometry(100,100),
            new THREE.MeshBasicMaterial({
                color:0xffffff
            })
        )
        // scene.add(plant)

        // 创建球，放上天空
        const ball = new THREE.SphereGeometry(1000,60,60);
        const ballmetry = new THREE.MeshBasicMaterial({
            map:new THREE.TextureLoader().load("./textures/sky.jpg")
        })
        ball.scale(1,1,-1)
        const sky = new THREE.Mesh(ball,ballmetry)
        scene.add(sky)

        const video = document.createElement("video");
        video.src = './textures/sky.mp4';
        video.loop = true;
        video.muted = true;
        window.addEventListener('click',()=>{
            if(video.paused) {
                video.play();
                ballmetry.map = new THREE.VideoTexture(video);
                ballmetry.map.needsUpdate = true;
            }else{
                video.pause();
            }
            
        })
        const water = new Water(
            new THREE.CircleGeometry(300,64),{
                textureWidth:1024,
                textureHeight:1024,
                color:0xffffff,
                flowDirection:new THREE.Vector2(1,1),
                scale:1
            }
        )
        water.rotation.x = -Math.PI/2;
        water.position.y = 4;
        scene.add(water);

        const gltfL = new GLTFLoader();
        const draLoder = new DRACOLoader();
        draLoder.setDecoderPath('./draco/gltf/');
        gltfL.setDRACOLoader(draLoder);
        gltfL.load('./model/island2.glb',glb=>{
            scene.add(glb.scene);
        })

    })
    
    const hdrLoader = new RGBELoader();
    hdrLoader.loadAsync('./imgs/050.hdr').then(text=>{
        text.mapping = THREE.EquirectangularReflectionMapping;
        scene.background = text;
        scene.environment = text;
    })

    const light = new THREE.DirectionalLight(0xffffff,1);
    light.position.set(-100,100,100);
    scene.add(light);

    
</script>
<style></style>