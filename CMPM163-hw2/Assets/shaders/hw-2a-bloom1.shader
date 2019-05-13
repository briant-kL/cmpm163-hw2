Shader "CMPM163/HW2/hw2A-bloom1"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_BaseTex("texture", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
		_Steps("Steps", Float) = 5

	}


		SubShader
		{
			Blend SrcAlpha OneMinusSrcAlpha
			///GLOW pass

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
					float3 normal : NORMAL;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
				};

				uniform sampler2D _MainTex;
				uniform float _Steps;
				float4 _MainTex_ST;
				float4 _MainTex_TexelSize;

				v2f vert(appdata v) {
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;
					return o;

				}

				fixed4 frag(v2f i) : SV_Target
				{
					
					float3 col = tex2D(_MainTex, i.uv).rgb;
					float brightness = dot(col, float3(0.212, 0.715, 0.0722));

					if (brightness > 1.0)
						return float4(col, 1.0);
					else
						return float4(0, 0, 0, 1);
					
				
				}
				ENDCG
			}






			//Blur pass
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
					float3 normal : NORMAL;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
				};

				uniform sampler2D _MainTex;
				uniform float _Steps;
				float4 _MainTex_ST;
				float4 _MainTex_TexelSize;

				v2f vert(appdata v) {
					v2f o; 
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;
					return o;

				}


				half4 frag(v2f i) : SV_TARGET
				{
					float2 texel = float2(_MainTex_TexelSize.x, _MainTex_TexelSize.y);

					float3 avg = 0.0;
	
					if (tex2D(_MainTex, i.uv.xy).r > 0)
					{
						discard;
					}


					int steps = ((int)_Steps) * 2 + 1;
					if (steps < 0) {
						avg = tex2D(_MainTex, i.uv).rgb;
					}
					else
					{


						int x, y;

						for (x = -steps / 2; x <= steps / 2; x++) {
							for (int y = -steps / 2; y <= steps / 2; y++) {
								avg += tex2D(_MainTex, i.uv + texel * float2(x, y)).rgb;
							}
						}

					avg /= steps * steps;
					}

					return half4(avg, 1.0);
				}
				ENDCG
			}



			//Combine
			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"


				sampler2D _MainTex;
				sampler2D _BaseTex;

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

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;
					return o;
				}



				fixed4 frag(v2f i) : SV_Target
				{
					float4 baseCol = tex2D(_BaseTex, i.uv);
					float4 mainTexCol = tex2D(_MainTex, i.uv);
					return baseCol + mainTexCol;

				}
				ENDCG
			}


		}
}
