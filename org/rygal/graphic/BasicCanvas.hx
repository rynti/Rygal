package org.rygal.graphic;
import nme.display.IBitmapDrawable;
import nme.geom.ColorTransform;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;

/**
 * ...
 * @author Robert Böhm
 */

class BasicCanvas implements Canvas {
    
    public var width(getWidth, never):Int;
    
    public var height(getHeight, never):Int;
    
    public var xTranslation:Float;
    
    public var yTranslation:Float;
    
    public var zTranslation:Int;
    
    /** The translation stack for x-coordinates. */
    private var _xTranslations:Array<Float>;
    
    /** The translation stack for y-coordinates. */
    private var _yTranslations:Array<Float>;
    
    /** The translation stack for z-coordinates. */
    private var _zTranslations:Array<Int>;

    
    /**
     * Initialized default canvas data.
     */
    private function new() {
        this.xTranslation = 0;
        this.yTranslation = 0;
        this.zTranslation = 0;
        this._xTranslations = new Array<Float>();
        this._yTranslations = new Array<Float>();
        this._zTranslations = new Array<Int>();
        
        //this._baseQueue = new DrawQueue(0);
        //this.sprite = new nme.display.Sprite();
    }
    
    
    public function isQueueing():Bool {
        return false;
    }
    
    public function supportsZ():Bool {
        return false;
    }
    
    /**
     * Pushes the current translation onto the stack.
     */
    public function push():Void {
        this._xTranslations.push(xTranslation);
        this._yTranslations.push(yTranslation);
        this._zTranslations.push(zTranslation);
    }
    
    /**
     * Pops the translation from the stack.
     */
    public function pop():Void {
        this.xTranslation = this._xTranslations.pop();
        this.yTranslation = this._yTranslations.pop();
        this.zTranslation = this._zTranslations.pop();
    }
    
    /**
     * Resets the translation and the translation stack.
     */
    public function reset():Void {
        this.xTranslation = 0;
        this.yTranslation = 0;
        this.zTranslation = 0;
        while (this._xTranslations.length > 0) {
            this._xTranslations.pop();
            this._yTranslations.pop();
            this._zTranslations.pop();
        }
    }
    
    /**
     * Perform a translation for the following drawing operations.
     * 
     * @param   x   The x-translation.
     * @param   y   The y-translation.
     * @param   z   The z-translation.
     */
    public function translate(x:Float, y:Float, z:Int = 0):Void {
        xTranslation += x;
        yTranslation += y;
        zTranslation += z;
    }
    
    public function executeQueue():Void { }
    
    /**
     * Clears the whole canvas with the given color.
     * Note: This is in many cases unnecessary and could be skipped, only
     * perform this operation if it's really needed! If it's called at the
     * beginning of each frame it may slow down your program even though you may
     * draw other stuff over it.
     * 
     * @param   color   The color this canvas should be filled with.
     */
    public function clear(color:Int = 0):Void { }
    
    /**
     * Defines the color of the given pixel.
     * 
     * @param   x       The x-coordinate of the pixel.
     * @param   y       The y-coordinate of the pixel.
     * @param   color   The color of the pixel.
     */
    public function setPixel(x:Int, y:Int, color:Int):Void { }
    
    /**
     * Draws the given texture onto this canvas.
     * 
     * @param   texture The texture to be drawn.
     * @param   x       The x-coordinate where to draw to.
     * @param   y       The y-coordinate where to draw to.
     * @param   y       The z-index where to draw to.
     */
    public function draw(texture:Texture, x:Float, y:Float, z:Int = 0):Void { }
    
    /**
     * Draws a specific part of the given texture onto this canvas.
     * 
     * @param   texture         The texture to be drawn.
     * @param   x               The x-coordinate where to draw to.
     * @param   y               The y-coordinate where to draw to.
     * @param   leftOffset      The offset from the left side of the texture.
     * @param   topOffset       The offset from the upper side of the texture.
     * @param   rightOffset     The offset from the right side of the texture.
     * @param   bottomOffset    The offset from the bottom side of the texture.
     */
    public function drawPart(texture:Texture, x:Float, y:Float,
            leftOffset:Float = 0, topOffset:Float = 0, rightOffset:Float = 0,
            bottomOffset:Float = 0):Void { }
    
    /**
     * Draw a filled rectangle onto this canvas with the given properties.
     * 
     * @param   color   The color of the rectangle.
     * @param   x       The x-coordinate where to draw to.
     * @param   y       The y-coordinate where to draw to.
     * @param   width   The width of the rectangle.
     * @param   height  The height of the rectangle.
     */
    public function fillRect(color:Int, x:Float, y:Float, width:Float,
            height:Float):Void { }
    
    /**
     * Returns a texture that uses the same bitmap data, thus when you change
     * this canvas the contents of the texture will also change. If you want to
     * avoid that, you can clone the resulting texture.
     * 
     * @return  A texture that is based on the same bitmap data as this canvas.
     */
    public function toTexture():Texture {
        return null;
    }
    
    /**
     * Draws the given string onto this canvas with the given font and
     * properties.
     * Note: This may be slow on various platforms when used repeatedly, use
     * a Label whenever possible!
     * 
     * @param   font        The font to be used.
     * @param   text        The text to be drawn.
     * @param   color       The color of the text.
     * @param   x           The x-coordinate where to draw to.
     * @param   y           The y-coordinate where to draw to.
     * @param   alignment   The alignment, use the constants defined in the
     *                      Font-class.
     * @param   alpha       The visibility of this text.
     *                      (0 = Invisible, 1 = Visible)
     */
    public function drawString(font:Font, text:String, color:Int, x:Float,
            y:Float, alignment:Int = 0, alpha:Float = 1):Void {
        
        x += xTranslation;
        y += yTranslation;
        
        if (Std.is(font, EmbeddedFont)) {
            drawStringByEmbeddedFont(cast(font, EmbeddedFont), text, color, x,
                y, alignment, alpha);
            
        } else if (Std.is(font, BitmapFont)) {
            var lines:Array<String> = text.split("\n");
            var bitmapFont:BitmapFont = cast(font, BitmapFont);
            for (i in 0...lines.length) {
                drawStringByBitmapFont(bitmapFont, lines[i], color, x,
                    y + i * bitmapFont.charHeight, alignment, alpha);
            }
        }
    }
    
    /**
     * Draws an NME IBitmapDrawable on this canvas. You shouldn't use this
     * unless you really have to!
     * 
     * @param   source          The drawable object to draw on this canvas.
     * @param   ?matrix         A matrix for object transformations.
     * @param   ?colorTransform A color transformation.
     * @param   ?clipRect       A clipping rectangle.
     */
    public function drawNmeDrawable(source:IBitmapDrawable, ?matrix:Matrix,
            ?colorTransform:ColorTransform, ?clipRect:Rectangle):Void { }
    
    
    /**
     * Returns the width of this canvas.
     * 
     * @return  The width of this canvas.
     */
    private function getWidth():Int {
        return 0;
    }
    
    /**
     * Returns the height of this canvas.
     * 
     * @return  The height of this canvas.
     */
    private function getHeight():Int {
        return 0;
    }
    
    /**
     * Determines if the given (absolute) coordinates are inside this bitmap.
     * 
     * @param   x   The x-coordinate.
     * @param   y   The y-coordinate.
     * @return  True if the given coordinates are in this bitmap.
     */
    private function inBitmap(x:Float, y:Float):Bool {
        return x >= 0 && y >= 0 && x < width && y < height;
    }
    
    /**
     * Draws the given string onto this canvas with the given bitmap font and
     * properties.
     * 
     * @param   font        The bitmap font to be used.
     * @param   text        The text to be drawn.
     * @param   color       The color of the text.
     * @param   x           The x-coordinate where to draw to.
     * @param   y           The y-coordinate where to draw to.
     * @param   alignment   The alignment, use the constants defined in the
     *                      Font-class.
     */
    private function drawStringByBitmapFont(font:BitmapFont, text:String,
            color:Int, x:Float, y:Float, alignment:Int, alpha:Float):Void { }
    
    /**
     * Draws the given string onto this canvas with the given embedded font and
     * properties.
     * 
     * @param   font        The embedded font to be used.
     * @param   text        The text to be drawn.
     * @param   color       The color of the text.
     * @param   x           The x-coordinate where to draw to.
     * @param   y           The y-coordinate where to draw to.
     * @param   alignment   The alignment, use the constants defined in the
     *                      Font-class.
     */
    private function drawStringByEmbeddedFont(font:EmbeddedFont, text:String,
            color:Int, x:Float, y:Float, alignment:Int, alpha:Float):Void { }
    
}
