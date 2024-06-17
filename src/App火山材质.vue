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
    import { Clock } from 'three';
    // 顶点着色器
    import basicVertexShader from "../public/shaders/water/vertex.glsl"
    // 片元着色器
    import basicFragmentShader from "../public/shaders/water/frag.glsl";
    import gsap from 'gsap';
    import { GUI } from 'three/examples/jsm/libs/lil-gui.module.min';
    import { min } from 'three/examples/jsm/nodes/Nodes';
    let tDom = ref(null)
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(45,window.innerWidth/window.innerHeight,0.1,1000);
    const renderer = new THREE.WebGLRenderer({antialias:true});
    let rgbeLoader = new RGBELoader();
    let textureLoader = new THREE.TextureLoader();
    renderer.shadowMap.enabled = true;
    renderer.setSize(window.innerWidth,window.innerHeight);
    renderer.toneMapping = THREE.ACESFilmicToneMapping;
    renderer.toneMappingExposure = 0.2;
    // renderer
    // 创建基础材质
    let param = {
        miji:10.0,
        maxTop:0.5,
        noisePower:1.0,
        lColor:'#ffff00',
        hColor:'#ff0000',
        uOpacity:0.9
    }
    let floorMaterial = new THREE.RawShaderMaterial({
        vertexShader:basicVertexShader,
        fragmentShader:basicFragmentShader,
        uniforms:{
            miji:{
                value:param.miji
            },
            maxTop:{
                value:param.maxTop
            },
            noisePower:{
                value:param.noisePower
            },uTime:{
                value:0.0
            },lColor:{
                value:new THREE.Color('#ffff00')
            },hColor:{
                value:new THREE.Color('#ff0000')
            },uOpacity:{
                value:param.uOpacity
            },radiamSpeed:{
                value:(Math.random()+2)*6
            }
        },
        side:THREE.DoubleSide,
        
    })
    let clock = new THREE.Clock();
    camera.position.set(0,4,-2);
    const gltfLoader = new GLTFLoader();
    const draco = new DRACOLoader();
    draco.setDecoderPath('./draco/');
    gltfLoader.setDRACOLoader(draco);
    
    let render = ()=>{
        let detime = clock.getElapsedTime();
        floorMaterial.uniforms.uTime.value = detime;
        floorMaterial.uniforms.radiamSpeed.value = (Math.random());
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
        const axis = new THREE.AxesHelper(10);
        // scene.add(axis)
        rgbeLoader.load("./textures/2k.hdr", (envMap) => {
            // 设置球形贴图
            // envMap.mapping = THREE.EquirectangularReflectionMapping;
            envMap.mapping = THREE.EquirectangularRefractionMapping;
            // 设置环境贴图
            // scene.background = envMap;
            // scene.background = envMap;
            // 设置环境贴图
            // scene.environment = envMap;
        });
        const floor = new THREE.PlaneGeometry(3,3,1024,1024);
        const pic = textureLoader.load('./imgs/ca.jpeg');
        

        const flo = new THREE.Mesh(floor,floorMaterial);
        flo.rotation.x = -Math.PI/2;
        scene.add(flo);
        render();
    })

    // 控制水波纹
    let gui = new GUI();
    gui.add(param,"miji").min(1.0).max(20.0).step(1.0).onChange(val=>{
        floorMaterial.uniforms.miji.value = val;
    })
    gui.add(param,"maxTop").min(0.1).max(2.0).step(0.1).onChange(val=>{
        floorMaterial.uniforms.maxTop.value = val;
    })
    gui.add(param,"noisePower").min(0.5).max(20.0).step(0.5).onChange(val=>{
        floorMaterial.uniforms.noisePower.value = val;
    })
    gui.add(param,"uOpacity").min(0.1).max(1.0).step(0.05).onChange(val=>{
        floorMaterial.uniforms.uOpacity.value = val;
    })
    gui.addColor(param,"lColor").onFinishChange(val=>{
        floorMaterial.uniforms.lColor.value = new THREE.Color(val);
    })
    gui.addColor(param,"hColor").onFinishChange(val=>{
        floorMaterial.uniforms.hColor.value = new THREE.Color(val);
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