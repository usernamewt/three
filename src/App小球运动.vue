<template>
    <div>
       
        <div ref="tDom" style="width: 100vw;height: 100vh;position: fixed;left: 0;top: 0;"></div>
        <!-- <canvas id="myCanvas" width="200" height="100" style="border:1px solid #000000;">
        </canvas> -->
    </div>
    
</template>

<script setup>
/* eslint-disable */
    import  {ref, onMounted } from 'vue';
    import * as THREE from 'three';
    import * as CANNON from 'cannon-es';
    import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
    let tDom = ref(null)
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(45,window.innerWidth/window.innerHeight,0.1,1000);
    const renderer = new THREE.WebGLRenderer({antialias:true});
    renderer.shadowMap.enabled = true;
    renderer.setSize(window.innerWidth,window.innerHeight);
    camera.position.set(0,2,15);
    let clock = new THREE.Clock();
    let spna;
    let world;
    let spherBody;
    let floatMaterial;
    let balls = [];
    let render = ()=>{
        let time = clock.getDelta();
        requestAnimationFrame(render);
        world.step(1/120,time)
        balls.forEach(el=>{
            el.geo.position.copy(el.world.position);
            el.geo.quaternion.copy(el.world.quaternion);
        })
        renderer.render(scene,camera);
    }
    
    onMounted(()=>{
        tDom.value.appendChild(renderer.domElement);
        new OrbitControls(camera,renderer.domElement);
        const environmentLight = new THREE.AmbientLight(0xffffff,1);
        scene.add(environmentLight)
        const light = new THREE.DirectionalLight(0xffffff,4);
        light.position.set(10,10,0)
        light.castShadow = true;
        scene.add(light);
        
        const plant = new THREE.Mesh(new THREE.PlaneGeometry(10,10),new THREE.MeshStandardMaterial({color:0xffffff}));
        plant.rotation.x = -Math.PI/2;
        plant.position.set(0,-2,0)
        plant.castShadow = true;
        plant.receiveShadow = true;
        scene.add(plant)
        // 创建物理世界
        world = new CANNON.World({gravity:new CANNON.Vec3(0,-9.8,0)});
        createPlant();
       
        render();

    })

    // 创建小球
    function createSphere(){
        // 创建物理小球形状
        const spherBall = new CANNON.Box(new CANNON.Vec3(0.5,0.5,0.5));
        // 创建材质
        const spherMaterial = new CANNON.Material({})
        // 创建物体
        spherBody = new CANNON.Body({
            shape:spherBall,
            position:new CANNON.Vec3(0,0,0),
            // 质量
            mass:1,
            material:spherMaterial
        })
        spherBody.position.set(0,10,0)
        spherBody.applyLocalForce(
            new CANNON.Vec3(300,0,0),
            new CANNON.Vec3(0,0,0)
        )
        // let connect = new CANNON.ContactMaterial(spherMaterial,floatMaterial,{
        //     friction:0.1,
        //     restitution:0.7
        // })
        // world.addContacMaterial(connect);
        const sound = new Audio('media/sound.mp3')
        spherBody.addEventListener("collide",(e)=>{
            const impactStrength = e.contact.getImpactVelocityAlongNormal();
            if (impactStrength > 2) {
                //   重新从零开始播放
                sound.currentTime = 0;
                sound.volume = impactStrength / 20;
                sound.play();
            }
        })
        // 将物体添加到世界
        world.addBody(spherBody);

        spna = new THREE.Mesh(new THREE.BoxGeometry(1,1,1),new THREE.MeshStandardMaterial({color:0xffffff}));
        spna.castShadow = true;
        spna.receiveShadow = true
        spna.position.set(0,10,0);
        scene.add(spna)

        balls.push({geo:spna,world:spherBody})

    }

    // 创建平面
    function createPlant(){
        // 创建物理世界地面
        const floorSphar = new CANNON.Plane();
        const floorBody = new CANNON.Body();
        // 质量为0保持不动
        floorBody.mass = 0;
        floorBody.addShape(floorSphar);
        floorBody.position.set(0,-2,0);
        floatMaterial = new CANNON.Material();
        floorBody.material = floatMaterial;
        floorBody.quaternion.setFromAxisAngle(new CANNON.Vec3(1,0,0),-Math.PI/2);
        world.addBody(floorBody);
    }

    window.addEventListener('click',()=>{
        createSphere();
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