<template>
    <div>
     <HelloWorld />
    </div>
  </template>
  <script setup>
  /* eslint-disable */
    import HelloWorld from './components/HelloWorld.vue'
    import * as Three from 'three'
    // 导入轨道控制器，移动画布用
    import {OrbitControls} from "three/examples/jsm/controls/OrbitControls"
    // 导入gui编辑材料器,创建快捷按钮等编辑框
    import {GUI} from "three/examples/jsm/libs/lil-gui.module.min.js"

    // 导入gltf模型加载器
    // import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";

    // 导入补间动画
    import * as tween from "three/examples/jsm/libs/tween.module.js"
    const gui = new GUI();
    
    const sence = new Three.Scene();
    // 创建相机
    const camera = new Three.PerspectiveCamera(
        90, //视角
        window.innerWidth / window.innerHeight,//相机宽高比
        0.1,//最近能看到物体
        1000//相机最远能看到的物体
    )
    // 渲染器
    const renderer = new Three.WebGLRenderer();
    const parentMeterial = new Three.MeshBasicMaterial({color:0xffffff});
    parentMeterial.wireframe = true;
  
    renderer.setSize(window.innerWidth,window.innerHeight);
    renderer.shadowMap.enabled = true;
    const appDom = document.getElementById('app')
    appDom.append(renderer.domElement);
    // 创建几何体
    const geometry = new Three.SphereGeometry(1,32,32);
    // 创建材质
    const material = new Three.MeshStandardMaterial();
    // 创建网格
    const cube = new Three.Mesh(geometry,material);
    const ballo = new Three.Mesh(new Three.SphereGeometry(1,32,32),new Three.MeshBasicMaterial({color:"red"}))
    ballo.position.x = -4;
    const ballt = new Three.Mesh(new Three.SphereGeometry(1,32,32),new Three.MeshBasicMaterial({color:"cyan"}))
    ballt.position.x = 0;
    cube.position.set(0,1,0);
    const plant = new Three.Mesh(new Three.PlaneGeometry(100,100),new Three.MeshStandardMaterial());
    // plant.rotateX(270);
    plant.rotation.x = -Math.PI/2
    cube.castShadow = true;
    plant.receiveShadow = true;
    // 将网格添加到场景中
    sence.add(cube);
    sence.add(plant);
    // 创建光源
    // 环境光
    const light = new Three.AmbientLight(0xffffff,0.5);
    sence.add(light)
    //直线光源
    // const directLight = new Three.DirectionalLight(0xffffff,0.5);
    // directLight.position.set(-10,10,10);
    // directLight.castShadow = true;
    // sence.add(directLight); 
    // 
    const lights = new Three.SpotLight(0xffffff,0.5);
    lights.position.set(-10,10,10);
    lights.castShadow = true;
    lights.decay = 0;
    sence.add(lights); 
    // sence.add(ballo);
    // sence.add(ballt);
    // 设置相机的位置
    camera.position.z = 5;
    camera.position.x = 5;
    camera.position.y = 5;
    // 设置相机的目标方向
    camera.lookAt(0,0,0);
  
    // 创建世界坐标辅助器
    const axesHelper = new Three.AxesHelper(5);
    sence.add(axesHelper);
    // 创建控制器
    const controls = new OrbitControls(camera,renderer.domElement);
    // 设置控制器阻尼
    controls.enableDamping = true;
    // 设置控制器系数
    controls.dampingFactor = 0.05;
  
    // 渲染到画布上
    function animate(){
      controls.update();
      requestAnimationFrame(animate);
      renderer.render(sence,camera);
      tween.update();
    }
    animate();
  
    // 监听窗口大小变化更改画布显示
    window.addEventListener('resize',()=> {
      renderer.setSize(window.innerWidth,window.innerHeight);
      camera.aspect = window.innerWidth/window.innerHeight;
      camera.updateProjectionMatrix();
    })

    gui.add(lights,'intensity').min(0.5).max(9).step(0.1).onChange(()=>{
      // lights.shadow.camera.updateProjectionMatrix();
    })

    gui.add(lights,'angle').min(0).max(Math.PI/2).step(0.01).name('光锥半径');
    gui.add(lights,'penumbra').min(0).max(1).step(0.01).name('半影衰减');
    gui.add(lights,'decay').min(0).max(1).step(0.01).name('光照距离衰减');
    

    

  
  </script>
  <style scoped>
  canvas{
    width: 100vw;
    height: 100vh;
    position: fixed;
    left: 0;
    top: 0;
  }
  *{
    margin: 0;
    padding: 0;
  }
  </style>
  