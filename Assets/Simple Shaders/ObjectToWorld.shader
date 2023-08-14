Shader "Object to World"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
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

            //Float is just numbers, so a float 3 is xyz, a float 4 is xyzw and are most accurate but performance heavy
            //Half is half a float in terms of accuracy and performance.
            //Fixed is -2 to 2
            //int

            //bool


            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv; // TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal); // This locks the normal direction to the world space.
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                //uv is X and Y, U = X, V = Y. So if we were to directly output the UV, you'd do it like:
                //return float4(i.uv,0,1); This returns U and V as X & Y, 0 for Z, and 1 for W.
                //fixed4 col = tex2D(_MainTex, i.uv); // Samples the texture at the specific UV coord.
                return float4(i.normal,1);
            }

            ENDCG
        }
    }
}