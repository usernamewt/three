<template>
    <div ref="tDOm" style="width: 100vw;height: 100vh;"></div>
</template>
<script setup>
/* eslint-disable */
    import * as THREE from 'three'
    import {GLTFLoader} from 'three/examples/jsm/loaders/GLTFLoader'
    import {DRACOLoader} from 'three/examples/jsm/loaders/DRACOLoader'
    import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
    import {RGBELoader} from 'three/examples/jsm/loaders/RGBELoader'
    import {ref,onMounted, reactive} from 'vue'
    import {Reflector} from 'three/examples/jsm/objects/Reflector'
    import gsap from 'gsap'
    let tDOm = ref(null);
    let renderer = reactive(null);
    let sence = reactive(null);
    let camera = reactive(null);

    

    onMounted(()=>{
        sence = new THREE.Scene();
        camera = new THREE.PerspectiveCamera(
            75,tDOm.value.clientWidth/tDOm.value.clientHeight,0.1,1000
        )
        camera.position.set(0,1.5,6);
        const axis = new THREE.AxesHelper(5);
        renderer = new THREE.WebGLRenderer({antialias:true});
        renderer.setSize(tDOm.value.clientWidth,tDOm.value.clientHeight);
        tDOm.value.appendChild(renderer.domElement);
        // sence.add(axis);
        const controller = new OrbitControls(camera,renderer.domElement);
        const rgbeL = new RGBELoader();
        rgbeL.load('./model/sky12.hdr',(tex)=>{
            tex.mapping = THREE.EquirectangularReflectionMapping;
            sence.background = tex;
            sence.environment = tex;
        })
        // 加载器
        const dracL = new DRACOLoader();
        dracL.setDecoderPath('./draco/gltf/');
        dracL.setDecoderConfig({type:'js'});
        const gltfLoader = new GLTFLoader();
        gltfLoader.setDRACOLoader(dracL);
        gltfLoader.load('./model/robot.glb',(el)=>{
            const sences = el.scene;
            // sences.scale(0.1,0.1,0.1);
            // sences.position.set(0,0,0);
            sence.add(sences);
            console.log(sences);
            heartAnimate(sences)
        })

        const light1 = new THREE.DirectionalLight(0xffffff,1);
        light1.position.set(0,10,10)
        const light2 = new THREE.DirectionalLight(0xffffff,1);
        light2.position.set(0,10,-10)
        const light3 = new THREE.DirectionalLight(0xffffff,1);
        light3.position.set(10,10,10)
        sence.add(light1,light2,light3)

        // 添加视频光环
        const video = document.createElement('video');
        video.src = './model/zp2.mp4';
        video.loop = true;
        video.muted = true;
        video.play();
        let videoTexure = new THREE.VideoTexture(video);
        let plant = new THREE.Mesh(
            new THREE.PlaneGeometry(8,4.5),
            new THREE.MeshBasicMaterial({
                map:videoTexure,
                side:THREE.DoubleSide,
                transparent:true,
                alphaMap:videoTexure
            })
        )
        plant.position.set(0,0.2,0);
        plant.rotation.x = -Math.PI/2;
        sence.add(plant);

        // 添加反射镜面
        const reflectPlant = new THREE.PlaneGeometry(100,100);
        const reflectMaterial = new Reflector(reflectPlant,{
            textureWidth:window.innerWidth,
            textureHeight:window.innerHeight,
            color:0x333333
        })
        reflectMaterial.rotation.x = -Math.PI/2
        sence.add(reflectMaterial);
        function render(){
            requestAnimationFrame(render);
            renderer.render(sence,camera);
        }
        render();

        function heartAnimate(obj){
            let param = {
                time:0
            }
            gsap.to(param,{
                time:2,
                duration:10,
                repeat:-1,
                onUpdate:()=>{
                    obj.rotation.y = Math.PI*param.time;
                }
            })
        }
    })

    function getObjBNFromSence(name) {
        return sence.getObjectByName(name);
    }
</script>
<style></style>