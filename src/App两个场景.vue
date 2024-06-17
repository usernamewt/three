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
    let tDom = ref(null)
    const scene = new THREE.Scene();
    const newScene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(45,window.innerWidth/window.innerHeight,0.1,1000);
    const renderer = new THREE.WebGLRenderer({antialias:true});
    
    renderer.setSize(window.innerWidth,window.innerHeight);
    
    camera.position.set(50,20,0);
    let render = ()=>{
        requestAnimationFrame(render);
        renderer.localClippingEnabled = true;
        renderer.setScissorTest(true);
        renderer.setScissor(0, 0, window.innerWidth / 2, window.innerHeight);
        renderer.render(scene,camera);
        renderer.setScissor(window.innerWidth / 2, 0, window.innerWidth / 2, window.innerHeight);
        renderer.render(newScene,camera);
        renderer.setScissorTest(false);
    }
    onMounted(()=>{
        tDom.value.appendChild(renderer.domElement);
        console.log(window.innerWidth);
        render();
        console.log(scene);
        console.log(newScene);
        const coltrols = new OrbitControls(camera,renderer.domElement);
        const gltfLoader = new GLTFLoader();
        const light = new THREE.DirectionalLight(0xffff00,50);
        // light.position.set(0,0,0)
        newScene.add(light);
        const rgbLoader = new RGBELoader();
        rgbLoader.load('./textures/Alex_Hart-Nature_Lab_Bones_2k.hdr',texture=>{
            texture.mapping = THREE.EquirectangularReflectionMapping;
            scene.background = texture;
            scene.environment = texture;
            // newScene.environment= texture;
            // newScene.background= texture;
        })
        // scene.add(light);
        const geometry = new THREE.TorusKnotGeometry(10,3,100,60);
        const geometry1 = new THREE.TorusKnotGeometry(10,3,100,60);
        const material = new THREE.MeshPhysicalMaterial({
            side:THREE.DoubleSide
        })

        const materialnew = new THREE.MeshPhysicalMaterial({
            side:THREE.DoubleSide,
            // wireframe:true
        })

        scene.add(new THREE.Mesh(geometry,material));
        newScene.add(new THREE.Mesh(geometry1,materialnew));
        const plant = new THREE.Plane(new THREE.Vector3(0,0,1),0);
        // material.clippingPlanes = [plant];
    })
    
</script>

<style>
</style>