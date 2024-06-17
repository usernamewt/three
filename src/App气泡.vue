<template>
    <div ref="tDom" style="width: 100vw;height: 100vh;"></div>
</template>

<script setup>
/* eslint-disable */
    import * as THREE from 'three';
    import  {ref, onMounted } from 'vue';
    import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
    import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader';
    import { GUI } from 'three/examples/jsm/libs/lil-gui.module.min';
    let tDom = ref(null)
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(45,window.innerWidth/window.innerHeight,0.1,1000);
    camera.position.set(20,20,20);
    camera.lookAt(0,0,0);
    const renderer = new THREE.WebGLRenderer({antialias:true});

    const render = ()=>{
        requestAnimationFrame(render);
        renderer.render(scene,camera);

        // 清除物体
        // scene.remove(obj)
        // 清除几何体
        // geomerty.dispose()
        // 清除材质
        // material.dispose()
        // 清除贴图
        // tetxture.dispose()
    }
    renderer.setSize(window.innerWidth,window.innerHeight);
    

    onMounted(()=>{
        tDom.value.appendChild(renderer.domElement);
        render();
        new OrbitControls(camera,renderer.domElement);
        const textLoader = new THREE.TextureLoader();
        const brick = textLoader.load('./textures/brick/brick_roughness.jpg');
        const spher = new THREE.SphereGeometry(10,60,60);
        const material = new THREE.MeshPhysicalMaterial({
            transparent:true,
            roughness:0.05,
            transmission:1,
            thickness:0.1,
            iridescence:1,
            reflectivity:1,
            iridescenceIOR:1.3,
            iridescenceThicknessRange:[100,400],
            // iridescenceMap:brick
        })

        scene.add(new THREE.Mesh(spher,material));
        const gui = new GUI();
        gui.add(material,'iridescence',0,1).name("彩虹色");
        gui.add(material,'reflectivity',0,1).name("反射率");
        gui.add(material,'iridescenceIOR',0,4).name("折射率");

        
        // hdr图中包含了光照数据,不需要再次在场景中添加重复的光源
        const rgbLoader = new RGBELoader()
        rgbLoader.load('./textures/Alex_Hart-Nature_Lab_Bones_2k.hdr',text=>{
            text.mapping = THREE.EquirectangularReflectionMapping;
            scene.background = text;
            scene.environment = text;
        })
        
    })
</script>

<style>
</style>