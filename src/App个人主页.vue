<template>
    <div>
        <div class="banner">
            <span>主页</span>
        </div>
        <div class="scroll scroll-one">
            <h1>
                <h2></h2>
            </h1>
        </div>
        <div class="scroll scroll-two">
            <h1>
                <h2></h2>
            </h1>
        </div>
        <div class="scroll scroll-three">
            <h1>
                <h2></h2>
            </h1>
        </div>
        <div ref="tDom" style="width: 100vw;height: 100vh;position: fixed;left: 0;top: 0;"></div>
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
    import { BufferAttribute } from 'three';
import gsap from 'gsap';
    let tDom = ref(null)
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(45,window.innerWidth/window.innerHeight,0.1,1000);
    const renderer = new THREE.WebGLRenderer({antialias:true});
    let rgbeLoader = new RGBELoader();
    let mouse = new THREE.Vector2(0,0);
    const raycaster = new THREE.Raycaster();
    let currentIndex = 0;
    // 创建cbue
    let cubeArr = [];
    let cubeGroup = new THREE.Group();
    // 创建三角体
    let tetrahedGroup = new THREE.Group();
    // 创建小球
    renderer.shadowMap.enabled = true;
    renderer.setSize(window.innerWidth,window.innerHeight);
    camera.position.set(0,0,30);
    let render = ()=>{
        requestAnimationFrame(render);
        camera.position.x = (-mouse.x*3)
        renderer.render(scene,camera);
    }
    
    onMounted(()=>{
        tDom.value.appendChild(renderer.domElement);
        render();
        // const coltrols = new OrbitControls(camera,renderer.domElement);
        // const gltfLoader = new GLTFLoader();
        const environmentLight = new THREE.AmbientLight(0xffffff,5);
        scene.add(environmentLight)
        const light = new THREE.DirectionalLight(0xffffff,4);
        light.position.set(0,10,0)
        light.castShadow = true;
        scene.add(light);
        createCubeMatiex(5,2);
        createTetrahed();
    })

    function createCubeMatiex(number,size){
        for(let x = 0;x<=number;x++){
            for(let y = 0;y<=number;y++){
                for(let z = 0;z<=number;z++){
                    if(x==number||y==number||z==number||z==0||y==0||x==0){
                        const cube = new THREE.BoxGeometry(size,size,size);
                        const cubeMaterial = new THREE.MeshBasicMaterial({
                            wireframe:true
                        });
                        let cubeMesh = new THREE.Mesh(cube,cubeMaterial);
                        const xp = (x*size-size/2)-(number*size)/2;
                        const yp = (y*size-size/2)-(number*size)/2;
                        const zp = (z*size-size/2);
                        cubeMesh.position.set(xp,yp,zp);
                        cubeMesh.name = `${xp}${yp}${zp}`;
                        cubeArr.push(cubeMesh);
                        cubeGroup.add(cubeMesh)
                    }
                    
                }
            }
        }
        scene.add(cubeGroup);
    }

    // 创建随机颜色
    function createRandomColorMaterial(){
        const baseColor = new THREE.Color((Math.random()*255).toFixed(0),(Math.random()*255).toFixed(0),(Math.random()*255).toFixed(0))
        let color = new BufferAttribute(baseColor,3)
        return new THREE.MeshPhysicalMaterial({
            color:`rgb(${(Math.random()*255).toFixed(0)},${(Math.random()*255).toFixed(0)},${(Math.random()*255).toFixed(0)})`,
            transparent:true,
            roughness:0.98
            // vertexColors:true
        })
    }

    // 创建四面体
    function createTetrahed(){
        for(let i = 0;i<100;i++){
            const terd = new THREE.Mesh(new THREE.TetrahedronGeometry(4,0),createRandomColorMaterial());
            terd.position.set(Math.random()*50-25,Math.random()*30-47.5,0);
            tetrahedGroup.add(terd);
        }
        scene.add(tetrahedGroup);
    }

    // 创建线框
    function defColorMaterial(){
        return new THREE.MeshBasicMaterial({
            color:0xffffff,
            wireframe:true
        })
    }


    // 返回射线选中的mesh
    function getRaycasterMesh(x,y){
        const mouses = new THREE.Vector2();
        mouses.x = (x / window.innerWidth) * 2 - 1;
        mouses.y = -((y / window.innerHeight) * 2 - 1);
        raycaster.setFromCamera(mouses, camera);
        let result = raycaster.intersectObjects(cubeArr);
        return result;
    }

    window.addEventListener("click",e=>{
        let allBox = getRaycasterMesh(e.clientX,e.clientY);
        console.log(allBox);
        allBox.forEach(el=>{
            console.log(el.object.name);
            el.object.material = createRandomColorMaterial();
        })
    })
    window.addEventListener("contextmenu",e=>{
        e.preventDefault();
        let allBox = getRaycasterMesh(e.clientX,e.clientY);
        console.log(allBox);
        allBox.forEach(el=>{
            el.object.material = defColorMaterial();
        })
    })
    window.addEventListener("resize", () => {
        //   console.log("画面变化了");
        // 更新摄像头
        camera.aspect = window.innerWidth / window.innerHeight;
        //   更新摄像机的投影矩阵
        camera.updateProjectionMatrix();

        //   更新渲染器
        renderer.setSize(window.innerWidth, window.innerHeight);
        //   设置渲染器的像素比
        renderer.setPixelRatio(window.devicePixelRatio);
    });

    window.addEventListener("mousemove",e=>{
        e.preventDefault();
        mouse.x = e.clientX/window.innerWidth;
    })

    window.addEventListener("scroll",e=>{
        let scrollIdx = (window.scrollY/window.innerHeight).toFixed(0);
        if(scrollIdx!=currentIndex){
            if(scrollIdx>currentIndex){
                gsap.to(camera.position,{
                    y:"-="+30
                })
            } else {
                gsap.to(camera.position,{
                    y:"+="+30
                })
            }
            currentIndex = scrollIdx
        }
    })
    
</script>

<style>
.scroll{
    width: 100%;
    height: 100vh;
}
.banner{
    position: fixed;
    top: 0;
    left: 0;
    width: 100vh;
    height: 60px;
    display: flex;
    align-items: center;
    color: #ffffff;
    padding: 0 20px;
    z-index: 2;
}
span{
    cursor: pointer;
}
</style>