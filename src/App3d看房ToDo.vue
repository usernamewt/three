
<template>
    <div style="width: 100vw;height: 100vh;" ref="tDom"></div>
</template>
<script setup>
/* eslint-disable */
    import * as THREE from 'three'
    import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader';
    import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
    import { onMounted, ref } from 'vue';

    let tDom = ref(null);
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(75,window.innerWidth/window.innerHeight,0.1,1000);
    camera.position.set(0,0,10);
    const renderer = new THREE.WebGLRenderer({antialias:true});
    renderer.setSize(window.innerWidth,window.innerHeight)
    

    const cube = new THREE.Mesh(
        new THREE.BoxGeometry(20,20,20),
        new THREE.MeshBasicMaterial({color:0xffffff})
    )
    
    const render = ()=>{
        requestAnimationFrame(render);
        renderer.render(scene,camera);
    }
    const arrMaterial = [];
    const arr = ['4_l','4_r','4_u','4_d','4_b','4_f'];
    arr.forEach(el=>{
        let picTextureLoader = new THREE.TextureLoader().load(`./imgs/living/${el}.jpg`);
        if(el === '4_u'||el === '4_d') {
            picTextureLoader.rotation = Math.PI;
            picTextureLoader.center = new THREE.Vector2(0.5,0.5);
        }
        let mesh = new THREE.MeshBasicMaterial({map:picTextureLoader});
        arrMaterial.push(mesh);
    })
    cube.material = arrMaterial;
    cube.geometry.scale(1,1,-1)
    scene.add(cube);
    onMounted(()=>{
        tDom.value.appendChild(renderer.domElement);
        const orbitCtrl = new OrbitControls(camera,tDom.value);
        orbitCtrl.enableDamping = true;
        render();
    })
</script>
<style></style>