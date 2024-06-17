<template>
    <div style="position: fixed;left: 0;height: 100vh;">
        <div  v-for="(item,i) in scenes" :key="i"
        style="font-size: 50px;color: aliceblue;transition:all 0.5s ease;height: 100vh;" 
        :style="{transform: `translate3d(0,-${index*100}vh,0)`}">
            {{ item.text }}
        </div>
    </div>
</template>
<script setup>
/* eslint-disable */
    import * as THREE from 'three';
    import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
    import { GLTFLoader} from 'three/examples/jsm/loaders/GLTFLoader'
    import gsap from 'gsap'
    import { DRACOLoader } from 'three/examples/jsm/loaders/DRACOLoader';
    import {RGBELoader} from 'three/examples/jsm/loaders/RGBELoader';
    import {GUI} from "three/examples/jsm/libs/lil-gui.module.min.js";
    import {Water} from "three/examples/jsm/objects/Water2"
    import { MTLLoader} from 'three/examples/jsm/loaders/MTLLoader'
    import {ref} from 'vue'

    const sence = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(75,window.innerWidth/innerHeight,0.1,1000);
    camera.position.set(-3.23,2.98,4.06);
    camera.updateProjectionMatrix();

    // 渲染器
    const renderer = new THREE.WebGLRenderer({
        // 设置抗锯齿
        antialias:true
    })
    renderer.setSize(window.innerWidth,window.innerHeight);
    // 在dom的body中添加three
    document.body.appendChild(renderer.domElement);
    // TODO
    // renderer.outputColorSpace = THREE.SRGBColorSpace
    // 设置色调映射
    renderer.toneMapping = THREE.ACESFilmicToneMapping;
    renderer.shadowMap.enabled = true;
    // 设置物理光

    // 设置水纹

    // 初始化控制器
    const controller  = new OrbitControls(camera,renderer.domElement);
    controller.enableDamping = true;
    // 初始化解压器
    const dracoLoader = new DRACOLoader();
    dracoLoader.setDecoderPath('./draco/');
    // 创建加载器
    const gltfLoader = new GLTFLoader();
    gltfLoader.setDRACOLoader(dracoLoader)
    // 加载模型
    gltfLoader.load('./model/scene.glb',(glb)=>{
        console.log(glb);
        const model = glb.scene;
        model.traverse(children=>{
            if(children.name === 'Plane'){
                children.visible = false;
            }
            if(children.isMesh) {
                children.castShadow = true;
                children.receiveShadow = true;
            }
        })
        sence.add(model);
    })
    
    // 创建水面
    const waterPlant = new THREE.CircleGeometry(300,32);
    const water = new Water(waterPlant,{
        textureWidth:1024,
        textureHeight:1024,
        color:0xeeeeff,
        flowDirection: new THREE.Vector2(1,1),
        scale:100
    })
    water.rotation.x = -Math.PI/2;
    // water.rotation.y = 0.4;
    sence.add(water)
    // 创建gui
    const gui = new GUI();
    // 加载环境纹理
    let rgbeLoader = new RGBELoader();
    rgbeLoader.load('./textures/sky.hdr',el=>{
        el.mapping = THREE.EquirectangularReflectionMapping;
        sence.background = el;
        sence.environment = el;
    });
    // 添加光源
    const light = new THREE.AmbientLight(0xffffff,1);
    light.position.set(0,50,0);
    // 创建点光源
    const pointLight = new THREE.PointLight(0xffffff,50);
    pointLight.position.set(0.1,2.4,0);
    pointLight.castShadow = true;

    sence.add(light);
    sence.add(pointLight);

    let options = {
        angel:0
    }

    const index = ref(0);
    
    let time1 = gsap.timeline();
    let time2 = gsap.timeline();


    function translateCamera(position,target){ 
        time1.to(camera.position,{
            x:position.x,
            y:position.y,
            z:position.z,
            duration: 1,
            ease: "power2.inOut"
        });
        time2.to(controller.target,{
            x:position.x,
            y:position.y,
            z:position.z,
            duration: 1,
            ease: "power2.inOut"
        })
    }

    let scenes = [
        {
            text:"第一个分镜",
            callback:() =>{
                translateCamera(
                    new THREE.Vector3(-3.23,3,4.06),
                    new THREE.Vector3(-8,2,0),
                )
            }
        },
        {
            text:"第二个分镜",
            callback:() =>{
                translateCamera(
                    new THREE.Vector3(7,0,23),
                    new THREE.Vector3(0,0,0)
                )
            }
        },
        {
            text:"第三个分镜",
            callback:() =>{
                translateCamera(
                    new THREE.Vector3(10,3,0),
                    new THREE.Vector3(5,2,0),
                );
                heartAnimate();
            }
        }
    ]
    const isAnimate = ref(false);
    window.addEventListener("wheel",(e)=>{
        if(isAnimate.value)
        return
        if(e.deltaY>0){
            isAnimate.value = true;
            index.value++;
            if(index.value>scenes.length-1){
                index.value = 0;
            }
            scenes[index.value].callback();
            setTimeout(() => {
                isAnimate.value = false;
            }, 1000);
        }
    },false);

    // 创建点光源组
    const pointG = new THREE.Group();
    const radius = 3;
    const pointArr = []
    pointG.position.set(-8,2.5,-1.5)
    for (let index = 1; index <= 3; index++) {
        const sphere = new THREE.Mesh(
            new THREE.SphereGeometry(0.2,32,32),
            new THREE.MeshStandardMaterial({
                color:0xffffff,
                emissive:0xffffff,
                // 颜色强度
                emissiveIntensity:10
            })
        )
        sphere.position.set(
            Math.random()*index,
            Math.random()*index/3,
            Math.random()*index
        )
        let points = new THREE.PointLight(0xffffff,50);
        sphere.add(points);
        pointArr.push(sphere)
        pointG.add(sphere);
    }
    sence.add(pointG);

    // 使用补间函数
    gsap.to(options,{
        angel:Math.PI*2,
        duration:10,
        repeat:-1,
        ease:"linear",
        onUpdate:()=>{
            pointG.rotation.y = options.angel;
            pointArr.forEach((el,index)=>{
                el.position.set(
                    radius * Math.cos((index*2*Math.PI)/3),
                    Math.cos((index*2*Math.PI)/3+options.angel),
                    radius * Math.sin((index*2*Math.PI)/3)
                )
            })
        }
    })
    function render(){
        requestAnimationFrame(render);
        renderer.render(sence,camera);
        controller.update();
    }
    render();
    // 创建菜单
    gui.add(renderer,'toneMappingExposure').min(0).max(4).step(0.1).name('世界曝光')
    // 路灯光源

    // 实例化创建星星
    // 构造100个球
    const starGeo = new THREE.InstancedMesh(
        new THREE.SphereGeometry(0.1,32,32),
        new THREE.MeshStandardMaterial({
            color:0xffffff,
            emissive:0xffffff,
            emissiveIntensity:10
        }),100
    )
    console.log(starGeo);
    let startArr = [];
    let endArr = [];
    for (let index = 0; index < 100; index++) {
        let x = Math.random()*100 - 50;
        let y = Math.random()*100 - 50;
        let z = Math.random()*100 - 50;
        // 创建100个随机点
        startArr.push(new THREE.Vector3(x,y,z));
        // 创建矩阵位置
        let matx = new THREE.Matrix4();
        matx.setPosition(x,y,z);
        console.log(matx);
        starGeo.setMatrixAt(index,matx)
        // starGeo[index].position
    }
    sence.add(starGeo);

    let heartShap = new THREE.Shape();
    heartShap.moveTo(25,25);
    heartShap.bezierCurveTo(25,25,20,0,0,0);
    heartShap.bezierCurveTo(-30,0,-30,35,-30,35);
    heartShap.bezierCurveTo(-30,55,-10,77,25,95);
    heartShap.bezierCurveTo(60,77,80,55,80,35);
    heartShap.bezierCurveTo(80,35,80,0,50,0);
    heartShap.bezierCurveTo(35,0,25,25,25,25);
    let center = new THREE.Vector3(0,2,10)
    for (let index = 0; index < 100; index++) {
        let point = heartShap.getPoint(index/100)
        endArr.push(new THREE.Vector3(point.x*0.1,point.y*0.1,center.z));
    }

    // 创建爱心动画
    function heartAnimate(){
        let param = {
            time:0
        }

        gsap.to(param,{
            time:1,
            duration:1,
            onUpdate:()=>{
                for (let i = 0; i < 100; i++) {
                    let x = startArr[i].x + (endArr[i].x-startArr[i].x)*param.time;             
                    let y = startArr[i].y + (endArr[i].y-startArr[i].y)*param.time;             
                    let z = startArr[i].z + (endArr[i].z-startArr[i].z)*param.time; 
                    let matrix = new THREE.Matrix4();
                    matrix.setPosition(x,y,z);
                    starGeo.setMatrixAt(i,matrix);         
                }
                starGeo.instanceMatrix.needsUpdate = true;
            }
        })
    }


</script>
<style></style>