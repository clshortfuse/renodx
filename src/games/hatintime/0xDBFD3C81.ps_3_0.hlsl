sampler2D SceneColorTexture;
sampler2D EdgeCountTexture;
float4 gParam;

float4 main(float2 texcoord: TEXCOORD) : COLOR {
  float4 o;

  float4 r0;
  float4 r1;
  float4 r2;
  float4 r3;
  float4 r4;
  float4 r5;
  float4 r6;
  float4 r7;
  float4 r8;
  float4 r9;
  float4 r10;
  float4 r11;
  r0 = tex2D(SceneColorTexture, texcoord.xy);
  return r0;
  r1 = float4(1, 1, 0, 0) * texcoord.xyxx;
  r1 = tex2Dlod(EdgeCountTexture, r1);
  r2 = frac(r1.xxyy);
  r3 = r1.xxyy + -r2.yyww;
  r2 = (-r2 >= 0) ? 0 : 1;
  r1 = (r1.xxyy >= 0) ? 0 : r2;
  r1 = r1 + r3;
  r2.x = 1 / gParam.x;
  r2.y = 1 / gParam.y;
  r3.xyz = r2.yxy * float3(-1, 1, 0);
  r4.xy = r2.xy * float2(-0, 1) + texcoord.xy;
  r4.zw = float2(1, 0) * texcoord.xx;
  r5 = tex2Dlod(EdgeCountTexture, r4.zyww);
  r0.w = frac(r5.x);
  r2.z = r5.x + -r0.w;
  r0.w = (-r0.w >= 0) ? 0 : 1;
  r0.w = (r5.x >= 0) ? 0 : r0.w;
  r0.w = r0.w + r2.z;
  r5.xy = r2.xy * float2(-1, -0) + texcoord.xy;
  r5.z = 0;
  r6 = tex2Dlod(EdgeCountTexture, r5.xyzz);
  r2.z = frac(r6.y);
  r2.w = r6.y + -r2.z;
  r2.z = (-r2.z >= 0) ? 0 : 1;
  r2.z = (r6.y >= 0) ? 0 : r2.z;
  r2.z = r2.z + r2.w;
  r6 = r1.yyww * float4(0.0625, 0.00390625, 0.0625, 0.00390625);
  r6 = frac(abs(r6));
  r1 = (r1 >= 0) ? r6 : -r6;
  r6 = r1 + -0.5;
  r7 = (r6 >= 0) ? 1 : 0;
  r7.xy = r7.yw + r7.xz;
  [branch]
  if (-r7.x < 0) {
    r8 = r1.yyxx * 16;
    r9 = frac(r8.yyww);
    r8 = r8 + -r9;
    r9 = r8.yyww * 0.0625;
    r9 = frac(abs(r9));
    r9 = (r8.yyww >= 0) ? r9 : -r9.yyww;
    r9 = r9 + -0.5;
    r9 = (r9 >= 0) ? -8 : -0;
    r8 = r8 + r9;
    [branch]
    if (r8.y == -r8.w) {
    } else {
      r8 = (r6.yyxx >= 0) ? r8 : 8;
      r1.x = r8.w + r8.y;
      r1.x = r1.x + 1;
      r9.xy = r3.yz * -r8.yy + texcoord.xy;
      r9.zw = 0;
      r9 = tex2Dlod(SceneColorTexture, r9);
      r10 = r8 + 1;
      r11.xy = r3.yz * -r10.xy + texcoord.xy;
      r11.zw = 0;
      r11 = tex2Dlod(SceneColorTexture, r11);
      r1.y = r9.w + -r11.w;
      r1.y = -abs(r1.y) + gParam.z;
      r9.xy = r3.yz * r8.ww + texcoord.xy;
      r9.zw = 0;
      r9 = tex2Dlod(SceneColorTexture, r9);
      r10.xy = r3.yz * r10.zw + texcoord.xy;
      r10.zw = 0;
      r10 = tex2Dlod(SceneColorTexture, r10);
      r2.w = r9.w + -r10.w;
      r2.w = -abs(r2.w) + gParam.z;
      r6.xy = (r1.yy >= 0) ? float2(0, 2) : float2(1, 3);
      r1.y = (r2.w >= 0) ? r6.x : r6.y;
      r7.xzw = r1.yyy + float3(-2, -2, -1);
      r1.y = r1.x * -0.5 + r8.y;
      r1.y = (r1.y >= 0) ? 1 : 0;
      r1.y = (-abs(r7.x) >= 0) ? r1.y : 0;
      r2.w = r1.x * 0.5 + -r8.y;
      r2.w = (r2.w >= 0) ? 1 : 0;
      r2.w = (-abs(r7.z) >= 0) ? r2.w : 0;
      r1.y = r1.y + r2.w;
      r1.y = (-r1.y >= 0) ? 0 : 1;
      r2.w = (r7.w >= 0) ? 1 : 0;
      r1.y = r1.y + r2.w;
      r9.y = r2.y * -1 + texcoord.y;
      r9.zw = float2(1, 0) * texcoord.xx;
      r9 = tex2Dlod(SceneColorTexture, r9.zyww);
      r2.w = 1 / r1.x;
      r1.x = -r8.y + r1.x;
      r3.w = r2.w * r1.x + -0.5;
      r1.x = r1.x + -1;
      r1.x = r2.w * r1.x + -0.5;
      r1.x = abs(r1.x) + abs(r3.w);
      r1.x = r1.x * 0.5;
      r7.xzw = r0.xyz * r0.xyz;
      r8.xyz = r9.xyz * r9.xyz + -r7.xzw;
      r7.xzw = r1.xxx * r8.xyz + r7.xzw;
      r1.x = 1 / sqrt(r7.x);
      r2.w = 1 / sqrt(r7.z);
      r3.w = 1 / sqrt(r7.w);
      r8.x = 1 / r1.x;
      r8.y = 1 / r2.w;
      r8.z = 1 / r3.w;
      r0.xyz = (-r1.yyy >= 0) ? r0.xyz : r8.xyz;
    }
  }
  r8 = r0.w * float4(0.00390625, 0.00390625, 0.0625, 0.0625);
  r8 = frac(abs(r8));
  r8 = (r0.w >= 0) ? r8 : -r8.yyww;
  r9 = r8.yyww + -0.5;
  r1.xy = (r9.wy >= 0) ? 1 : 0;
  r0.w = r1.y + r1.x;
  [branch]
  if (-r0.w < 0) {
    r8 = r8 * 16;
    r10 = frac(r8.yyww);
    r8 = r8 + -r10;
    r10 = r8.yyww * 0.0625;
    r10 = frac(abs(r10));
    r10 = (r8.yyww >= 0) ? r10 : -r10.yyww;
    r10 = r10 + -0.5;
    r10 = (r10 >= 0) ? -8 : -0;
    r8 = r8 + r10;
    [branch]
    if (r8.y == -r8.w) {
    } else {
      r8 = (r9 >= 0) ? r8 : 8;
      r0.w = r8.w + r8.y;
      r0.w = r0.w + 1;
      r9.xy = r3.yz * -r8.yy + r4.xy;
      r9.zw = 0;
      r9 = tex2Dlod(SceneColorTexture, r9);
      r10 = r8 + 1;
      r11.xy = r3.yz * -r10.xy + r4.xy;
      r11.zw = 0;
      r11 = tex2Dlod(SceneColorTexture, r11);
      r1.x = r9.w + -r11.w;
      r9.xy = r3.yz * r8.ww + r4.xy;
      r9.zw = 0;
      r9 = tex2Dlod(SceneColorTexture, r9);
      r10.xy = r3.yz * r10.zw + r4.xy;
      r10.zw = 0;
      r10 = tex2Dlod(SceneColorTexture, r10);
      r1.y = r9.w + -r10.w;
      r1.xy = -abs(r1.xy) + gParam.zz;
      r3.yz = (r1.xx >= 0) ? 0 : float2(0, 1);
      r1.x = (r1.y >= 0) ? r3.y : r3.z;
      r3.yz = r1.xx + float2(-8, -2);
      r1.y = r0.w * 0.5 + -r8.y;
      r1.y = (r1.y >= 0) ? 1 : 0;
      r1.y = (-abs(r3.y) >= 0) ? r1.y : 0;
      r2.w = r0.w * -0.5 + r8.y;
      r2.w = (r2.w >= 0) ? 1 : 0;
      r2.w = (-abs(r3.z) >= 0) ? r2.w : 0;
      r1.y = r1.y + r2.w;
      r1.xy = (-r1.xy >= 0) ? float2(1, 0) : float2(0, 1);
      r1.x = r1.x + r1.y;
      r4 = tex2Dlod(SceneColorTexture, r4.xyww);
      r1.y = 1 / r0.w;
      r0.w = -r8.y + r0.w;
      r2.w = r1.y * r0.w + -0.5;
      r0.w = r0.w + -1;
      r0.w = r1.y * r0.w + -0.5;
      r0.w = abs(r0.w) + abs(r2.w);
      r0.w = r0.w * 0.5;
      r3.yzw = r0.xyz * r0.xyz;
      r4.xyz = r4.xyz * r4.xyz + -r3.yzw;
      r3.yzw = r0.www * r4.xyz + r3.yzw;
      r0.w = 1 / sqrt(r3.y);
      r1.y = 1 / sqrt(r3.z);
      r2.w = 1 / sqrt(r3.w);
      r4.x = 1 / r0.w;
      r4.y = 1 / r1.y;
      r4.z = 1 / r2.w;
      r0.xyz = (-r1.xxx >= 0) ? r0.xyz : r4.xyz;
    }
  }
  [branch]
  if (-r7.y < 0) {
    r1.xy = r1.wz * 16;
    r1.zw = frac(r1.xy);
    r1.xy = -r1.zw + r1.xy;
    r1.zw = r1.xy * 0.0625;
    r1.zw = frac(abs(r1.zw));
    r1.zw = (r1.xy >= 0) ? r1.zw : -r1.zw;
    r1.zw = r1.zw + -0.5;
    r1.zw = (r1.zw >= 0) ? -8 : -0;
    r1.xy = r1.zw + r1.xy;
    [branch]
    if (r1.x == -r1.y) {
    } else {
      r1.xy = (r6.wz >= 0) ? r1.xy : 8;
      r0.w = r1.y + r1.x;
      r0.w = r0.w + 1;
      r3.y = r3.x * -r1.x + texcoord.y;
      r3.zw = float2(1, 0) * texcoord.xx;
      r4 = tex2Dlod(SceneColorTexture, r3.zyww);
      r1.zw = r1.xy + 1;
      r3.y = r3.x * -r1.z + texcoord.y;
      r3.zw = float2(1, 0) * texcoord.xx;
      r6 = tex2Dlod(SceneColorTexture, r3.zyww);
      r1.z = r4.w + -r6.w;
      r3.y = r3.x * r1.y + texcoord.y;
      r3.zw = float2(1, 0) * texcoord.xx;
      r4 = tex2Dlod(SceneColorTexture, r3.zyww);
      r3.y = r3.x * r1.w + texcoord.y;
      r3.zw = float2(1, 0) * texcoord.xx;
      r6 = tex2Dlod(SceneColorTexture, r3.zyww);
      r1.y = r4.w + -r6.w;
      r1.yz = -abs(r1.yz) + gParam.zz;
      r1.zw = (r1.zz >= 0) ? float2(0, 2) : float2(0, 2);
      r1.y = (r1.y >= 0) ? r1.z : r1.w;
      r1.yzw = r1.yyy + float3(-0, -2, -1);
      r2.w = r0.w * -0.5 + r1.x;
      r2.w = (r2.w >= 0) ? 1 : 0;
      r1.y = (-abs(r1.y) >= 0) ? r2.w : 0;
      r2.w = r0.w * 0.5 + -r1.x;
      r2.w = (r2.w >= 0) ? 1 : 0;
      r1.z = (-abs(r1.z) >= 0) ? r2.w : 0;
      r1.y = r1.z + r1.y;
      r1.y = (-r1.y >= 0) ? 0 : 1;
      r1.z = (r1.w >= 0) ? 1 : 0;
      r1.y = r1.z + r1.y;
      r4.xy = r2.xy * float2(1, 0) + texcoord.xy;
      r4.zw = 0;
      r4 = tex2Dlod(SceneColorTexture, r4);
      r1.z = 1 / r0.w;
      r0.w = -r1.x + r0.w;
      r1.x = r1.z * r0.w + -0.5;
      r0.w = r0.w + -1;
      r0.w = r1.z * r0.w + -0.5;
      r0.w = abs(r0.w) + abs(r1.x);
      r0.w = r0.w * 0.5;
      r1.xzw = r0.xyz * r0.xyz;
      r2.xyw = r4.xyz * r4.xyz + -r1.xzw;
      r1.xzw = r0.www * r2.xyw + r1.xzw;
      r0.w = 1 / sqrt(r1.x);
      r1.x = 1 / sqrt(r1.z);
      r1.z = 1 / sqrt(r1.w);
      r4.x = 1 / r0.w;
      r4.y = 1 / r1.x;
      r4.z = 1 / r1.z;
      r0.xyz = (-r1.yyy >= 0) ? r0.xyz : r4.xyz;
    }
  }
  r1.xy = r2.zz * float2(0.00390625, 0.0625);
  r1.xy = frac(abs(r1.xy));
  r1.xy = (r2.zz >= 0) ? r1.xy : -r1.xy;
  r1.zw = r1.xy + -0.5;
  r2.xy = (r1.wz >= 0) ? 1 : 0;
  r0.w = r2.y + r2.x;
  [branch]
  if (-r0.w < 0) {
    r1.xy = r1.xy * 16;
    r2.xy = frac(r1.xy);
    r1.xy = r1.xy + -r2.xy;
    r2.xy = r1.xy * 0.0625;
    r2.xy = frac(abs(r2.xy));
    r2.xy = (r1.xy >= 0) ? r2.xy : -r2.xy;
    r2.xy = r2.xy + -0.5;
    r2.xy = (r2.xy >= 0) ? -8 : -0;
    r1.xy = r1.xy + r2.xy;
    [branch]
    if (r1.x == -r1.y) {
    } else {
      r1.xy = (r1.zw >= 0) ? r1.xy : 8;
      r0.w = r1.y + r1.x;
      r0.w = r0.w + 1;
      r5.w = r3.x * -r1.x + r5.y;
      r2 = tex2Dlod(SceneColorTexture, r5.xwzz);
      r1.zw = r1.xy + 1;
      r3.y = r3.x * -r1.z + r5.y;
      r3.zw = r5.xz;
      r4 = tex2Dlod(SceneColorTexture, r3.zyww);
      r1.z = r2.w + -r4.w;
      r2.y = r3.x * r1.y + r5.y;
      r2.zw = r5.xz;
      r2 = tex2Dlod(SceneColorTexture, r2.zyww);
      r3.y = r3.x * r1.w + r5.y;
      r3.zw = r5.xz;
      r3 = tex2Dlod(SceneColorTexture, r3.zyww);
      r1.y = r2.w + -r3.w;
      r1.yz = -abs(r1.yz) + gParam.zz;
      r1.zw = (r1.zz >= 0) ? float2(0, 2) : float2(0, 2);
      r1.y = (r1.y >= 0) ? r1.z : r1.w;
      r1.zw = r1.yy + float2(-8, -0);
      r2.x = r0.w * 0.5 + -r1.x;
      r2.x = (r2.x >= 0) ? 1 : 0;
      r1.z = (-abs(r1.z) >= 0) ? r2.x : 0;
      r2.x = r0.w * -0.5 + r1.x;
      r2.x = (r2.x >= 0) ? 1 : 0;
      r1.w = (-abs(r1.w) >= 0) ? r2.x : 0;
      r1.z = r1.w + r1.z;
      r1.yz = (-r1.yz >= 0) ? 1 : float2(1, 0);
      r1.y = r1.y + r1.z;
      r2 = tex2Dlod(SceneColorTexture, r5.xyzz);
      r1.z = 1 / r0.w;
      r0.w = -r1.x + r0.w;
      r1.x = r1.z * r0.w + -0.5;
      r0.w = r0.w + -1;
      r0.w = r1.z * r0.w + -0.5;
      r0.w = abs(r0.w) + abs(r1.x);
      r0.w = r0.w * 0.5;
      r1.xzw = r0.xyz * r0.xyz;
      r2.xyz = r2.xyz * r2.xyz + -r1.xzw;
      r1.xzw = r0.www * r2.xyz + r1.xzw;
      r0.w = 1 / sqrt(r1.x);
      r1.x = 1 / sqrt(r1.z);
      r1.z = 1 / sqrt(r1.w);
      r2.x = 1 / r0.w;
      r2.y = 1 / r1.x;
      r2.z = 1 / r1.z;
      r0.xyz = (-r1.y >= 0) ? r0.xyz : r2.xyz;
    }
  }
  o.xyz = r0.xyz;
  o.w = 1;

  return o;
}
