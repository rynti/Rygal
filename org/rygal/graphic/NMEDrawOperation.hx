package org.rygal.graphic;
import nme.display.DisplayObject;
import nme.display.IBitmapDrawable;
import nme.geom.ColorTransform;
import nme.geom.Matrix;
import nme.geom.Rectangle;

/**
 * ...
 * @author Robert Böhm
 */

class NMEDrawOperation implements DrawOperation {
	
	public var object:DisplayObject;
	public var clipRect:Rectangle;

	public function new(object:DisplayObject, ?clipRect:Rectangle) {
		this.object = object;
		this.clipRect = clipRect;
	}
	
}
