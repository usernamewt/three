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
    let tDom = ref(null)
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(45,window.innerWidth/window.innerHeight,0.1,1000);
    const renderer = new THREE.WebGLRenderer({antialias:true});
    let rgbeLoader = new RGBELoader();
    renderer.shadowMap.enabled = true;
    renderer.setSize(window.innerWidth,window.innerHeight);
    camera.position.set(7,0,7);
    let render = ()=>{
        requestAnimationFrame(render);
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
        const pointText = pointTextureLoader.load('./textures/2.png')
        // 创建BufferGeometry
const sphereGeometry = new THREE.BufferGeometry();
 
 // 定义球体的半径
 const radius = 5;
 const widthSegments = 32;
 const heightSegments = 16;
  
 // 计算顶点位置
 const vertices = new Float32Array(widthSegments * heightSegments * 6 * 3);
 let index = 0;
  
 for (let i = 0; i < heightSegments; i++) {
   const lat0 = (i / heightSegments) * Math.PI - Math.PI / 2;
   const lat1 = ((i + 1) / heightSegments) * Math.PI - Math.PI / 2;
  
   for (let j = 0; j < widthSegments; j++) {
     const lng = j / widthSegments * Math.PI * 2;
  
     const sinLat0 = Math.sin(lat0);
     const cosLat0 = Math.cos(lat0);
     const sinLat1 = Math.sin(lat1);
     const cosLat1 = Math.cos(lat1);
  
     const sinLng = Math.sin(lng);
     const cosLng = Math.cos(lng);
  
     const x0 = cosLat0 * cosLng;
     const y0 = cosLat0 * sinLng;
     const z0 = sinLat0;
  
     const x1 = cosLat1 * cosLng;
     const y1 = cosLat1 * sinLng;
     const z1 = sinLat1;
  
     vertices[index++] = radius * x0;
     vertices[index++] = radius * y0;
     vertices[index++] = radius * z0;
  
     vertices[index++] = radius * x1;
     vertices[index++] = radius * y1;
     vertices[index++] = radius * z1;
   }
 }
  
 // 设置顶点和法线
 sphereGeometry.setAttribute('position', new THREE.BufferAttribute(vertices, 3));
 sphereGeometry.computeVertexNormals();
        const pointMaterial = new THREE.PointsMaterial({
            size:0.2,
            color:0xfff000,
            sizeAttenuation:true,
            map:pointText,
            alphaMap:pointText,
            transparent:true,depthWrite:false
        })
        // pointMaterial.map = pointTexture;

        scene.add(new THREE.Points(sphereGeometry,pointMaterial));
        

    })
    
</script>

<style>
</style>