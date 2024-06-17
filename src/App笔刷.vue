<template>
    <div ref="tDom" style="width: 100vw;height: 100vh;position: fixed;left: 0;top: 0;">
        <!-- <canvas id="myCanvas" width="200" height="100" style="border:1px solid #000000;">
        </canvas> -->
    </div>
</template>

<script setup>
/* eslint-disable */
    import  {ref, onMounted } from 'vue';
    let tDom = ref(null)
    const canvas = document.createElement("canvas");
    
    onMounted(()=>{

        tDom.value.appendChild(canvas);
        // const width = tDom.value.clientWidth;
        // const height = tDom.value.clientHeight;
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
        // console.dir(tDom.value);
        // canvas.width = width;
        // canvas.height = height;
        const ctx = canvas.getContext("2d");
        function moveEvent(e){
            console.log(e);
                ctx.lineTo(e.screenX,e.screenY-120);
                ctx.stroke();
        }
        let flag = false;
        canvas.addEventListener("mousedown",e=>{
            console.log(e.screenX,e.screenY);
            ctx.beginPath();
            ctx.moveTo(e.screenX,e.screenY-120);
            flag = true;
        })

        canvas.addEventListener("mousemove",ev=>{
            if(flag){
                moveEvent(ev)
            }
        })

        canvas.addEventListener("mouseup",(e)=>{
            console.log(e);
            flag = false;
            canvas.removeEventListener("mousemove",moveEvent);
            // ctx.stroke();
        })
    })
    
</script>

<style>
</style>