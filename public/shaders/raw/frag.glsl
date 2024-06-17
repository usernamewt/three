precision lowp float;
varying vec2 vUv;
uniform sampler2D pic;
varying vec4 vPosition;
varying vec4 gPosition;

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
    vec4 redColor = vec4(1,0,0,1);
    vec4 yellowColor = vec4(1,1,0.5,1);
    vec4 mixColor = mix(yellowColor,redColor,gPosition.y/3.0);
    gl_FragColor = vec4(mixColor.xyz,1);
}