Shader "CMPM163/HW2/hw2A-simple_outline"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
		_Outline("Outline Size", Range(0.0,.3)) = .3
		_OutlineCol("Outline Color", Color) = (0,0,0,1)
	}
		SubShader
		{

			// Outline pass
			Pass
			{
				Cull Front
				ZWrite On
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
					float3 normal : NORMAL;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
				};

				uniform sampler2D _MainTex;
				uniform float _Outline;
				uniform float4 _OutlineCol;
				float4 _MainTex_ST;


				v2f vert(appdata v)
				{
					
					v2f o;
					//v.vertex = v.vertex * _Outline;
					float3 objNormals = normalize(v.normal);
					v.vertex += float4(objNormals, 0) * _Outline;


					o.vertex = UnityObjectToClipPos(v.vertex);
					o.vertex = o.vertex;
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{

					return _OutlineCol;
				}



				ENDCG
			}


			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float4 _Color;
				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);

					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{

					return _Color;
				}
				ENDCG
			}

		

			
		}
}
