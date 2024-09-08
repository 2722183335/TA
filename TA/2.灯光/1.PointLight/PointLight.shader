Shader "LK/PointShader"
{
    Properties
    {
        _Wrap("Wrap", Float) = 0.0
        _StripNum("StripNum",Float) = 0.0
        _B("B",Float) = 0.0
        _E("E",Float) = 0.0
        _S("S",Float) = 0.0
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma target 3.0
            #pragma vertex  vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            struct appdata
            {
                float4 posOS : POSITION;
                float3 normal : NORMAL;
            };

            struct  v2f
            {
                float4 vertex:SV_POSITION;
                float3 nor:TEXCOORD7;
                float3 worldPos:TEXCOORD6;
            };

            v2f vert(appdata v)
            {
                v2f r;
                r.vertex=UnityObjectToClipPos(v.posOS);
                r.nor=UnityObjectToWorldNormal(v.normal);
                r.worldPos=mul(unity_ObjectToWorld,v.posOS);
                return r;
            }

            float _Wrap;
            float _StripNum;
            float _S;
            float _E;
            float _B;
            float4 _PointLightColorAndRange;
            float4 _PointLightPos;

            float Diffuse_Wrap(float3 n,float3 l,float wrap=0.5)
            {
                return saturate(dot(n,l))*wrap/(1+wrap);
            }
            float Specular_BinPhong(float3 N,float3 L,float3 V,float2 BPPowScale)
            {
                float3 H=normalize(L+V);
                return pow(saturate(dot(N,H)),BPPowScale.x*100)*BPPowScale.y;
            }
            float3 Lighting(float3 N,float3 L,float3 V,float2 BPPowScale,float wrap=0.5)
            {
                return  Diffuse_Wrap(N,L,wrap)+Specular_BinPhong(N,L,V,BPPowScale);
            }
            fixed3 frag(v2f i) : SV_Target
            {
                // //°ëÀ¼²®ÌØÄ£ÐÍ
                // float nl05=dot(i.nor,_WorldSpaceLightPos0)*0.5+0.5;
                // // float point=dot(_PointLightPos,i.nor)
                // float pointLight = dot(_PointLightPos.xyz,i.nor)*_PointLightPos.w;
                //
                // return nl05+pointLight;
                // return _PointLightColorAndRange;

                // float3 worldNormal=mul(unity_ObjectToWorld,i.nor);

                
                float3 viewDir=normalize(_WorldSpaceCameraPos-i.worldPos);
                float3 lightDir=normalize(i.worldPos-_PointLightPos);
                return Lighting(i.nor,lightDir,viewDir,(1,2));

                
                // 
                // float lightLength=length(lightDir);
                // float pointAtten=saturate(_PointLightPos/(lightLength*lightLength));
                // float smooth=smoothstep(0.1,1,pointAtten);
                // float PointDiffuse=saturate(dot(i.nor,normalize(lightDir)));
                // return pointAtten* smooth*_PointLightColorAndRange.xyz;//saturate(1-smooth*_PointLightColorAndRange.xyz);
                //
                
            }
            ENDCG  
        }

    }
    
    FallBack "Diffuse"
}
