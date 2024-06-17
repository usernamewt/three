<template>
    <div ref="tDom" style="width: 100vw;height: 100vh;"></div>
</template>

<script setup>
/* eslint-disable */
    import * as THREE from 'three';
    import  {ref, onMounted } from 'vue';
    import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
    import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader';
import { GUI } from 'three/examples/jsm/libs/lil-gui.module.min';
    let tDom = ref(null)
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(45,window.innerWidth/window.innerHeight,0.1,1000);
    camera.position.set(20,20,20);
    camera.lookAt(0,0,0);
    const renderer = new THREE.WebGLRenderer({antialias:true});

    const render = ()=>{
        requestAnimationFrame(render);
        renderer.render(scene,camera);
    }
    renderer.setSize(window.innerWidth,window.innerHeight);
    

    onMounted(()=>{
        tDom.value.appendChild(renderer.domElement);
        render();
        new OrbitControls(camera,renderer.domElement);
        // const light = new THREE.AmbientLight(0xffffff,10);
        // light.position.set(5,2,2)
        // scene.add(light);

        const cube = new THREE.BoxGeometry(10,10,10);

        const textLoader = new THREE.TextureLoader();
        const clearlMap = textLoader.load('./textures/diamond/diamond_normal.png')
        const carbonMap = textLoader.load('./textures/carbon/Carbon_Normal.png')
        const normalMap = textLoader.load('./textures/carbon/Scratched_gold_01_1K_Normal.png')

        // 清漆物理材质,清漆贴图
        const cubeMaterial = new THREE.MeshPhysicalMaterial({
            transparent:true,
            color:0xffff00,
            roughness:0.5,
            clearcoat:1,
            clearcoatRoughness:0,
            // 法向贴图
            normalMap:carbonMap,
            // 清漆贴图
            clearcoatNormalMap:clearlMap
        })
        const cubeMesh = new THREE.Mesh(cube,cubeMaterial);
        // 添加正方体清漆物体
        // scene.add(cubeMesh);

        const spher = new THREE.SphereGeometry(10,60,60);
        const spherMaterial = new THREE.MeshPhysicalMaterial({
            color:0x222288,
            sheen:1,
            sheenColor:0xffffff,
            roughness:1,
            sheenRoughness:1
        })

        const ball = new THREE.Mesh(spher,spherMaterial);
        scene.add(ball);

        let gui = new GUI();
        gui.add(spherMaterial,'sheen',0,1).name('布料光泽');
        gui.add(spherMaterial,'roughness',0,1).name('粗糙度');
        gui.add(spherMaterial,'sheenRoughness',0,1).name('布料粗糙度');
        
        // hdr图中包含了光照数据,不需要再次在场景中添加重复的光源
        const rgbLoader = new RGBELoader()
        rgbLoader.load('./textures/Alex_Hart-Nature_Lab_Bones_2k.hdr',text=>{
            text.mapping = THREE.EquirectangularReflectionMapping;
            scene.background = text;
            scene.environment = text;
        })
        
    })
</script>

<style>
</style>