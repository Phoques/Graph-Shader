Shader "Healthbar"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}

		_healthBarColorFull("HealthBar Full", Color) = (0,1,0,1)
		_healthBarColorEmpty("HealthBar Empty", Color) = (1,0,0,1)
		_healthBarColorBackground("HealthBar Background", Color) = (0.1,0.1,0.1,1)

		_health("Health", Range(0,1)) = 1
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				struct appdata //mesh data
				{
					float4 vertex : POSITION; // Vertex position
					float2 uv : TEXCOORD0; // uv0 coordinates
					float2 uv1 : TEXCOORD1; // uv1 coordinates, usually lighting
					float3 normal : NORMAL; // Which way each verticie faces
					float3 tangent : TANGENT; // Tangent direction is  parallel to the normals.
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
					float3 normal : TEXCOORD1;
				};

				//Variables

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float4 _healthBarColorFull;
				float4 _healthBarColorEmpty;
				float4 _healthBarColorBackground;
				float _health;


				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);

					//This is being added for shaking the healthbar
					o.vertex.y += (1 - _health) * cos(_Time.y * 10) * 0.05 * (_health < 0.2);
					//end shake

					o.uv = v.uv;
					o.normal = (mul((float3x3) unity_ObjectToWorld, v.normal)); //Matrix Multiplication.
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					//Black and white health bar

					// the comparison, be it > or < or = it turns into an if statement to equal true or false, 0 or 1;
					//So this says if health, is greater than i.uv.x then it is true, 1 (Which is white) else, its black 0.
					//If the condition is met, its true;
					//return _health > i.uv.x;


					//Green and red healthbar

					/*float t = _health > i.uv.x;
					float4 outColor = lerp(_healthBarColorEmpty, _healthBarColorFull, t);
					return outColor;*/


					//Changes color of actual bar from green to red.

					/*bool t = _health > i.uv.x;
					float4 healthBarColor = lerp(_healthBarColorEmpty, _healthBarColorFull, _health);
					float4 outColor = lerp(_healthBarColorBackground, healthBarColor, t);
					return outColor;*/


					//Change the Healthbar into chunks.

				//Changes colour based off the _health variable
					/*float4 healthBarColor = lerp(_healthBarColorEmpty, _healthBarColorFull, _health);*/
				//Healthbar Steps
					//Unsure on floor function, but the * 8 / 8 creates '8 steps' or health segments / chunks that the healthbar will go down by.
					/*float healthBarSteps = _health > floor(i.uv.x * 8) / 8;
					float4 outColor = lerp(_healthBarColorBackground, healthBarColor, healthBarSteps);
					return outColor;*/


					//Output for the shaking healthbar
					float4 healthBarColor = lerp(_healthBarColorEmpty, _healthBarColorFull, _health);
					bool t = _health > i.uv.x;
					float4 outColor = lerp(_healthBarColorBackground, healthBarColor, t);
					return outColor;


				}

				ENDCG
			}
		}
}
