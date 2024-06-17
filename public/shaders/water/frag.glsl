precision lowp float;
varying vec2 vUv;
uniform sampler2D pic;
varying vec4 gPosition;
varying float vElevation;
uniform vec3 lColor;
uniform vec3 hColor;
uniform float uOpacity;

void main(){
    // 使用uv设置颜色
    // gl_FragColor = vec4(vUv,1.0,1);

    // 使用uv的x设置渐变,y轴同理，-x用（1-vUv.x）
    // float trix = vUv.x;
    // gl_FragColor =vec4(trix,trix,trix,1.0);

    // 取模  就是js中%
    // float trix = vUv.x;
    // float mods = mod(trix*10.0,1.0);
    // gl_FragColor = vec4(mods,mods,mods,1.0);

    // step(val,x) 返回val>x?0.0:1.0  
    // float trix = vUv.x;
    float a = (vElevation+1.0)/2.0;
    vec3 color = mix(lColor,hColor,a);
    gl_FragColor = vec4(color,uOpacity);
}