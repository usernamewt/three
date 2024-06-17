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
        
        const gltfLoader = new GLTFLoader();
        const light = new THREE.DirectionalLight(0xffffff,5);
        light.position.set(-5,10,0)
        const rgbLoader = new RGBELoader();
        rgbLoader.load('./textures/Alex_Hart-Nature_Lab_Bones_2k.hdr',texture=>{
            texture.mapping = THREE.EquirectangularReflectionMapping;
            scene.background = texture;
            scene.environment = texture;
        })
        scene.add(light);
        gltfLoader.load('./model/cup.glb',(gltf)=>{
            const ice = gltf.scene.getObjectByName('copo_low_04_vidro_0');
            ice.scale.set(0.8,0.8,0.8)
            const water = gltf.scene.getObjectByName('copo_low_02_agua_0');
            const glass = gltf.scene.getObjectByName('copo_low_01_vidro_0');
            ice.renderOrder = 1;
            water.renderOrder = 2;
            glass.renderOrder = 3;

            // glass.visible = false;
            // water.visible = false;

            let iceMaterial = ice.material;
            ice.material = new THREE.MeshPhysicalMaterial({
                normalMap:iceMaterial.normalMap,
                metalnessMap:iceMaterial.metalnessMap,
                roughness:0,
                transparent:true,
                transmission:0.95,
                thickness:10,
                ior:2
            })

            let waterMaterial = water.material;
            water.material = new THREE.MeshPhysicalMaterial({
                normalMap:waterMaterial.normalMap,
                metalnessMap:waterMaterial.metalnessMap,
                map:waterMaterial.map,
                roughnessMap:waterMaterial.roughnessMap,
                roughness:0,
                transparent:true,
                transmission:0.95,
                thickness:10,
                ior:2,
            })
            water.material.blending = THREE.CustomBlending;
            water.material.blendEquation = THREE.DstColorFactor;
            water.material.blendSrc = THREE.SrcAlphaFactor;
            water.material.blendDst = THREE.SrcColorFactor;

            let glassMaterial = glass.material;
            glass.material = new THREE.MeshPhysicalMaterial({
                normalMap:glassMaterial.normalMap,
                metalnessMap:glassMaterial.metalnessMap,
                map:glassMaterial.map,
                roughnessMap:glassMaterial.roughnessMap,
                roughness:0,
                transparent:true,
                transmission:0.95,
                thickness:10,
                ior:2
            })
            glass.material.blending = THREE.CustomBlending;
            glass.material.blendEquation = THREE.DstColorFactor;
            glass.material.blendSrc = THREE.SrcAlphaFactor;
            glass.material.blendDst = THREE.SrcColorFactor;
            scene.add(gltf.scene);
        })
    })
    
</script>

<style>
</style>