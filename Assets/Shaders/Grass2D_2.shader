Shader "Grass2D_2"
{
    Properties
    {
        [NoScaleOffset] _MainTex("GrassTexture_Color", 2D) = "white" {}
        Vector2_2211399a42df404b9cfe4c56657d033e("Offset", Vector) = (0, -0.5, 0, 0)
        Vector1_40a2391c975c404bb840605ce670c987("Shift", Float) = 1
        Vector1_d91ff4f7011c43fbb20a1e2564af3e09("speed", Float) = 1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
        SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue" = "Transparent"
        }
        Pass
        {
            Name "Sprite Lit"
            Tags
            {
                "LightMode" = "Universal2D"
            }

        // Render State
        Cull Off
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite Off

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma exclude_renderers d3d11_9x
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        #pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_0
    #pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_1
    #pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_2
    #pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_3
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define VARYINGS_NEED_SCREENPOSITION
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SPRITELIT
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/LightingUtility.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 color : COLOR;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float4 texCoord0;
        float4 color;
        float4 screenPosition;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
        float3 TimeParameters;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float4 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        float4 interp2 : TEXCOORD2;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyzw = input.texCoord0;
        output.interp1.xyzw = input.color;
        output.interp2.xyzw = input.screenPosition;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.texCoord0 = input.interp0.xyzw;
        output.color = input.interp1.xyzw;
        output.screenPosition = input.interp2.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 _MainTex_TexelSize;
float2 Vector2_2211399a42df404b9cfe4c56657d033e;
float Vector1_40a2391c975c404bb840605ce670c987;
float Vector1_d91ff4f7011c43fbb20a1e2564af3e09;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_MainTex);
SAMPLER(sampler_MainTex);

// Graph Functions

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Sine_float(float In, out float Out)
{
    Out = sin(In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Distance_float2(float2 A, float2 B, out float Out)
{
    Out = distance(A, B);
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    float _Property_602aa5f7c719411aae315b3c2fd34423_Out_0 = Vector1_d91ff4f7011c43fbb20a1e2564af3e09;
    float _Multiply_bf692e8b417445daa99267857def3c53_Out_2;
    Unity_Multiply_float(IN.TimeParameters.x, _Property_602aa5f7c719411aae315b3c2fd34423_Out_0, _Multiply_bf692e8b417445daa99267857def3c53_Out_2);
    float _Sine_98a4732161b14e159b5add850bfd3ad1_Out_1;
    Unity_Sine_float(_Multiply_bf692e8b417445daa99267857def3c53_Out_2, _Sine_98a4732161b14e159b5add850bfd3ad1_Out_1);
    float _Subtract_fb0eba9a5fc5415cb649d848cd0f7a3f_Out_2;
    Unity_Subtract_float(_Sine_98a4732161b14e159b5add850bfd3ad1_Out_1, 0.5, _Subtract_fb0eba9a5fc5415cb649d848cd0f7a3f_Out_2);
    float _Property_7ac0404d1b734ff4b8cc130f4a0ef675_Out_0 = Vector1_40a2391c975c404bb840605ce670c987;
    float _Multiply_30284f82d88f451486c0a3ffa3adcd84_Out_2;
    Unity_Multiply_float(_Subtract_fb0eba9a5fc5415cb649d848cd0f7a3f_Out_2, _Property_7ac0404d1b734ff4b8cc130f4a0ef675_Out_0, _Multiply_30284f82d88f451486c0a3ffa3adcd84_Out_2);
    float _Float_91479cbb2f59408eaa372a704c306031_Out_0 = _Multiply_30284f82d88f451486c0a3ffa3adcd84_Out_2;
    float2 _Vector2_4ba8676a5b8f4c25b7984df6a4556d0d_Out_0 = float2(_Float_91479cbb2f59408eaa372a704c306031_Out_0, 0);
    float2 _Property_daafeb7df4014a9399b783260626f74e_Out_0 = Vector2_2211399a42df404b9cfe4c56657d033e;
    float2 _Add_009b990bb2d34b50b93c494e94d04bf3_Out_2;
    Unity_Add_float2(_Property_daafeb7df4014a9399b783260626f74e_Out_0, (IN.ObjectSpacePosition.xy), _Add_009b990bb2d34b50b93c494e94d04bf3_Out_2);
    float _Distance_aa4b515fce6e4d26a4ed0793d00af8d7_Out_2;
    Unity_Distance_float2(_Add_009b990bb2d34b50b93c494e94d04bf3_Out_2, float2(0, 0), _Distance_aa4b515fce6e4d26a4ed0793d00af8d7_Out_2);
    float2 _Multiply_12df37a12c3740c18148e697592c63a6_Out_2;
    Unity_Multiply_float(_Vector2_4ba8676a5b8f4c25b7984df6a4556d0d_Out_0, (_Distance_aa4b515fce6e4d26a4ed0793d00af8d7_Out_2.xx), _Multiply_12df37a12c3740c18148e697592c63a6_Out_2);
    float2 _Add_e504870f02f444e4921ef8b3852eca2e_Out_2;
    Unity_Add_float2(_Multiply_12df37a12c3740c18148e697592c63a6_Out_2, (IN.ObjectSpacePosition.xy), _Add_e504870f02f444e4921ef8b3852eca2e_Out_2);
    description.Position = (float3(_Add_e504870f02f444e4921ef8b3852eca2e_Out_2, 0.0));
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float Alpha;
    float4 SpriteMask;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_705fe6e710f9412dafdf3549952d5119_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
    float4 _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_RGBA_0 = SAMPLE_TEXTURE2D(_Property_705fe6e710f9412dafdf3549952d5119_Out_0.tex, _Property_705fe6e710f9412dafdf3549952d5119_Out_0.samplerstate, IN.uv0.xy);
    float _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_R_4 = _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_RGBA_0.r;
    float _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_G_5 = _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_RGBA_0.g;
    float _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_B_6 = _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_RGBA_0.b;
    float _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_A_7 = _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_RGBA_0.a;
    surface.BaseColor = (_SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_RGBA_0.xyz);
    surface.Alpha = _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_A_7;
    surface.SpriteMask = IsGammaSpace() ? float4(1, 1, 1, 1) : float4 (SRGBToLinear(float3(1, 1, 1)), 1);
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;
    output.TimeParameters = _TimeParameters.xyz;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.uv0 = input.texCoord0;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SpriteLitPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "Sprite Normal"
    Tags
    {
        "LightMode" = "NormalsRendering"
    }

        // Render State
        Cull Off
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite Off

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma exclude_renderers d3d11_9x
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SPRITENORMAL
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/NormalsRenderingShared.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 normalWS;
        float4 tangentWS;
        float4 texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 TangentSpaceNormal;
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
        float3 TimeParameters;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        float4 interp2 : TEXCOORD2;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.normalWS;
        output.interp1.xyzw = input.tangentWS;
        output.interp2.xyzw = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.normalWS = input.interp0.xyz;
        output.tangentWS = input.interp1.xyzw;
        output.texCoord0 = input.interp2.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 _MainTex_TexelSize;
float2 Vector2_2211399a42df404b9cfe4c56657d033e;
float Vector1_40a2391c975c404bb840605ce670c987;
float Vector1_d91ff4f7011c43fbb20a1e2564af3e09;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_MainTex);
SAMPLER(sampler_MainTex);

// Graph Functions

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Sine_float(float In, out float Out)
{
    Out = sin(In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Distance_float2(float2 A, float2 B, out float Out)
{
    Out = distance(A, B);
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    float _Property_602aa5f7c719411aae315b3c2fd34423_Out_0 = Vector1_d91ff4f7011c43fbb20a1e2564af3e09;
    float _Multiply_bf692e8b417445daa99267857def3c53_Out_2;
    Unity_Multiply_float(IN.TimeParameters.x, _Property_602aa5f7c719411aae315b3c2fd34423_Out_0, _Multiply_bf692e8b417445daa99267857def3c53_Out_2);
    float _Sine_98a4732161b14e159b5add850bfd3ad1_Out_1;
    Unity_Sine_float(_Multiply_bf692e8b417445daa99267857def3c53_Out_2, _Sine_98a4732161b14e159b5add850bfd3ad1_Out_1);
    float _Subtract_fb0eba9a5fc5415cb649d848cd0f7a3f_Out_2;
    Unity_Subtract_float(_Sine_98a4732161b14e159b5add850bfd3ad1_Out_1, 0.5, _Subtract_fb0eba9a5fc5415cb649d848cd0f7a3f_Out_2);
    float _Property_7ac0404d1b734ff4b8cc130f4a0ef675_Out_0 = Vector1_40a2391c975c404bb840605ce670c987;
    float _Multiply_30284f82d88f451486c0a3ffa3adcd84_Out_2;
    Unity_Multiply_float(_Subtract_fb0eba9a5fc5415cb649d848cd0f7a3f_Out_2, _Property_7ac0404d1b734ff4b8cc130f4a0ef675_Out_0, _Multiply_30284f82d88f451486c0a3ffa3adcd84_Out_2);
    float _Float_91479cbb2f59408eaa372a704c306031_Out_0 = _Multiply_30284f82d88f451486c0a3ffa3adcd84_Out_2;
    float2 _Vector2_4ba8676a5b8f4c25b7984df6a4556d0d_Out_0 = float2(_Float_91479cbb2f59408eaa372a704c306031_Out_0, 0);
    float2 _Property_daafeb7df4014a9399b783260626f74e_Out_0 = Vector2_2211399a42df404b9cfe4c56657d033e;
    float2 _Add_009b990bb2d34b50b93c494e94d04bf3_Out_2;
    Unity_Add_float2(_Property_daafeb7df4014a9399b783260626f74e_Out_0, (IN.ObjectSpacePosition.xy), _Add_009b990bb2d34b50b93c494e94d04bf3_Out_2);
    float _Distance_aa4b515fce6e4d26a4ed0793d00af8d7_Out_2;
    Unity_Distance_float2(_Add_009b990bb2d34b50b93c494e94d04bf3_Out_2, float2(0, 0), _Distance_aa4b515fce6e4d26a4ed0793d00af8d7_Out_2);
    float2 _Multiply_12df37a12c3740c18148e697592c63a6_Out_2;
    Unity_Multiply_float(_Vector2_4ba8676a5b8f4c25b7984df6a4556d0d_Out_0, (_Distance_aa4b515fce6e4d26a4ed0793d00af8d7_Out_2.xx), _Multiply_12df37a12c3740c18148e697592c63a6_Out_2);
    float2 _Add_e504870f02f444e4921ef8b3852eca2e_Out_2;
    Unity_Add_float2(_Multiply_12df37a12c3740c18148e697592c63a6_Out_2, (IN.ObjectSpacePosition.xy), _Add_e504870f02f444e4921ef8b3852eca2e_Out_2);
    description.Position = (float3(_Add_e504870f02f444e4921ef8b3852eca2e_Out_2, 0.0));
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float Alpha;
    float3 NormalTS;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_705fe6e710f9412dafdf3549952d5119_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
    float4 _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_RGBA_0 = SAMPLE_TEXTURE2D(_Property_705fe6e710f9412dafdf3549952d5119_Out_0.tex, _Property_705fe6e710f9412dafdf3549952d5119_Out_0.samplerstate, IN.uv0.xy);
    float _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_R_4 = _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_RGBA_0.r;
    float _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_G_5 = _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_RGBA_0.g;
    float _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_B_6 = _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_RGBA_0.b;
    float _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_A_7 = _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_RGBA_0.a;
    surface.BaseColor = (_SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_RGBA_0.xyz);
    surface.Alpha = _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_A_7;
    surface.NormalTS = IN.TangentSpaceNormal;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;
    output.TimeParameters = _TimeParameters.xyz;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


    output.uv0 = input.texCoord0;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SpriteNormalPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "Sprite Forward"
    Tags
    {
        "LightMode" = "UniversalForward"
    }

        // Render State
        Cull Off
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite Off

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma exclude_renderers d3d11_9x
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SPRITEFORWARD
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 color : COLOR;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float4 texCoord0;
        float4 color;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 TangentSpaceNormal;
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
        float3 TimeParameters;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float4 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyzw = input.texCoord0;
        output.interp1.xyzw = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.texCoord0 = input.interp0.xyzw;
        output.color = input.interp1.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 _MainTex_TexelSize;
float2 Vector2_2211399a42df404b9cfe4c56657d033e;
float Vector1_40a2391c975c404bb840605ce670c987;
float Vector1_d91ff4f7011c43fbb20a1e2564af3e09;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_MainTex);
SAMPLER(sampler_MainTex);

// Graph Functions

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Sine_float(float In, out float Out)
{
    Out = sin(In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Distance_float2(float2 A, float2 B, out float Out)
{
    Out = distance(A, B);
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    float _Property_602aa5f7c719411aae315b3c2fd34423_Out_0 = Vector1_d91ff4f7011c43fbb20a1e2564af3e09;
    float _Multiply_bf692e8b417445daa99267857def3c53_Out_2;
    Unity_Multiply_float(IN.TimeParameters.x, _Property_602aa5f7c719411aae315b3c2fd34423_Out_0, _Multiply_bf692e8b417445daa99267857def3c53_Out_2);
    float _Sine_98a4732161b14e159b5add850bfd3ad1_Out_1;
    Unity_Sine_float(_Multiply_bf692e8b417445daa99267857def3c53_Out_2, _Sine_98a4732161b14e159b5add850bfd3ad1_Out_1);
    float _Subtract_fb0eba9a5fc5415cb649d848cd0f7a3f_Out_2;
    Unity_Subtract_float(_Sine_98a4732161b14e159b5add850bfd3ad1_Out_1, 0.5, _Subtract_fb0eba9a5fc5415cb649d848cd0f7a3f_Out_2);
    float _Property_7ac0404d1b734ff4b8cc130f4a0ef675_Out_0 = Vector1_40a2391c975c404bb840605ce670c987;
    float _Multiply_30284f82d88f451486c0a3ffa3adcd84_Out_2;
    Unity_Multiply_float(_Subtract_fb0eba9a5fc5415cb649d848cd0f7a3f_Out_2, _Property_7ac0404d1b734ff4b8cc130f4a0ef675_Out_0, _Multiply_30284f82d88f451486c0a3ffa3adcd84_Out_2);
    float _Float_91479cbb2f59408eaa372a704c306031_Out_0 = _Multiply_30284f82d88f451486c0a3ffa3adcd84_Out_2;
    float2 _Vector2_4ba8676a5b8f4c25b7984df6a4556d0d_Out_0 = float2(_Float_91479cbb2f59408eaa372a704c306031_Out_0, 0);
    float2 _Property_daafeb7df4014a9399b783260626f74e_Out_0 = Vector2_2211399a42df404b9cfe4c56657d033e;
    float2 _Add_009b990bb2d34b50b93c494e94d04bf3_Out_2;
    Unity_Add_float2(_Property_daafeb7df4014a9399b783260626f74e_Out_0, (IN.ObjectSpacePosition.xy), _Add_009b990bb2d34b50b93c494e94d04bf3_Out_2);
    float _Distance_aa4b515fce6e4d26a4ed0793d00af8d7_Out_2;
    Unity_Distance_float2(_Add_009b990bb2d34b50b93c494e94d04bf3_Out_2, float2(0, 0), _Distance_aa4b515fce6e4d26a4ed0793d00af8d7_Out_2);
    float2 _Multiply_12df37a12c3740c18148e697592c63a6_Out_2;
    Unity_Multiply_float(_Vector2_4ba8676a5b8f4c25b7984df6a4556d0d_Out_0, (_Distance_aa4b515fce6e4d26a4ed0793d00af8d7_Out_2.xx), _Multiply_12df37a12c3740c18148e697592c63a6_Out_2);
    float2 _Add_e504870f02f444e4921ef8b3852eca2e_Out_2;
    Unity_Add_float2(_Multiply_12df37a12c3740c18148e697592c63a6_Out_2, (IN.ObjectSpacePosition.xy), _Add_e504870f02f444e4921ef8b3852eca2e_Out_2);
    description.Position = (float3(_Add_e504870f02f444e4921ef8b3852eca2e_Out_2, 0.0));
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float Alpha;
    float3 NormalTS;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_705fe6e710f9412dafdf3549952d5119_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
    float4 _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_RGBA_0 = SAMPLE_TEXTURE2D(_Property_705fe6e710f9412dafdf3549952d5119_Out_0.tex, _Property_705fe6e710f9412dafdf3549952d5119_Out_0.samplerstate, IN.uv0.xy);
    float _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_R_4 = _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_RGBA_0.r;
    float _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_G_5 = _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_RGBA_0.g;
    float _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_B_6 = _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_RGBA_0.b;
    float _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_A_7 = _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_RGBA_0.a;
    surface.BaseColor = (_SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_RGBA_0.xyz);
    surface.Alpha = _SampleTexture2D_4b842c9887124fa391ac2e861fe9779d_A_7;
    surface.NormalTS = IN.TangentSpaceNormal;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;
    output.TimeParameters = _TimeParameters.xyz;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


    output.uv0 = input.texCoord0;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SpriteForwardPass.hlsl"

    ENDHLSL
}
    }
        FallBack "Hidden/Shader Graph/FallbackError"
}