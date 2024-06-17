<template>
    <div>
        <div class="box" ref="cameraBox" style="width: 100vw;height: 100vh;position: fixed;left: 0;right: 0;"></div>
        <el-color-picker v-model="color1" @change="changeColor" />
    </div>
</template>
<script setup>
/* eslint-disable */
import * as THREE from 'three';
import {OrbitControls} from 'three/examples/jsm/controls/OrbitControls';
// import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import { OBJLoader } from 'three/examples/jsm/loaders/OBJLoader';
import { onMounted,ref } from 'vue';
    const color1 = ref()
    let gridHelper = null;
    let orbitControls = null;
    let cameraBox = ref(null);
    // 创建场景
    const sence = new THREE.Scene();
    // 创建相机
    const camera = new THREE.PerspectiveCamera(75,window.innerWidth/window.innerHeight,0.1,1000);
    // 设置相机位置
    camera.position.set(0,2,6)
    // 创建渲染器
    const renderer = new THREE.WebGLRenderer({
        antialias:true
    })
    // 设置渲染大小
    renderer.setSize(window.innerWidth,window.innerHeight);
    // 创建渲染方法
    function render(){
        requestAnimationFrame(render);
        renderer.render(sence,camera)
        orbitControls && orbitControls.update();
    } 

    function changeColor(el){
        console.log(el);
        let objs = sence.getObjectByName('boot.011');
        objs.material.color = new THREE.Color(el);
    }
    const baseMaterial = new THREE.MeshPhysicalMaterial({
        color:0xff0000,
        metalness:1,
        roughness:0.5,
        clearcoat:1,
        clearcoatRoughness:0
    })

    // 车窗
    const glassMaterial = new THREE.MeshPhysicalMaterial({
        color:0xffffff,
        metalness:0,
        roughness:0,
        transmission:1,
        transparent:true
    })

     // 车窗
     const spMaterial = new THREE.MeshPhysicalMaterial({
        color:0xffff00,
        metalness:0,
        roughness:0.1,
        transmission:0,
        transparent:true
    })

    // 轮胎
    const whellMaterial = new THREE.MeshPhysicalMaterial({
        color:0x000000,
        metalness:1,
        roughness:0.1
    })
    // 前车灯
    const headLight = new THREE.MeshPhysicalMaterial({

    })

    // 获取物体中心点坐标
    function getObjCenter(obj){
        const ball = new THREE.Box3().setFromObject(obj);
        console.log(ball);
        const center = ball.getCenter(new THREE.Vector3());
        return center;
    }
    onMounted(()=>{
        cameraBox.value.appendChild(renderer.domElement);
        // 初始化渲染器
        renderer.setClearColor(0xffffff);
        sence.background = new THREE.Color(0xcccccc)
        sence.environment = new THREE.Color(0xcccccc)
        render();
        // 创建10*10网格
        gridHelper = new THREE.GridHelper(10,10);
        // 设置透明度，需要设置transparent
        gridHelper.material.opacity = 0.2;
        gridHelper.material.transparent = true;
        orbitControls = new OrbitControls(camera,renderer.domElement);
        orbitControls.update();
        const loaders = new OBJLoader();
        loaders.load('/model/bsj.obj',(el)=>{
            const sences = el;
            sences.position.set(0,1,0);
            sences.traverse(el=>{
                if(el.isMesh) {
                    console.log(el.name);
                    // console.log(el.name);
                    if(el.name === 'boot.011'){
                        el.material = baseMaterial;
                    } else if(el.name === 'boot.004'||el.name === 'windshield') {
                        el.material = glassMaterial;
                    } else if(el.name === 'Cylinder.000'||el.name === 'Cylinder.001') {
                        el.material = whellMaterial;
                    } else if(el.name === 'boot.005'){
                        el.material = spMaterial
                    } else if(el.name === 'bumper_front.007') {
                        el.material = glassMaterial
                        
                        const light = new THREE.PointLight(0xffffff,50);
                        // const position = el.getWorldPosition(new THREE.Vector3());
                        // light.position.set(5,5,5);
                        // light.castShadow = true;
                        const position = getObjCenter(el)
                        console.log(position);
                        const ball1 = new THREE.Mesh(
                            new THREE.SphereGeometry(0.1,32,32),
                            new THREE.MeshBasicMaterial()
                        )
                        const ball2 = new THREE.Mesh(
                            new THREE.SphereGeometry(0.1,32,32),
                            new THREE.MeshBasicMaterial()
                        )
                        ball1.position.set(1.2,position.y,position.z);
                        ball2.position.set(-1.2,position.y,position.z);
                        ball1.add(light);
                        ball2.add(light);
                        el.add(ball1);
                        el.add(ball2);
                    }
                }
            })
            sence.add(sences);
        })
        const light1 = new THREE.DirectionalLight(0xffffff,0.5);
        light1.position.set(0,0,10);
        const light2 = new THREE.DirectionalLight(0xffffff,0.5);
        light2.position.set(0,0,-10);
        const light3 = new THREE.DirectionalLight(0xffffff,0.5);
        light3.position.set(10,0,0);
        const light4 = new THREE.DirectionalLight(0xffffff,0.5);
        light4.position.set(-10,0,0);
        const light5 = new THREE.DirectionalLight(0xffffff,0.5);
        light5.position.set(0,10,0);
        const light6 = new THREE.DirectionalLight(0xffffff,0.5);
        light6.position.set(5,10,10);
        const light7 = new THREE.DirectionalLight(0xffffff,0.5);
        light7.position.set(0,10,5);

        sence.add(light1);
        sence.add(light2);
        sence.add(light3);
        sence.add(light4);
        sence.add(light5);
        sence.add(light6);
        sence.add(light7);
        sence.add(gridHelper);
    })
</script>
<style></style>