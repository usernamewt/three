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
    let mixer = null;
    let mixer1 = null;
    let clock = new Clock();
    renderer.shadowMap.enabled = true;
    renderer.setSize(window.innerWidth,window.innerHeight);
    camera.position.set(40,0,40);
    let render = ()=>{
        // time必须在一个地方获取
        let time = clock.getDelta()
        if(mixer){
            mixer.update(time);
        }
        if(mixer1){
            mixer1.update(time)
        }
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
        const geo = new THREE.BoxGeometry(10,10,10);
        const geoMaterial = new THREE.MeshPhysicalMaterial({
            transparent:true,
            color:0xffff00,
            opacity:0.5
        })
        const box = new THREE.Mesh(geo,geoMaterial);
        box.name = 'donghua'
        // scene.add(box);
        mixer = new THREE.AnimationMixer(box)
        const opacityKF = new THREE.NumberKeyframeTrack(
            "donghua.material.opacity",[0,1,2,3,4],[0.3,0.6,0.9,1,0]
        )

        const showKF = new THREE.BooleanKeyframeTrack(
            "donghua.visible",[0,2,4],[true,false,true]
        )

        const clip = new THREE.AnimationClip("animations",4,[opacityKF,showKF])
        const action = mixer.clipAction(clip);
        action.play();

        const geometry = new THREE.ConeGeometry( 5, 20, 8 );
		const material = new THREE.MeshBasicMaterial( {color: 0xff00ff} );
		const cone = new THREE.Mesh( geometry, material );
        cone.name = 'zhuizi';
        // cone.position.set(-10,0,0)
		scene.add( cone );
        // 创建位移动画帧
        
        const quaternion = new THREE.Quaternion();
        quaternion.setFromEuler(new THREE.Euler(0,0,0));
        const quaternion1 = new THREE.Quaternion();
        quaternion.setFromEuler(new THREE.Euler(0,Math.PI/2,0));
        const quaternion2 = new THREE.Quaternion();
        quaternion.setFromEuler(new THREE.Euler(0,Math.PI,0));
        const quaternion3 = new THREE.Quaternion();
        quaternion.setFromEuler(new THREE.Euler(0,Math.PI*1.5,0));
        const finQ = quaternion.toArray().concat(quaternion1.toArray()).concat(quaternion2.toArray()).concat(quaternion3.toArray());
        const positionKF = new THREE.VectorKeyframeTrack(
            "zhuizi.position",[0,1,2,3,4,5,6],[0,0,0,0,5,0,0,10,0,0,15,0,0,20,0,0,15,0,0,0,0]
        )
        const rotationKF = new THREE.QuaternionKeyframeTrack(
            "zhuizi.quaternion",[0,2,4,6],finQ
        )
        mixer1 = new THREE.AnimationMixer(cone)
        const clip2 = new THREE.AnimationClip('shot',5,[positionKF,rotationKF]);
        const actions = mixer1.clipAction(clip2);
        actions.play();

        // 创建旋转动画帧


    })
    
</script>

<style>
</style>