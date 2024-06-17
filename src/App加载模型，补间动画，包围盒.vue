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
    const parentMeterial = new Three.MeshBasicMaterial({color:'fff'});
    parentMeterial.wireframe = true;
  
    renderer.setSize(window.innerWidth,window.innerHeight);
    const appDom = document.getElementById('app')
    appDom.append(renderer.domElement);
    // 创建几何体
    const geometry = new Three.SphereGeometry(1,32,32);
    // 创建材质
    const material = new Three.MeshBasicMaterial({color:"#f10"});
    // 创建网格
    const cube = new Three.Mesh(geometry,material);
    const ballo = new Three.Mesh(new Three.SphereGeometry(1,32,32),new Three.MeshBasicMaterial({color:"red"}))
    ballo.position.x = -4;
    const ballt = new Three.Mesh(new Three.SphereGeometry(1,32,32),new Three.MeshBasicMaterial({color:"cyan"}))
    ballt.position.x = 0;
    cube.position.set(4,0,0);
    // 将网格添加到场景中
    sence.add(cube);
    sence.add(ballo);
    sence.add(ballt);
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

    // 创建射线
    const raycaster = new Three.Raycaster();
    // 创建鼠标向量(二维)
    const mouse = new Three.Vector2();

    // 使用框体选中
    function selectBoxOneById(id,type){
      let objMesh = sence.getObjectById(id);
      console.log(objMesh);
      let objGeometry = objMesh.geometry;
      // 计算包围盒
      objGeometry.computeBoundingBox();
      // 设置几何体居中
      objGeometry.center();
      if(type!=='ball'){
        // 获取物体包围盒
        let box = objGeometry.boundingBox;
        // 更新世界矩阵
        objMesh.updateWorldMatrix(true,true);
        // 更新包围盒
        box.applyMatrix4(objMesh.matrixWorld);
        // 获取包围盒中心点
        let center = box.getCenter(new Three.Vector3());
        console.log(center);
        let boxHelper = new Three.Box3Helper(box,0xffff00);
        sence.add(boxHelper);
      } else {
        let ball = objGeometry.boundingSphere;
        objMesh.updateWorldMatrix(true,true);
        ball.applyMatrix4(objMesh.matrixWorld);
        // let center = box.getCenter(new Three.Vector3());
        // let sphere = new Three.Sphere(ball.center,ball.radius);
        let sphereGeometry = new Three.SphereGeometry(ball.radius+1,32,32);
        let sphereMaterial = new Three.MeshBasicMaterial({
          color:0xffff00,
          wireframe:true
        })
        let sphereMesh = new Three.Mesh(sphereGeometry,sphereMaterial);
        sphereMesh.position.copy(ball.center);
        sence.add(sphereMesh);
        // sence.add(sphere);
      }
      
    }

    window.addEventListener('click',(e)=> {
      mouse.x = (e.clientX / window.innerWidth) * 2 - 1;
      mouse.y = -((e.clientY / window.innerHeight) * 2 - 1);
      // 通过相机和鼠标位置更新射线
      raycaster.setFromCamera(mouse,camera)

      // 计算物体和射线的焦点
      const intersects = raycaster.intersectObjects([cube,ballo,ballt]);
      if (intersects.length) {
        console.log(intersects[0].object.id);
        selectBoxOneById(intersects[0].object.id,'ball');
        // 设置物体的选中参数
        // const tag = intersects[0].object.toggle || false;
        // let color = intersects[0].object.material.color;
        // if(tag){
        //   intersects[0].object.toggle = false;
        //   color = intersects[0].object._origin
        // }else {
        //   intersects[0].object.toggle = true;
        //   intersects[0].object._origin = color.getHex();
        //   color = 'green';
        // }
        // intersects[0].object.material.color.set(color);
      }
    })

    // 创建补间对象
    const twe = new tween.Tween(cube.position);
    twe.to({x:4},1000);
    // 缓动函数
    twe.easing(tween.Easing.Quadratic.InOut);
    const tweo = new tween.Tween(cube.position);
    tweo.to({x:0},1000);
    twe.chain(tweo);
    tweo.chain(twe);
    
    twe.onStop(p=>{
      console.log(p);
    })
    // 更新回调
    // .onUpdate(el=>{console.log(el);});
    // 设置重复次数
    // twe.repeat()
    // twe.repeat(Infinity);
    // twe.yoyo(true);
    // twe.start();
    gui.add({stop:function(){twe.stop().onStop(e=>{console.log(e);})}},"stop").name("暂停")
    gui.add({start:function(){twe.start()}},"start").name("继续")
  
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
  