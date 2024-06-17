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
    const camera = new THREE.PerspectiveCamera(45,window.innerWidth/window.innerHeight,0.1,1000);
    const renderer = new THREE.WebGLRenderer({antialias:true});
    renderer.setSize(window.innerWidth,window.innerHeight);
    camera.position.set(4,2,0);
    let render = ()=>{
        requestAnimationFrame(render);
        renderer.render(scene,camera)
    }
    onMounted(()=>{
        tDom.value.appendChild(renderer.domElement);
        render();
        const coltrols = new OrbitControls(camera,renderer.domElement);
        // 禁止平移
        coltrols.enablePan = false;
        // 设置最小距离
        coltrols.minDistance = 3;
        coltrols.maxDistance = 5.5;
        // 设置垂直最小角度
        coltrols.minPolarAngle = -Math.PI / 10;
        coltrols.maxPolarAngle = Math.PI / 2.5
        // 设置水平最小角度
        coltrols.minAzimuthAngle = -Math.PI/10
        // 设置水平最大角度/屏幕往左滑的最大值
        coltrols.maxAzimuthAngle = -Math.PI
        console.log(coltrols);
        const gltfLoader = new GLTFLoader();
        const light = new THREE.DirectionalLight(0xffffff,5);
        light.position.set(-5,10,0)
        const rgbLoader = new RGBELoader();
        rgbLoader.load('./textures/Alex_Hart-Nature_Lab_Bones_2k.hdr',texture=>{
            texture.mapping = THREE.EquirectangularReflectionMapping;
            // scene.environment = texture;
            // scene.background = texture;
        })
        scene.add(light);
        gltfLoader.load('./model/dimon.gltf',(gltf)=>{
            let dimon = gltf.scene.getObjectByName('blast1_diamond_0');
            console.log(dimon);
            dimon.material.flatShading = true;
            // scene.add(gltf.scene);
        })

        gltfLoader.load('./model/room.glb',(gltf)=>{
            let objs = gltf.scene;
            // objs.scale.set(2,2,2)
            scene.add(gltf.scene);
        })
    })
    
</script>

<style>
</style>