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
    let tDom = ref(null)
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(45,window.innerWidth/window.innerHeight,0.1,1000);
    const renderer = new THREE.WebGLRenderer({antialias:true});
    renderer.shadowMap.enabled = true;
    renderer.setSize(window.innerWidth,window.innerHeight);
    renderer.toneMapping = THREE.ACESFilmicToneMapping;
    renderer.toneMappingExposure = 0.2;
    camera.position.set(0,4,-2);
    
    let render = ()=>{
        requestAnimationFrame(render);
        renderer.render(scene,camera);
    }
    
    onMounted(()=>{
        tDom.value.appendChild(renderer.domElement);
        const coltrols = new OrbitControls(camera,renderer.domElement);
        // const gltfLoader = new GLTFLoader();
        const environmentLight = new THREE.AmbientLight(0xffffff,1);
        scene.add(environmentLight)
        const light = new THREE.DirectionalLight(0xffffff,3);
        light.position.set(0,7,0)
        light.castShadow = true;
        scene.add(light);
        render();
    }) 

    window.addEventListener("resize", () => {
        //   console.log("resize");
        // 更新摄像头
        camera.aspect = window.innerWidth / window.innerHeight;
        //   更新摄像机的投影矩阵
        camera.updateProjectionMatrix();

        //   更新渲染器
        renderer.setSize(window.innerWidth, window.innerHeight);
        //   设置渲染器的像素比例
        renderer.setPixelRatio(window.devicePixelRatio);
    });
    
</script>

<style>
</style>