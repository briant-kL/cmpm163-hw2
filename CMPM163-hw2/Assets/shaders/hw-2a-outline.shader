Shader "CMPM163/HW2/hw2A-simple_outline"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
		_Outline("Outline Size", Range(0.0,.3)) = .3
		_OutlineCol("Outline Color", Color) = (0,0,0,1)
		//_Bloom ("Bloom Intensity", Range(0.0, 1)) = 0.0
		
	}
		SubShader
		{

			// Outline pass and Bloom
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
				//uniform float _Bloom;
				


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
					// sample the texture
					//fixed4 col = tex2D(_MainTex, i.uv);
					//return _OutlineCol;
					//fixed4 col = _OutlineCol;
					//col *= _OutlineCol;
					//col *= _Bloom;
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
					float4 pos : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float2 uv : TEXCOORD0;

				};


				uniform sampler2D _MainTex;
				uniform float4 _Color;
				float4 _MainTex_ST;


				v2f vert(appdata v)
				{
					v2f o;
					o.pos = UnityObjectToClipPos(v.pos);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					return o;


				}

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 col = _Color * tex2D(_MainTex, i.uv);

					return col;
				}




				ENDCG
			}
		}
}
