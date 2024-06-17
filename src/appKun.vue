<template>
    <div ref="tDom" style="width: 100vw;height: 100vh;position: fixed;left: 0;top: 0;">
        <!-- <canvas id="myCanvas" width="200" height="100" style="border:1px solid #000000;">
        </canvas> -->
    </div>
</template>

<script setup>
/* eslint-disable */
    import  {ref, onMounted } from 'vue';
    import * as THREE from 'three';
    import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
    import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
    import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader';
    import { Clock } from 'three';
    import { BufferAttribute } from 'three';
    let tDom = ref(null)
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(45,window.innerWidth/window.innerHeight,0.1,1000);
    const renderer = new THREE.WebGLRenderer({antialias:true});
    let rgbeLoader = new RGBELoader();
    renderer.shadowMap.enabled = true;
    renderer.setSize(window.innerWidth,window.innerHeight);
    camera.position.set(7,0,7);
    let xukuns;
    let clock = new THREE.Clock();
    let render = ()=>{
        let time = clock.getElapsedTime();
        requestAnimationFrame(render);
        if(xukuns){
            xukuns.rotation.x = time*0.1;
            xukuns.rotation.y = time*0.1;
        }
        renderer.render(scene,camera);
    }
    onMounted(()=>{
        tDom.value.appendChild(renderer.domElement);
        render();
        const coltrols = new OrbitControls(camera,renderer.domElement);
        // const gltfLoader = new GLTFLoader();
        const environmentLight = new THREE.AmbientLight(0xffffff,5);
        scene.add(environmentLight)
        const light = new THREE.DirectionalLight(0xffffff,4);
        light.position.set(0,10,0)
        light.castShadow = true;
        scene.add(light);

        rgbeLoader.load("./textures/Alex_Hart-Nature_Lab_Bones_2k.hdr", (envMap) => {
            // 设置球形贴图
            // envMap.mapping = THREE.EquirectangularReflectionMapping;
            envMap.mapping = THREE.EquirectangularRefractionMapping;
            // 设置环境贴图
            // scene.background = envMap;
            scene.background = new THREE.Color(0xcccccc);
            // 设置环境贴图
            scene.environment = envMap;
        });
        const pointTextureLoader = new THREE.TextureLoader();
        const pointText = pointTextureLoader.load('./textures/gege.png')
        const count = 5000;
        const points = new Float32Array(count*3);
        const color = new Float32Array(count*3);
        for(let i = 0;i<count*3;i++){
            points[i] = Math.random()*10 - 5;
            color[i] = Math.random();
        }
        const plantsBuffery = new THREE.BufferGeometry();
        plantsBuffery.setAttribute("position",new BufferAttribute(points,3))
        plantsBuffery.setAttribute("color",new BufferAttribute(color,3))
        console.log(plantsBuffery.getAttribute("color"));
        // sphereGeometry.computeVertexNormals();
        const pointMaterial = new THREE.PointsMaterial({
            size:0.3,
            // color:0xff0000,
            sizeAttenuation:true,
            map:pointText,
            alphaMap:pointText,
            transparent:true,depthWrite:false,
            vertexColors:true
        })
        // pointMaterial.map = pointTexture;
        
        xukuns = new THREE.Points(plantsBuffery,pointMaterial)
        scene.add(xukuns);
        

    })
    
</script>

<style>
</style>