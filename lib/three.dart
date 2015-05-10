/*
 * @author mrdoob / http://mrdoob.com/
 *
 * based on r72-dev
 */


library three;

import 'dart:async';
import 'dart:collection';
import 'dart:html' hide Path;
import 'dart:typed_data';
import 'dart:web_gl' as gl;
import 'dart:math' as math;

import 'src/math.dart';
export 'src/math.dart';

import 'src/constants.dart';
export 'src/constants.dart';

import 'extras/helpers.dart' show CameraHelper;

import 'extras/font_utils.dart' as font_utils;

import 'extras/core/curve_utils.dart' as curve_utils;
import 'extras/core/shape_utils.dart' as shape_utils;

import 'extras/uniforms_utils.dart' as uniforms_utils;

part 'src/cameras/camera.dart';
part 'src/cameras/cube_camera.dart';
part 'src/cameras/perspective_camera.dart';
part 'src/cameras/orthographic_camera.dart';

part 'src/core/buffer_attribute.dart';
part 'src/core/buffer_geometry.dart';
part 'src/core/clock.dart';
part 'src/core/object3d.dart';
part 'src/core/dynamic_buffer_attribute.dart';
part 'src/core/dynamic_geometry.dart';
part 'src/core/face3.dart';
part 'src/core/geometry.dart';
part 'src/core/instanced_buffer_attribute.dart';
part 'src/core/instanced_buffer_geometry.dart';
part 'src/core/instanced_interleaved_buffer.dart';
part 'src/core/interleaved_buffer.dart';
part 'src/core/interleaved_buffer_attribute.dart';
part 'src/core/projector.dart';
part 'src/core/raycaster.dart';
part 'src/core/rectangle.dart';

part 'extras/geometries/circle_geometry.dart';
part 'extras/geometries/circle_buffer_geometry.dart';
part 'extras/geometries/convex_geometry.dart';
part 'extras/geometries/box_geometry.dart';
part 'extras/geometries/cylinder_geometry.dart';
part 'extras/geometries/extrude_geometry.dart';
part 'extras/geometries/hilbert_geometry.dart';
part 'extras/geometries/icosahedron_geometry.dart';
part 'extras/geometries/lathe_geometry.dart';
part 'extras/geometries/octahedron_geometry.dart';
part 'extras/geometries/parametric_geometry.dart';
part 'extras/geometries/plane_geometry.dart';
part 'extras/geometries/plane_buffer_geometry.dart';
part 'extras/geometries/polyhedron_geometry.dart';
part 'extras/geometries/shape_geometry.dart';
part 'extras/geometries/sphere_geometry.dart';
part 'extras/geometries/sphere_buffer_geometry.dart';
part 'extras/geometries/tetrahedron_geometry.dart';
part 'extras/geometries/text_geometry.dart';
part 'extras/geometries/torus_geometry.dart';
part 'extras/geometries/torus_knot_geometry.dart';
part 'extras/geometries/tube_geometry.dart';
part 'extras/geometries/ring_geometry.dart';
part 'extras/geometries/wireframe_geometry.dart';
part 'extras/geometries/edges_geometry.dart';

part 'extras/core/curve.dart';
part 'extras/core/curve_path.dart';
part 'extras/core/path.dart';
part 'extras/core/shape.dart';
part 'extras/core/line_curve.dart';
part 'extras/core/quadratic_bezier_curve.dart';
part 'extras/core/cubic_bezier_curve.dart';
part 'extras/core/spline_curve.dart';
part 'extras/core/arc_curve.dart';
part 'extras/core/ellipse_curve.dart';

part 'extras/core/line_curve3.dart';
part 'extras/core/quadratic_bezier_curve3.dart';
part 'extras/core/cubic_bezier_curve3.dart';
part 'extras/core/spline_curve3.dart';
part 'extras/core/closed_spline_curve3.dart';

part 'extras/core/gyroscope.dart';

part 'extras/objects/lens_flare.dart';
part 'extras/objects/immediate_render_object.dart';

part 'src/lights/ambient_light.dart';
part 'src/lights/area_light.dart';
part 'src/lights/directional_light.dart';
part 'src/lights/point_light.dart';
part 'src/lights/spot_light.dart';
part 'src/lights/hemisphere_light.dart';
part 'src/lights/light.dart';

part 'src/materials/material.dart';
part 'src/materials/mesh_basic_material.dart';
part 'src/materials/mesh_face_material.dart';
part 'src/materials/point_cloud_material.dart';
part 'src/materials/particle_canvas_material.dart';
part 'src/materials/line_basic_material.dart';
part 'src/materials/line_dashed_material.dart';
part 'src/materials/mesh_lambert_material.dart';
part 'src/materials/mesh_depth_material.dart';
part 'src/materials/mesh_normal_material.dart';
part 'src/materials/mesh_phong_material.dart';
part 'src/materials/shader_material.dart';
part 'src/materials/raw_shader_material.dart';
part 'src/materials/sprite_material.dart';

part 'src/objects/bone.dart';
part 'src/objects/group.dart';
part 'src/objects/mesh.dart';
part 'src/objects/line.dart';
part 'src/objects/line_segments.dart';
part 'src/objects/particle.dart';
part 'src/objects/point_cloud.dart';
part 'src/objects/sprite.dart';
part 'src/objects/skinned_mesh.dart';
part 'src/objects/lod.dart';
part 'src/objects/morph_anim_mesh.dart';

part 'src/renderers/shaders/attribute.dart';
part 'src/renderers/shaders/shader_chunk.dart';
part 'src/renderers/shaders/shader_lib.dart';
part 'src/renderers/shaders/uniform.dart';
part 'src/renderers/shaders/uniforms_lib.dart';

part 'src/renderers/webgl/webgl_extensions.dart';
part 'src/renderers/webgl/webgl_geometries.dart';
part 'src/renderers/webgl/webgl_objects.dart';
part 'src/renderers/webgl/webgl_program.dart';
part 'src/renderers/webgl/webgl_shader.dart';
part 'src/renderers/webgl/webgl_shadow_map.dart';
part 'src/renderers/webgl/webgl_state.dart';
part 'src/renderers/webgl/webgl_textures.dart';

part 'src/renderers/webgl_renderer.dart';
part 'src/renderers/webgl_render_target.dart';
part 'src/renderers/webgl_render_target_cube.dart';

part 'src/scenes/scene.dart';
part 'src/scenes/fog.dart';
part 'src/scenes/fog_linear.dart';
part 'src/scenes/fog_exp2.dart';

part 'src/textures/texture.dart';
part 'src/textures/cube_texture.dart';
part 'src/textures/data_texture.dart';
part 'src/textures/compressed_texture.dart';

// from _geometry
int GeometryIdCount = 0;

// from Object3D
int Object3DIdCount = 0;

// from _material
int MaterialIdCount = 0;

// from Texture
int TextureIdCount = 0;

warn(String msg) => window.console.warn(msg);
log(String msg) => window.console.log(msg);
error(String msg) => window.console.error(msg);
