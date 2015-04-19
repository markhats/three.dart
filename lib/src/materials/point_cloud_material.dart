/*
 * @author mr.doob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 *
 * based on  a5cc2899aafab2461c52e4b63498fb284d0c167b
 */

part of three;

class PointCloudMaterial extends Material implements Mapping {
  String type = 'PointCloudMaterial';

  Texture map;
  double size;
  bool sizeAttenuation;

  // Not used
  var aoMap, normalScale, normalMap, bumpMap, bumpScale, refractionRatio, combine,
  reflectivity, lightMap, alphaMap, specularMap, envMap;

  PointCloudMaterial({num color: 0xffffff, this.map, this.size: 1.0, this.sizeAttenuation: true,
    int vertexColors: NoColors, bool fog: true,
    // Material
    String name: '', int side: FrontSide, double opacity: 1.0, bool transparent: false,
    int blending: NormalBlending, blendSrc: SrcAlphaFactor, blendDst: OneMinusSrcAlphaFactor,
    int blendEquation: AddEquation, blendSrcAlpha, blendDstAlpha, blendEquationAlpha, int depthFunc: LessEqualDepth,
    bool depthTest: true, bool depthWrite: true, bool colorWrite: true, bool polygonOffset: false,
    int polygonOffsetFactor: 0, int polygonOffsetUnits: 0, double alphaTest: 0.0, double overdraw: 0.0,
    bool visible: true})
      : super._(name: name, side: side, opacity: opacity, transparent: transparent, blending: blending,
          blendSrc: blendSrc, blendDst: blendDst, blendEquation: blendEquation, blendSrcAlpha: blendSrcAlpha,
          blendDstAlpha: blendDstAlpha, blendEquationAlpha: blendEquationAlpha, depthFunc: depthFunc,
          depthTest: depthTest, depthWrite: depthWrite, colorWrite: colorWrite, polygonOffset: polygonOffset,
          polygonOffsetFactor: polygonOffsetFactor, polygonOffsetUnits: polygonOffsetUnits, alphaTest: alphaTest,
          overdraw: overdraw, visible: visible,

          color: color, fog: fog, vertexColors: vertexColors);

  clone() {
    throw new UnimplementedError();
  }

  toJSON() {
    throw new UnimplementedError();
  }
}





