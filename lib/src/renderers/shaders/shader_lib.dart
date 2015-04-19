/*
 * Webgl Shader Library for js
 *
 * @author alteredq / http://alteredqualia.com/
 * @author mrdoob / http://mrdoob.com/
 * @author mikael emtinger / http://gomo.se/
 *
 * based on a5cc2899aafab2461c52e4b63498fb284d0c167b
 */

part of three;

final Map<String, Map> ShaderLib = {
  'basic': {
    'uniforms': UniformsUtils.merge([
      UniformsLib["common"],
      UniformsLib["fog"],
      UniformsLib["shadowmap"]
    ]),
    'vertexShader': [
      ShaderChunk["common"],
      ShaderChunk["uv_pars_vertex"],
      ShaderChunk["uv2_pars_vertex"],
      ShaderChunk["envmap_pars_vertex"],
      ShaderChunk["color_pars_vertex"],
      ShaderChunk["morphtarget_pars_vertex"],
      ShaderChunk["skinning_pars_vertex"],
      ShaderChunk["shadowmap_pars_vertex"],
      ShaderChunk["logdepthbuf_pars_vertex"],
      "void main() {",
        ShaderChunk["uv_vertex"],
        ShaderChunk["uv2_vertex"],
        ShaderChunk["color_vertex"],
        ShaderChunk["skinbase_vertex"],
      " #ifdef USE_ENVMAP",
        ShaderChunk["morphnormal_vertex"],
        ShaderChunk["skinnormal_vertex"],
        ShaderChunk["defaultnormal_vertex"],
      " #endif",
        ShaderChunk["morphtarget_vertex"],
        ShaderChunk["skinning_vertex"],
        ShaderChunk["default_vertex"],
        ShaderChunk["logdepthbuf_vertex"],
        ShaderChunk["worldpos_vertex"],
        ShaderChunk["envmap_vertex"],
        ShaderChunk["shadowmap_vertex"],
      "}"
    ].join("\n"),
    'fragmentShader': [
      "uniform vec3 diffuse;",
      "uniform float opacity;",
      ShaderChunk["common"],
      ShaderChunk["color_pars_fragment"],
      ShaderChunk["uv_pars_fragment"],
      ShaderChunk["uv2_pars_fragment"],
      ShaderChunk["map_pars_fragment"],
      ShaderChunk["alphamap_pars_fragment"],
      ShaderChunk["envmap_pars_fragment"],
      ShaderChunk["fog_pars_fragment"],
      ShaderChunk["shadowmap_pars_fragment"],
      ShaderChunk["specularmap_pars_fragment"],
      ShaderChunk["logdepthbuf_pars_fragment"],
      "void main() {",
      " vec3 outgoingLight = vec3(0.0);", // outgoing light does not have an alpha, the surface does
      " vec4 diffuseColor = vec4(diffuse, opacity);",
        ShaderChunk["logdepthbuf_fragment"],
        ShaderChunk["map_fragment"],
        ShaderChunk["color_fragment"],
        ShaderChunk["alphamap_fragment"],
        ShaderChunk["alphatest_fragment"],
        ShaderChunk["specularmap_fragment"],
      " outgoingLight = diffuseColor.rgb;", // simple shader
        ShaderChunk["envmap_fragment"],
        ShaderChunk["shadowmap_fragment"],    // TODO: Shadows on an otherwise unlit surface doesn't make sense.
        ShaderChunk["linear_to_gamma_fragment"],
        ShaderChunk["fog_fragment"],
      " gl_FragColor = vec4(outgoingLight, diffuseColor.a);", // TODO, this should be pre-multiplied to allow for bright highlights on very transparent objects
      "}"
    ].join("\n")
  },
  'lambert': {
    'uniforms': UniformsUtils.merge([
      UniformsLib["common"],
      UniformsLib["fog"],
      UniformsLib["lights"],
      UniformsLib["shadowmap"], {
        "emissive": new Uniform.color(0x000000),
      }
    ]),
    'vertexShader': [
      "#define LAMBERT",
      "varying vec3 vLightFront;",
      "#ifdef DOUBLE_SIDED",
      " varying vec3 vLightBack;",
      "#endif",
      ShaderChunk["common"],
      ShaderChunk["uv_pars_vertex"],
      ShaderChunk["uv2_pars_vertex"],
      ShaderChunk["envmap_pars_vertex"],
      ShaderChunk["lights_lambert_pars_vertex"],
      ShaderChunk["color_pars_vertex"],
      ShaderChunk["morphtarget_pars_vertex"],
      ShaderChunk["skinning_pars_vertex"],
      ShaderChunk["shadowmap_pars_vertex"],
      ShaderChunk["logdepthbuf_pars_vertex"],
      "void main() {",
        ShaderChunk["uv_vertex"],
        ShaderChunk["uv2_vertex"],
        ShaderChunk["color_vertex"],
        ShaderChunk["morphnormal_vertex"],
        ShaderChunk["skinbase_vertex"],
        ShaderChunk["skinnormal_vertex"],
        ShaderChunk["defaultnormal_vertex"],
        ShaderChunk["morphtarget_vertex"],
        ShaderChunk["skinning_vertex"],
        ShaderChunk["default_vertex"],
        ShaderChunk["logdepthbuf_vertex"],
        ShaderChunk["worldpos_vertex"],
        ShaderChunk["envmap_vertex"],
        ShaderChunk["lights_lambert_vertex"],
        ShaderChunk["shadowmap_vertex"],
      "}"
    ].join("\n"),
    'fragmentShader': [
      "uniform vec3 diffuse;",
      "uniform vec3 emissive;",
      "uniform float opacity;",
      "varying vec3 vLightFront;",
      "#ifdef DOUBLE_SIDED",
      " varying vec3 vLightBack;",
      "#endif",
      ShaderChunk["common"],
      ShaderChunk["color_pars_fragment"],
      ShaderChunk["uv_pars_fragment"],
      ShaderChunk["uv2_pars_fragment"],
      ShaderChunk["map_pars_fragment"],
      ShaderChunk["alphamap_pars_fragment"],
      ShaderChunk["envmap_pars_fragment"],
      ShaderChunk["fog_pars_fragment"],
      ShaderChunk["shadowmap_pars_fragment"],
      ShaderChunk["specularmap_pars_fragment"],
      ShaderChunk["logdepthbuf_pars_fragment"],
      "void main() {",
      " vec3 outgoingLight = vec3(0.0);", // outgoing light does not have an alpha, the surface does
      " vec4 diffuseColor = vec4(diffuse, opacity);",
        ShaderChunk["logdepthbuf_fragment"],
        ShaderChunk["map_fragment"],
        ShaderChunk["color_fragment"],
        ShaderChunk["alphamap_fragment"],
        ShaderChunk["alphatest_fragment"],
        ShaderChunk["specularmap_fragment"],
      " #ifdef DOUBLE_SIDED",
          //"float isFront = float(gl_FrontFacing);",
          //"gl_FragColor.xyz *= isFront * vLightFront + (1.0 - isFront) * vLightBack;",
      "   if (gl_FrontFacing)",
      "     outgoingLight += diffuseColor.rgb * vLightFront + emissive;",
      "   else",
      "     outgoingLight += diffuseColor.rgb * vLightBack + emissive;",
      " #else",
      "   outgoingLight += diffuseColor.rgb * vLightFront + emissive;",
      " #endif",
        ShaderChunk["envmap_fragment"],
        ShaderChunk["shadowmap_fragment"],
        ShaderChunk["linear_to_gamma_fragment"],
        ShaderChunk["fog_fragment"],
      " gl_FragColor = vec4(outgoingLight, diffuseColor.a);", // TODO, this should be pre-multiplied to allow for bright highlights on very transparent objects
      "}"
    ].join("\n")
  },
  'phong': {
    'uniforms': UniformsUtils.merge([
      UniformsLib["common"],
      UniformsLib["aomap"],
      UniformsLib["lightmap"],
      UniformsLib["bump"],
      UniformsLib["normalmap"],
      UniformsLib["fog"],
      UniformsLib["lights"],
      UniformsLib["shadowmap"], {
        "emissive" : new Uniform.color(0x000000),
        "specular" : new Uniform.color(0x111111),
        "shininess": new Uniform.float(30.0),
      }
    ]),
    'vertexShader': [
      "#define PHONG",
      "varying vec3 vViewPosition;",
      "#ifndef FLAT_SHADED",
      " varying vec3 vNormal;",
      "#endif",
      ShaderChunk["common"],
      ShaderChunk["uv_pars_vertex"],
      ShaderChunk["uv2_pars_vertex"],
      ShaderChunk["envmap_pars_vertex"],
      ShaderChunk["lights_phong_pars_vertex"],
      ShaderChunk["color_pars_vertex"],
      ShaderChunk["morphtarget_pars_vertex"],
      ShaderChunk["skinning_pars_vertex"],
      ShaderChunk["shadowmap_pars_vertex"],
      ShaderChunk["logdepthbuf_pars_vertex"],
      "void main() {",
        ShaderChunk["uv_vertex"],
        ShaderChunk["uv2_vertex"],
        ShaderChunk["color_vertex"],
        ShaderChunk["morphnormal_vertex"],
        ShaderChunk["skinbase_vertex"],
        ShaderChunk["skinnormal_vertex"],
        ShaderChunk["defaultnormal_vertex"],
      "#ifndef FLAT_SHADED", // Normal computed with derivatives when FLAT_SHADED
      " vNormal = normalize(transformedNormal);",
      "#endif",
        ShaderChunk["morphtarget_vertex"],
        ShaderChunk["skinning_vertex"],
        ShaderChunk["default_vertex"],
        ShaderChunk["logdepthbuf_vertex"],
      " vViewPosition = -mvPosition.xyz;",
        ShaderChunk["worldpos_vertex"],
        ShaderChunk["envmap_vertex"],
        ShaderChunk["lights_phong_vertex"],
        ShaderChunk["shadowmap_vertex"],
      "}"
    ].join("\n"),
    'fragmentShader': [
      "#define PHONG",
      "uniform vec3 diffuse;",
      "uniform vec3 emissive;",
      "uniform vec3 specular;",
      "uniform float shininess;",
      "uniform float opacity;",
      ShaderChunk["common"],
      ShaderChunk["color_pars_fragment"],
      ShaderChunk["uv_pars_fragment"],
      ShaderChunk["uv2_pars_fragment"],
      ShaderChunk["map_pars_fragment"],
      ShaderChunk["alphamap_pars_fragment"],
      ShaderChunk["aomap_pars_fragment"],
      ShaderChunk["lightmap_pars_fragment"],
      ShaderChunk["envmap_pars_fragment"],
      ShaderChunk["fog_pars_fragment"],
      ShaderChunk["lights_phong_pars_fragment"],
      ShaderChunk["shadowmap_pars_fragment"],
      ShaderChunk["bumpmap_pars_fragment"],
      ShaderChunk["normalmap_pars_fragment"],
      ShaderChunk["specularmap_pars_fragment"],
      ShaderChunk["logdepthbuf_pars_fragment"],
      "void main() {",
      " vec3 outgoingLight = vec3(0.0);", // outgoing light does not have an alpha, the surface does
      " vec4 diffuseColor = vec4(diffuse, opacity);",
      " vec3 totalAmbientLight = ambientLightColor;",
        ShaderChunk["logdepthbuf_fragment"],
        ShaderChunk["map_fragment"],
        ShaderChunk["color_fragment"],
        ShaderChunk["alphamap_fragment"],
        ShaderChunk["alphatest_fragment"],
        ShaderChunk["specularmap_fragment"],
        ShaderChunk["lightmap_fragment"],
        ShaderChunk["aomap_fragment"],
        ShaderChunk["lights_phong_fragment"],
        ShaderChunk["envmap_fragment"],
        ShaderChunk["shadowmap_fragment"],
        ShaderChunk["linear_to_gamma_fragment"],
        ShaderChunk["fog_fragment"],
      " gl_FragColor = vec4(outgoingLight, diffuseColor.a);", // TODO, this should be pre-multiplied to allow for bright highlights on very transparent objects
      "}"
    ].join("\n")
  },

  'particle_basic': {
    'uniforms': UniformsUtils.merge([
      UniformsLib["particle"],
      UniformsLib["shadowmap"]
    ]),
    'vertexShader': [
      "uniform float size;",
      "uniform float scale;",
      ShaderChunk["common"],
      ShaderChunk["color_pars_vertex"],
      ShaderChunk["shadowmap_pars_vertex"],
      ShaderChunk["logdepthbuf_pars_vertex"],
      "void main() {",
        ShaderChunk["color_vertex"],
      " vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);",
      " #ifdef USE_SIZEATTENUATION",
      "   gl_PointSize = size * (scale / length(mvPosition.xyz));",
      " #else",
      "   gl_PointSize = size;",
      " #endif",
      " gl_Position = projectionMatrix * mvPosition;",
        ShaderChunk["logdepthbuf_vertex"],
        ShaderChunk["worldpos_vertex"],
        ShaderChunk["shadowmap_vertex"],
      "}"
    ].join("\n"),
    'fragmentShader': [
      "uniform vec3 psColor;",
      "uniform float opacity;",
      ShaderChunk["common"],
      ShaderChunk["color_pars_fragment"],
      ShaderChunk["map_particle_pars_fragment"],
      ShaderChunk["fog_pars_fragment"],
      ShaderChunk["shadowmap_pars_fragment"],
      ShaderChunk["logdepthbuf_pars_fragment"],
      "void main() {",
      " vec3 outgoingLight = vec3(0.0);", // outgoing light does not have an alpha, the surface does
      " vec4 diffuseColor = vec4(psColor, opacity);",
        ShaderChunk["logdepthbuf_fragment"],
        ShaderChunk["map_particle_fragment"],
        ShaderChunk["color_fragment"],
        ShaderChunk["alphatest_fragment"],
      " outgoingLight = diffuseColor.rgb;", // simple shader
        ShaderChunk["shadowmap_fragment"],
        ShaderChunk["fog_fragment"],
      " gl_FragColor = vec4(outgoingLight, diffuseColor.a);", // TODO, this should be pre-multiplied to allow for bright highlights on very transparent objects
      "}"
    ].join("\n")
  },
  'dashed': {
    'uniforms': UniformsUtils.merge([
      UniformsLib["common"],
      UniformsLib["fog"], {
        "scale": new Uniform.float(1.0),
        "dashSize": new Uniform.float(1.0),
        "totalSize": new Uniform.float(2.0)
      }
    ]),
    'vertexShader': [
      "uniform float scale;",
      "attribute float lineDistance;",
      "varying float vLineDistance;",
      ShaderChunk["common"],
      ShaderChunk["color_pars_vertex"],
      ShaderChunk["logdepthbuf_pars_vertex"],
      "void main() {",
        ShaderChunk["color_vertex"],
      " vLineDistance = scale * lineDistance;",
      " vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);",
      " gl_Position = projectionMatrix * mvPosition;",
        ShaderChunk["logdepthbuf_vertex"],
      "}"
    ].join("\n"),
    'fragmentShader': [
      "uniform vec3 diffuse;",
      "uniform float opacity;",
      "uniform float dashSize;",
      "uniform float totalSize;",
      "varying float vLineDistance;",
      ShaderChunk["common"],
      ShaderChunk["color_pars_fragment"],
      ShaderChunk["fog_pars_fragment"],
      ShaderChunk["logdepthbuf_pars_fragment"],
      "void main() {",
      " if (mod(vLineDistance, totalSize) > dashSize) {",
      "   discard;",
      " }",
      " vec3 outgoingLight = vec3(0.0);", // outgoing light does not have an alpha, the surface does
      " vec4 diffuseColor = vec4(diffuse, opacity);",
        ShaderChunk["logdepthbuf_fragment"],
        ShaderChunk["color_fragment"],
      " outgoingLight = diffuseColor.rgb;", // simple shader
        ShaderChunk["fog_fragment"],
      " gl_FragColor = vec4(outgoingLight, diffuseColor.a);", // TODO, this should be pre-multiplied to allow for bright highlights on very transparent objects
      "}"
    ].join("\n")
  },
  'depth': {
    'uniforms': {
      "mNear": new Uniform.float(1.0),
      "mFar": new Uniform.float(2000.0),
      "opacity": new Uniform.float(1.0)},
    'vertexShader': [
      ShaderChunk["common"],
      ShaderChunk["morphtarget_pars_vertex"],
      ShaderChunk["logdepthbuf_pars_vertex"],
      "void main() {",
        ShaderChunk["morphtarget_vertex"],
        ShaderChunk["default_vertex"],
        ShaderChunk["logdepthbuf_vertex"],
      "}"
    ].join("\n"),
    'fragmentShader': [
      "uniform float mNear;",
      "uniform float mFar;",
      "uniform float opacity;",
      ShaderChunk["common"],
      ShaderChunk["logdepthbuf_pars_fragment"],
      "void main() {",
        ShaderChunk["logdepthbuf_fragment"],
      " #ifdef USE_LOGDEPTHBUF_EXT",
      "   float depth = gl_FragDepthEXT / gl_FragCoord.w;",
      " #else",
      "   float depth = gl_FragCoord.z / gl_FragCoord.w;",
      " #endif",
      " float color = 1.0 - smoothstep(mNear, mFar, depth);",
      " gl_FragColor = vec4(vec3(color), opacity);",   // TODO, this should be pre-multiplied to allow for bright highlights on very transparent objects
      "}"
    ].join("\n")
  },
  'normal': {
    'uniforms': {
      "opacity" : {"opacity": new Uniform.float(1.0)}
    },
    'vertexShader': [
      "varying vec3 vNormal;",
      ShaderChunk["common"],
      ShaderChunk["morphtarget_pars_vertex"],
      ShaderChunk["logdepthbuf_pars_vertex"],
      "void main() {",
      " vNormal = normalize(normalMatrix * normal);",
        ShaderChunk["morphtarget_vertex"],
        ShaderChunk["default_vertex"],
        ShaderChunk["logdepthbuf_vertex"],
      "}"
    ].join("\n"),
    'fragmentShader': [
      "uniform float opacity;",
      "varying vec3 vNormal;",
      ShaderChunk["common"],
      ShaderChunk["logdepthbuf_pars_fragment"],
      "void main() {",
      " gl_FragColor = vec4(0.5 * normalize(vNormal) + 0.5, opacity);",
        ShaderChunk["logdepthbuf_fragment"],
      "}"
    ].join("\n")
  },
  /* -------------------------------------------------------------------------
  //  Cube map shader
   ------------------------------------------------------------------------- */
  'cube': {
    'uniforms': {
      "tCube": new Uniform.texture(),
      "tFlip": new Uniform.float(-1.0)
    },
    'vertexShader': [
      "varying vec3 vWorldPosition;",
      ShaderChunk["common"],
      ShaderChunk["logdepthbuf_pars_vertex"],
      "void main() {",
      " vWorldPosition = transformDirection(position, modelMatrix);",
      " gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);",
        ShaderChunk["logdepthbuf_vertex"],
      "}"
    ].join("\n"),
    'fragmentShader': [
      "uniform samplerCube tCube;",
      "uniform float tFlip;",
      "varying vec3 vWorldPosition;",
      ShaderChunk["common"],
      ShaderChunk["logdepthbuf_pars_fragment"],
      "void main() {",
      " gl_FragColor = textureCube(tCube, vec3(tFlip * vWorldPosition.x, vWorldPosition.yz));",
        ShaderChunk["logdepthbuf_fragment"],
      "}"
    ].join("\n")
  },
  /* -------------------------------------------------------------------------
  //  Cube map shader
   ------------------------------------------------------------------------- */
  'equirect': {
    'uniforms': {
      "tEquirect": new Uniform.texture(),
      "tFlip": new Uniform.float(-1.0)
    },
    'vertexShader': [
      "varying vec3 vWorldPosition;",
      ShaderChunk["common"],
      ShaderChunk["logdepthbuf_pars_vertex"],
      "void main() {",
      " vWorldPosition = transformDirection(position, modelMatrix);",
      " gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);",
        ShaderChunk["logdepthbuf_vertex"],
      "}"
    ].join("\n"),
    'fragmentShader': [
      "uniform sampler2D tEquirect;",
      "uniform float tFlip;",
      "varying vec3 vWorldPosition;",
      ShaderChunk["common"],
      ShaderChunk["logdepthbuf_pars_fragment"],
      "void main() {",
        "vec3 direction = normalize(vWorldPosition);",
        "vec2 sampleUV;",
        "sampleUV.y = saturate(tFlip * direction.y * -0.5 + 0.5);",
        "sampleUV.x = atan(direction.z, direction.x) * RECIPROCAL_PI2 + 0.5;",
        "gl_FragColor = texture2D(tEquirect, sampleUV);",
        ShaderChunk["logdepthbuf_fragment"],
      "}"
    ].join("\n")
  },
  /* Depth encoding into RGBA texture
   *
   * based on SpiderGL shadow map example
   * http://spidergl.org/example.php?id=6
   *
   * originally from
   * http://www.gamedev.net/topic/442138-packing-a-float-into-a-a8r8g8b8-texture-shader/page__whichpage__1%25EF%25BF%25BD
   *
   * see also
   * http://aras-p.info/blog/2009/07/30/encoding-floats-to-rgba-the-final/
   */
  'depthRGBA': {
    'uniforms': {},
    'vertexShader': [
      ShaderChunk["common"],
      ShaderChunk["morphtarget_pars_vertex"],
      ShaderChunk["skinning_pars_vertex"],
      ShaderChunk["logdepthbuf_pars_vertex"],
      "void main() {",
        ShaderChunk["skinbase_vertex"],
        ShaderChunk["morphtarget_vertex"],
        ShaderChunk["skinning_vertex"],
        ShaderChunk["default_vertex"],
        ShaderChunk["logdepthbuf_vertex"],
      "}"
    ].join("\n"),
    'fragmentShader': [
      ShaderChunk["common"],
      ShaderChunk["logdepthbuf_pars_fragment"],
      "vec4 pack_depth(const in float depth) {",
      " const vec4 bit_shift = vec4(256.0 * 256.0 * 256.0, 256.0 * 256.0, 256.0, 1.0);",
      " const vec4 bit_mask = vec4(0.0, 1.0 / 256.0, 1.0 / 256.0, 1.0 / 256.0);",
      " vec4 res = mod(depth * bit_shift * vec4(255), vec4(256)) / vec4(255);", // "  vec4 res = fract(depth * bit_shift);",
      " res -= res.xxyz * bit_mask;",
      " return res;",
      "}",
      "void main() {",
        ShaderChunk["logdepthbuf_fragment"],
      " #ifdef USE_LOGDEPTHBUF_EXT",
      "   gl_FragData[0] = pack_depth(gl_FragDepthEXT);",
      " #else",
      "   gl_FragData[0] = pack_depth(gl_FragCoord.z);",
      " #endif",
      "}"
    ].join("\n")
  }
};