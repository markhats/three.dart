part of three;
/**
 * @author alteredq / http://alteredqualia.com/
 */

class Gyroscope extends Object3D {
  Vector3 translationWorld, translationObject;
  Quaternion rotationWorld, rotationObject;
  Vector3 scaleWorld, scaleObject;

  Gyroscope()
      : translationWorld = new Vector3.zero(),
        translationObject = new Vector3.zero(),
        rotationWorld = new Quaternion.identity(),
        rotationObject = new Quaternion.identity(),
        scaleWorld = new Vector3.zero(),
        scaleObject = new Vector3.zero(),
        super();

  updateMatrixWorld({bool force: false}) {

    if (matrixAutoUpdate) {
      updateMatrix();
    }

    // update matrixWorld

    if (matrixWorldNeedsUpdate || force) {

      if (parent != null) {

        matrixWorld = parent.matrixWorld * matrix;

        matrixWorld.decompose(translationWorld, rotationWorld, scaleWorld);
        matrix.decompose(translationObject, rotationObject, scaleObject);

        matrixWorld.compose(translationWorld, rotationObject, scaleWorld);


      } else {

        matrixWorld.setFrom(matrix);

      }


      matrixWorldNeedsUpdate = false;

      force = true;

    }

    // update children
    var l = this.children.length;
    for (var i = 0; i < l; i++) {

      children[i].updateMatrixWorld(force);

    }

  }
}


