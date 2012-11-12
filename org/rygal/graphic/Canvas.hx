// Copyright (C) 2012 Robert Böhm
// 
// This file is part of Rygal.
// 
// Rygal is free software: you can redistribute it and/or modify it under the
// terms of the GNU Lesser General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option)
// any later version.
// 
// Rygal is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
// more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with Rygal. If not, see: <http://www.gnu.org/licenses/>.


package org.rygal.graphic;

import nme.display.IBitmapDrawable;
import nme.geom.ColorTransform;
import nme.geom.Matrix;
import nme.geom.Rectangle;

/**
 * <h2>Description</h2>
 * <p>
 *  A canvas that can be used for drawing operations. It's also capable of being
 *  converted to a texture, which can then be drawn on other canvas-objects.
 * </p>
 * <p>
 *  It's a very core element of Rygal, since it's used for every drawing
 *  operation. It also supports translations and has a translation stack, thus
 *  it can be used for nested drawings.
 * </p>
 * 
 * <h2>Example</h2>
 * <code>
 *  // Prerequisite: The variable texture contains a Texture-object.<br />
 *  var canvas:Canvas = BitmapCanvas.create(320, 240, false);<br />
 *  canvas.fillRect(0xFF0000, 20, 20, 280, 200);<br />
 *  canvas.draw(texture, 20, 20);<br />
 *  canvas.executeQueue();
 * </code>
 * 
 * @author Robert Böhm
 */
interface Canvas {
    
    public var width(getWidth, never):Int;
    
    public var height(getHeight, never):Int;
    
    public var xTranslation:Float;
    
    public var yTranslation:Float;
    
    public var zTranslation:Int;
    
    //public var sprite:nme.display.Sprite;
    //private var _baseQueue:DrawQueue;
    
    public function supportsZ():Bool;
    
    public function isQueueing():Bool;
    
    public function push():Void;
    
    public function pop():Void;
    
    public function reset():Void;
    
    public function translate(x:Float, y:Float, z:Int = 0):Void;
    
    public function toTexture():Texture;
    
    public function executeQueue():Void;
    
    public function clear(color:Int = 0):Void;
    
    public function setPixel(x:Int, y:Int, color:Int):Void;
    
    public function draw(texture:Texture, x:Float, y:Float, z:Int = 0):Void;
    
    public function drawPart(texture:Texture, x:Float, y:Float,
            leftOffset:Float = 0, topOffset:Float = 0, rightOffset:Float = 0,
            bottomOffset:Float = 0):Void;
    
    public function fillRect(color:Int, x:Float, y:Float, width:Float,
            height:Float):Void;
    
    public function drawString(font:Font, text:String, color:Int, x:Float,
            y:Float, alignment:Int = 0, alpha:Float = 1):Void;
    
    public function drawNmeDrawable(source:IBitmapDrawable, ?matrix:Matrix,
            ?colorTransform:ColorTransform, ?clipRect:Rectangle):Void;
    
    private function getWidth():Int;
    
    private function getHeight():Int;
    
}
