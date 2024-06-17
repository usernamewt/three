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
    import { BufferAttribute } from 'three';
    // 顶点着色器
    import basicVertexShader from "../public/shaders/raw/vertex.glsl"
    // 片元着色器
    import basicFragmentShader from "../public/shaders/raw/frag.glsl";
import gsap from 'gsap';
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
    let floorMaterial;
    let clock = new THREE.Clock();
    camera.position.set(30,-2,30);
    const gltfLoader = new GLTFLoader();
    const draco = new DRACOLoader();
    draco.setDecoderPath('./draco/');
    gltfLoader.setDRACOLoader(draco);
    
    let render = ()=>{
        let detime = clock.getElapsedTime();
        requestAnimationFrame(render);
        floorMaterial.uniforms.uTime.value = detime;
        renderer.render(scene,camera);
    }
    onMounted(()=>{
        tDom.value.appendChild(renderer.domElement);
        
        const coltrols = new OrbitControls(camera,renderer.domElement);
        // const gltfLoader = new GLTFLoader();
        const environmentLight = new THREE.AmbientLight(0xffffff,1);
        scene.add(environmentLight)
        const light = new THREE.DirectionalLight(0xffffff,3);
        light.position.set(0,10,0)
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
            scene.background = envMap;
            // 设置环境贴图
            scene.environment = envMap;
        });
        const floor = new THREE.PlaneGeometry(1,1,64,64);
        const pic = textureLoader.load('./imgs/ca.jpeg');
        floorMaterial = new THREE.RawShaderMaterial({
            vertexShader:basicVertexShader,
            fragmentShader:basicFragmentShader,
            uniforms:{
                uPic:{
                    value:pic
                },
                uTime:{
                    value:0
                }
            },
            side:THREE.DoubleSide,
            
        })
        gltfLoader.load('./model/flyLight.glb',e=>{
            let light = e.scene.children[0];
            light.material = floorMaterial;
            // scene.add(e.scene)
            for(let i = 0;i<150;i++) {
                let cloned = e.scene.clone(true);
                let x = (Math.random() - 0.5) * 300;
                let z = (Math.random() - 0.5) * 300;
                let y = Math.random() * 60;
                cloned.position.set(x,y,z);
                scene.add(cloned);
                gsap.to(cloned.rotation,{
                    y: 2 * Math.PI,
                    duration: 10 + Math.random() * 30,
                    repeat: -1,
                })
                gsap.to(cloned.position,{
                    x: "+=" + Math.random() * 5,
                    y: "+=" + Math.random() * 20,
                    yoyo: true,
                    duration: 5 + Math.random() * 10,
                    repeat: -1,
                })
            }
        })

        const flo = new THREE.Mesh(floor,floorMaterial);
        flo.rotation.x = -Math.PI/2;
        // scene.add(flo);

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