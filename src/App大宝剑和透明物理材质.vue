
<template>
    <div ref="tDom" class="tDom"></div>
</template>

<script setup>
/* eslint-disable */
import { onMounted, ref } from 'vue';
import * as THREE from 'three'
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader';

import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
import { GUI } from 'three/examples/jsm/libs/lil-gui.module.min';
let tDom = ref(null)
const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(
    75,window.innerWidth/window.innerHeight,0.1,1000
)
camera.position.set(20,20,20);

const renderer = new THREE.WebGLRenderer({antialias:true});
function render(){
    requestAnimationFrame(render)
    renderer.render(scene,camera);
}
renderer.setSize(window.innerWidth,window.innerHeight);

onMounted(()=>{
    const textLoader = new THREE.TextureLoader();
    const hdrLoader = new RGBELoader();
    tDom.value.appendChild(renderer.domElement)
    new OrbitControls(camera,renderer.domElement);
    render();
    const axis = new THREE.AxesHelper(10);
    // scene.add(axis);

    const light = new THREE.AmbientLight(0xffffff,1)
    light.position.set(0,0,10)
    scene.add(light)

    // 创建环境贴图
    hdrLoader.loadAsync('./imgs/050.hdr').then(text=>{
        text.mapping = THREE.EquirectangularReflectionMapping;
        scene.background = text;
        scene.environment = text;
    })

    const basicMap = textLoader.load('./model/sword/Sting_Base_Color.png')
    // 金属贴图
    const materialMap = textLoader.load('./model/sword/Sting_Metallic.png')
    // 法线贴图
    const normalMap = textLoader.load('./model/sword/Sting_Normal_DirectX.png')
    // 凹凸贴图
    const bumpMap = textLoader.load('./model/sword/Sting_Height.png')
    // 粗糙度贴图
    const roughnessMap = textLoader.load('./model/sword/Sting_Roughness.png')
    // 环境光贴图
    const aoMap = textLoader.load('./model/sword/Sting_Mixed_AO.png')

    const gui = new GUI();
    const loader = new GLTFLoader();
    loader.load('./model/sword/sword.glb',gltf=>{
        // const swordScene = gltf.scene;
        scene.add(gltf.scene);
        let one = gltf.scene.getObjectByName('Pommeau_Plane001');
        one.material.map = basicMap;
        one.material.metalnessMap  = materialMap;
        one.material.normalMap = normalMap;
        one.material.roughnessMap = roughnessMap;
        one.material.aoMap = aoMap;
        // one.material.bumpMap = bumpMap

        // bumpMap凹凸贴图和法线贴图冲突,只能生效一个,默认法线贴图
        

        gui.add(param,'normalMap').onChange(el=>{
            if(el){
                one.material.normalMap = normalMap
            } else {
                one.material.normalMap = null;
            }
            one.material.needsUpdate = true;

        })
        one.material.needsUpdate = true;
    })

    const param = {
        normalMap:true
    }

    const box = new THREE.BoxGeometry(10,10,10);
    const boxMaterial = new THREE.MeshPhysicalMaterial({
        transparent:true,
        transmission:0.95,
        roughness:0.05,
        thickness:4,
        
    })
    const boxMesh = new THREE.Mesh(box,boxMaterial);
    boxMesh.position.set(0,2.5,0);
    scene.add(boxMesh);
    
    
})
</script>

<style>
.tDom{
    width: 100vw;
    height: 100vh;
}
</style>