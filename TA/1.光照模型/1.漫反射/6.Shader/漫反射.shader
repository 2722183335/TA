Shader "LK/漫反射"
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
                r.vertex=UnityObjectToClipPos(v.posOS);//mul(unity_ObjectToWorld,v.posOS);
                r.nor=v.normal;
                r.worldPos=mul(unity_ObjectToWorld,v.posOS);
                return r;
            }

            float _Wrap;

            float _StripNum;
            
            float _S;
            float _E;
            float _B;
            
            fixed4 frag(v2f i) : SV_Target
            {
                //1.兰伯特模型
                //float nl=dot(i.nor,_WorldSpaceLightPos0);
                //return  fixed4(nl,nl,nl,1);

                //2.半兰伯特模型
                // float nl=dot(i.nor,_WorldSpaceLightPos0);
                // float half_nl=nl*0.5+0.5;
                // return  half_nl;

                //3.WrapLight
                // float nl=dot(i.nor,_WorldSpaceLightPos0);
                // float wrapLight=(nl*_Wrap)/(1+_Wrap);
                // return  wrapLight;

                //4.bandedLight
                // float nl=dot(i.nor,_WorldSpaceLightPos0);
                // float bandedLight=floor((nl*0.5+0.5)*_StripNum)/_StripNum;
                // return  bandedLight;

                //5.CheapSSS 错误
                float3 viewDir = normalize(_WorldSpaceCameraPos-i.worldPos);
                float nbl=(i.nor*_B +_WorldSpaceLightPos0);
                // float vnbl=dot(viewDir,nbl);
              
                return    saturate(pow(saturate(dot(nbl,viewDir)),_E)*_S);
            }
            ENDCG  
        }

    }
    
    FallBack "Diffuse"
}
