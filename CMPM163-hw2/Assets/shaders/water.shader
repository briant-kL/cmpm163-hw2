Shader "Custom/water"
{
    Properties
    {
		_Cube("Cubemap", CUBE) = "" {}


		_Transparency("Transparent", Range(0,1)) = 1
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0

    }

	 SubShader
    {
			Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" "LightMode" = "ForwardBase"}

		
		Cull Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha



        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normalInWorldCoords : NORMAL;
                float3 vertexInWorldCoords : TEXCOORD1;
				float3 normalDir: TEXCOORD2;
				float2 dispUV : TEXCOORD3;
				float2 rampUV : TEXCOORD4;
            };

            v2f vert (appdata v)
            {
                v2f o;
				v.vertex.y += sin(_Time.y * 1 + v.vertex.y * 5) * .5;
				v.vertex.y += sin(_Time.x * .8 + v.vertex.y * 2) * .2;
                o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex); //Vertex position in WORLD coords
                o.normalInWorldCoords = UnityObjectToWorldNormal(v.normal); //Normal 
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                return o;
            }
            
            samplerCUBE _Cube;
			uniform float _Transparency;
            


            fixed4 frag (v2f i) : SV_Target
            {
            
             float3 P = i.vertexInWorldCoords.xyz;
             
             //get normalized incident ray (from camera to vertex)
             float3 vIncident = normalize(P - _WorldSpaceCameraPos);
             
             //reflect that ray around the normal using built-in HLSL command
             float3 vReflect = reflect( vIncident, i.normalInWorldCoords );
             
             
             //use the reflect ray to sample the skybox
             float4 reflectColor = texCUBE( _Cube, vReflect );
             
             //refract the incident ray through the surface using built-in HLSL command
             float3 vRefract = refract( vIncident, i.normalInWorldCoords, 0.5 );
             
             //float4 refractColor = texCUBE( _Cube, vRefract );
             
             
             float3 vRefractRed = refract( vIncident, i.normalInWorldCoords, 0.1 );
             float3 vRefractGreen = refract( vIncident, i.normalInWorldCoords, 0.4 );
             float3 vRefractBlue = refract( vIncident, i.normalInWorldCoords, 0.7 );
             
             float4 refractColorRed = texCUBE( _Cube, float3( vRefractRed ) );
             float4 refractColorGreen = texCUBE( _Cube, float3( vRefractGreen ) );
             float4 refractColorBlue = texCUBE( _Cube, float3( vRefractBlue ) );
             float4 refractColor = float4(refractColorRed.r, refractColorGreen.g, refractColorBlue.b, 1.0);
             
             
             return float4(lerp(reflectColor, refractColor, 0.5).rgb, 1*_Transparency);
                
                
            }
      
            ENDCG
        }










    }



}
