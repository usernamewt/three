<template>
    <div ref="tDom" style="width: 100vw;height: 100vh;"></div>
</template>
<script setup>
/* eslint-disable */
    import * as THREE from 'three'
    import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
    import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
    import { onMounted, ref } from 'vue';

    let tDom = ref(null);
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(45,window.innerWidth/window.innerHeight,0.1,1000);
    camera.position.set(5,2,2)
    const renderer = new THREE.WebGLRenderer({antialias:true})
    renderer.shadowMap.enabled = true;
    renderer.setSize(window.innerWidth,window.innerHeight);
    const render = ()=>{
        requestAnimationFrame(render);
        renderer.render(scene,camera);
    }
    scene.add(camera);
    render();
    onMounted(()=>{
        tDom.value.appendChild(renderer.domElement);
        let orbCtrl = new OrbitControls(camera,renderer.domElement);
        const textLoader = new THREE.TextureLoader();
        const textBackground = textLoader.load('./textures/hdr.jpg');
        // 设置为球形
        // 反射
        // textBackground.mapping = THREE.EquirectangularReflectionMapping;
        // 折射
        textBackground.mapping = THREE.EquirectangularRefractionMapping;
        const spGro = new THREE.SphereGeometry(100,60,60);
        const spMater = new THREE.MeshBasicMaterial({
            map:textBackground
        })
        // 创建光源
        // 环境光
        let ambientLight = new THREE.AmbientLight(0xffffff, 2);
        scene.add(ambientLight);
        scene.environment = textBackground;
        scene.background = textBackground;
        // plantMaterial.envMap = textBackground;
        const gltfLoader = new GLTFLoader();
        gltfLoader.load('./model/duck/Duck.gltf',glt=>{
            scene.add(glt.scene);
            let duck = glt.scene.getObjectByName('LOD3spShape');
            console.log(duck);
            let duckM = duck.material;
            duck.material = new THREE.MeshPhongMaterial({
                map:duckM.map,
                // color:0xffffff,
                refractionRatio:0.7,
                reflectivity:0.99,
                envMap:textBackground,
            })
        })

        
    })
</script>
<style>

</style>