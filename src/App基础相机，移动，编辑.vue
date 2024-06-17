<template>
  <div>
   
  </div>
</template>
<script setup>
  import HelloWorld from './components/HelloWorld.vue'
  import * as Three from 'three'
  // 导入轨道控制器，移动画布用
  import {OrbitControls} from "three/examples/jsm/controls/OrbitControls"
  // 导入gui编辑材料器,创建快捷按钮等编辑框
  import {GUI} from "three/examples/jsm/libs/lil-gui.module.min.js"

  console.log(Three);
  const sence = new Three.Scene();
  // 创建相机
  const camera = new Three.PerspectiveCamera(
      45, //视角
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
  const geometry = new Three.BoxGeometry(1,1,1);
  // 创建材质
  const material = new Three.MeshBasicMaterial({color:"#f10"});
  // 创建网格
  const parentC = new Three.Mesh(geometry,parentMeterial);
  const cube = new Three.Mesh(geometry,material);
  parentC.add(cube)
  // 设置位置
  parentC.position.set(3,0,1);
  cube.position.set(0,2,0);
  // 将网格添加到场景中
  sence.add(parentC);
  // 设置相机的位置
  camera.position.z = 5;
  camera.position.x = 5;
  camera.position.y = 5;
  // 设置相机的目标方向
  camera.lookAt(0,0,0);

  // 添加世界坐标辅助器
  const axesHelper = new Three.AxesHelper(5);
  sence.add(axesHelper);
  const controls = new OrbitControls(camera,renderer.domElement);
  // 设置控制器阻尼
  controls.enableDamping = true;
  // 设置控制器系数
  controls.dampingFactor = 0.05;
  // 设置自动旋转
  // controls.autoRotate = true;

  
  // renderer.render(sence,camera);

  // 渲染到画布上
  function animate(){
    controls.update();
    requestAnimationFrame(animate);
    // cube.rotation.x+=0.01;
    // cube.rotation.y+=0.01;
    // 
    renderer.render(sence,camera);
  }
  animate();

  // 监听窗口大小变化更改画布显示
  window.addEventListener('resize',()=> {
    renderer.reSize(window.innerWidth,window.innerHeight);
    camera.aspect = window.innerWidth/window.innerHeight;
    camera.updateProjectionMatrix();
  })
  const gui = new GUI();

  let eventObj = {
    full:function(){
      // 使画布全屏
      renderer.domElement.requestFullscreen();
    },
    exitFull:function(){
      // 退出全屏
      renderer.domElement.exitFullscreen();
    }
  }

  gui.add(eventObj,"full").name("全屏");
  gui.add(eventObj,"exitFull").name("退出全屏");
  gui.add(parentMeterial,'wireframe').name('设置线框类型');
  let folder = gui.addFolder("文件夹");
  folder.add(parentC.position,'x').min(-10).max(10).step(2).name("x位置").onChange(val=>{
    // 改变了就触发
    console.log(val);
  })
  folder.add(parentC.position,'y').min(-10).max(10).step(2).name("y位置").onFinishChange(val=>{
    // 事件结束后触发，防抖
  })
  folder.add(parentC.position,'z').min(-10).max(10).step(2).name("z位置")
  gui.addColor({colors:"#fff"},"colors").name('设置颜色').onChange(val=>{
    parentC.material.color.set(val);
  })

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
