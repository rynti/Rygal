package org.rygal.graphic;
import nme.display.IBitmapDrawable;
import nme.geom.ColorTransform;
import nme.geom.Matrix;
import nme.geom.Rectangle;

/**
 * ...
 * @author Robert Böhm
 */

class RectangleDrawOperation extends PixelDrawOperation {
	
	public var width:Float;
    public var height:Float;

	public function new(color:Int, x:Float, y:Float, width:Float, height:Float) {
		super(color, x, y);
		this.width = width;
		this.height = height;
	}
	
}