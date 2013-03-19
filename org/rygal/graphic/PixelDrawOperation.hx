package org.rygal.graphic;
import nme.display.IBitmapDrawable;
import nme.geom.ColorTransform;
import nme.geom.Matrix;
import nme.geom.Rectangle;

/**
 * ...
 * @author Robert Böhm
 */

class PixelDrawOperation implements DrawOperation {
	
	public var color:Int;
	public var x:Float;
    public var y:Float;

	public function new(color:Int, x:Float, y:Float) {
		this.color = color;
		this.x = x;
		this.y = y;
	}
	
}