Shader "Custom/�߹�"
{
    Properties
    {
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
                float3 worldNor:TEXCOORD7;
                float3 worldPos:TEXCOORD6;
            };
            
            v2f vert(appdata v)
            {
                v2f r;
                r.vertex=UnityObjectToClipPos(v.posOS);//mul(unity_ObjectToWorld,v.posOS);
                r.worldNor=normalize(UnityObjectToWorldNormal(v.normal));
                r.worldPos=mul(unity_ObjectToWorld,v.posOS);
                
                return r;
            }
            float _S;
            float _E;
            float _B;
            
            fixed4 frag(v2f i) : SV_Target
            {
                float3 L=normalize(UnityWorldSpaceLightDir(i.worldPos));
                float3 V= normalize( UnityWorldSpaceViewDir(i.worldPos));
                float3 H=normalize(L+V);
                float NH=saturate(dot(i.worldNor,H));
                return  pow(NH,_E)*_S;
            }
            ENDCG  
        }

    }
    
    FallBack "Diffuse"
}
