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
    import { DRACOLoader } from 'three/examples/jsm/loaders/DRACOLoader';
    import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader';
    import { ObjectLoader } from 'three';
    import { OBJLoader } from 'three/examples/jsm/loaders/OBJLoader';
    import gsap from 'gsap';
import { DirectionalLightHelper } from 'three';
    let tDom = ref(null)
    const scene = new THREE.Scene();
    const newScene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(45,window.innerWidth/window.innerHeight,0.1,1000);
    const renderer = new THREE.WebGLRenderer({antialias:true});
    renderer.shadowMap.enabled = true;
    
    renderer.setSize(window.innerWidth,window.innerHeight);
    
    camera.position.set(0,20,40);
    let render = ()=>{
        requestAnimationFrame(render);
        
        renderer.render(scene,camera);
    }
    onMounted(()=>{
        tDom.value.appendChild(renderer.domElement);
        render();
        const coltrols = new OrbitControls(camera,renderer.domElement);
        const gltfLoader = new GLTFLoader();
        const light = new THREE.DirectionalLight(0xffffff,4);
        light.position.set(0,10,0)
        light.castShadow = true;
        scene.add(light);
        const helper = new DirectionalLightHelper(light);
        scene.add(helper)
        const plantGeo = new THREE.PlaneGeometry(40,40);
        const plantMaterial = new THREE.MeshPhysicalMaterial({
            color:0x999999
        })
        const plant = new THREE.Mesh(plantGeo,plantMaterial);
        // plant.castShadow = true;
        plant.receiveShadow = true;
        plant.rotation.x = -Math.PI/2
        scene.add(plant);
        const ballGeo = new THREE.SphereGeometry(2,60,60);
        const ballMaterial = new THREE.MeshPhysicalMaterial({
            // transparent:true,
            // thickness:10,
            // transmission:0.9,
            color:0xffffff
        })
        ballGeo.translate(0,6,0)
        const ball = new THREE.Mesh(ballGeo,ballMaterial);
        // ball.receiveShadow = true;
        ball.castShadow = true;
        scene.add(ball);
    })
    
</script>

<style>
</style>