package org.rygal.graphic;

import nme.display.BitmapData;
import nme.display.IBitmapDrawable;
import nme.display.Tilesheet;
import nme.geom.ColorTransform;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.text.AntiAliasType;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import org.rygal.graphic.Texture;


/**
 * ...
 * @author Robert Böhm
 */
class QueueingBitmapCanvas extends BasicCanvas {
	
	private var _tilesheetManager:TilesheetManager;
    
    /** The bitmap data this canvas is based on. */
    private var _bitmapData:BitmapData;
    
    /** A pre-allocated point. */
    private var _drawPoint:Point;
    
    private var _baseQueue:DrawQueue;
    

    public function new(bitmapData:BitmapData) {
        super();
        
        this._bitmapData = bitmapData;
        this._tilesheetManager = new TilesheetManager();
        this._baseQueue = new DrawQueue(0);
        this._drawPoint = new Point();
    }
    
    
    /**
     * Creates a new queueing bitmap canvas based on the given properties.
     * 
     * @param   width       The width of the canvas.
     * @param   height      The height of the canvas.
     * @param   transparent Shall the canvas get an alpha channel?
     * @param   fillColor   The initial color of the canvas.
     * @return  The new canvas with the given properties.
     */
    public static function create(width:Int, height:Int,
            transparent:Bool = true, fillColor:Int = 0):Canvas {
        
        return new QueueingBitmapCanvas(
                new BitmapData(width, height, transparent, fillColor)
            );
    }
    
    override public function isQueueing():Bool {
        return true;
    }
    
    override public function supportsZ():Bool {
        return true;
    }
    
    override public function executeQueue():Void {
        var queue:DrawQueue = _baseQueue.findFirst();
        while (queue != null) {
            for (k in queue.drawTileCalls.keys()) {
                var bitmapData:BitmapData = _tilesheetManager.getBitmapData(k);
                var tilesheet:ManagedTilesheet = _tilesheetManager.get(k);
                var tileData:Array<Float> = queue.drawTileCalls.get(k);
                var i:Int = 0;
                while (i < tileData.length) {
                    _drawPoint.x = tileData[i];
                    _drawPoint.y = tileData[i + 1];
                    _bitmapData.copyPixels(bitmapData, tilesheet.tileRects[Std.int(tileData[i + 2])], _drawPoint, null, null, true);
                    
                    i += 3;
                }
                
                
                //tilesheet.drawTiles(_sprite.graphics, queue.drawTileCalls.get(k));
                
                
                queue.drawTileCalls.remove(k);
            }
            
            queue = queue.nextQueue;
        }
		this._tilesheetManager.clear();
    }
    
    override public function clear(color:Int = 0):Void {
        _bitmapData.fillRect(_bitmapData.rect, color);
    }
    
    override public function draw(texture:Texture, x:Float, y:Float, z:Int = 0):Void {
        if (texture == null)
            return;
        
        x += xTranslation;
        y += yTranslation;
        z += zTranslation;
		var bitmapId:Int = _tilesheetManager.requestIdentifier(texture.bitmapData);
        var tileCalls:IntHash<Array<Float>> = _baseQueue.findQueue(z).drawTileCalls;
        if (!tileCalls.exists(bitmapId))
            tileCalls.set(bitmapId, new Array<Float>());
        var tileData:Array<Float> = tileCalls.get(bitmapId);
        tileData.push(Std.int(x));
        tileData.push(Std.int(y));
        tileData.push(_tilesheetManager.requestTileId(bitmapId, texture.bitmapDataRect));
    }
    
    override public function setPixel(x:Int, y:Int, color:Int):Void {
        x += Std.int(xTranslation);
        y += Std.int(yTranslation);
        if (inBitmap(x, y)) {
            _bitmapData.setPixel32(x, y, color);
        }
    }
    
    override public function drawPart(texture:Texture, x:Float, y:Float,
            leftOffset:Float = 0, topOffset:Float = 0, rightOffset:Float = 0,
            bottomOffset:Float = 0):Void {
        
        if (texture == null)
            return;
        
        var sourceRect:Rectangle = new Rectangle(
                texture.bitmapDataRect.x + leftOffset,
                texture.bitmapDataRect.y + topOffset,
                texture.bitmapDataRect.width - rightOffset - leftOffset,
                texture.bitmapDataRect.height - bottomOffset - topOffset
            );
        
        x += xTranslation;
        y += yTranslation;
        _bitmapData.copyPixels(texture.bitmapData, sourceRect,
            new Point(x + leftOffset, y + topOffset), null, null, true);
    }
    
    override public function fillRect(color:Int, x:Float, y:Float, width:Float,
            height:Float):Void {
        
        x += xTranslation;
        y += yTranslation;
        _bitmapData.fillRect(new Rectangle(x, y, width, height), color);
    }
    
    override public function toTexture():Texture {
        return new Texture(_bitmapData);
    }
    
    override public function drawNmeDrawable(source:IBitmapDrawable, ?matrix:Matrix,
            ?colorTransform:ColorTransform, ?clipRect:Rectangle):Void {
        
        if (matrix == null) {
            _bitmapData.draw(source, new Matrix(1, 0, 0, 1, xTranslation,
                yTranslation), colorTransform, null, clipRect);
            
        } else {
            var m:Matrix = matrix.clone();
            m.translate(xTranslation, yTranslation);
            _bitmapData.draw(source, m, colorTransform, null, clipRect);
        }
    }
    
    override private function getWidth():Int {
        return _bitmapData.width;
    }
    
    override private function getHeight():Int {
        return _bitmapData.height;
    }
    
    override private function drawStringByBitmapFont(font:BitmapFont, text:String,
            color:Int, x:Float, y:Float, alignment:Int, alpha:Float):Void {
        
        var m:Matrix;
        var ct:ColorTransform;
        var txt:Texture;
        
        #if flash
        var charBitmap:BitmapData = new BitmapData(
                font.charWidth, font.charHeight, true,
                (Std.int(alpha * 255) << 24) | color
            );
        
        #else
        var alphaMultiplier:Float = alpha;
        var redMultiplier:Float = ((color >> 16) & 0xFF) / 255;
        var greenMultiplier:Float = ((color >> 8) & 0xFF) / 255;
        var blueMultiplier:Float = (color & 0xFF) / 255;
        #end
        
        var startX:Float = x;
        
        if (alignment == Font.CENTER) {
            startX -= text.length * font.charWidth / 2;
        } else if (alignment == Font.RIGHT) {
            startX -= text.length * font.charWidth;
        }
        
        var cX:Float = startX;
        
        for (i in 0...text.length) {
            if (text.charAt(i) == " ") {
                cX += font.charWidth;
            } else {
                txt = font.getCharacterTexture(text.charAt(i));
                #if flash
                _bitmapData.copyPixels(charBitmap, charBitmap.rect,
                    new Point(cX, y), txt.bitmapData,
                    txt.bitmapDataRect.topLeft, true);
                #else
                // Need to check if this character even is inside this canvas:
                // (Will crash if the clipping rectangle is outside the canvas)
                var clipRect:Rectangle = new Rectangle(cX, y,
                    txt.bitmapDataRect.width, txt.bitmapDataRect.height);
                clipRect = clipRect.intersection(this._bitmapData.rect);
                
                if (clipRect.width > 0 && clipRect.height > 0) {
                    _bitmapData.draw(txt.bitmapData, new Matrix(1, 0, 0, 1,
                        cX - txt.bitmapDataRect.left, y - txt.bitmapDataRect.top),
                        new ColorTransform(redMultiplier, greenMultiplier,
                            blueMultiplier, alphaMultiplier),
                        null, clipRect);
                }
                #end
                
                cX += font.charWidth;
            }
        }
    }
    
    override private function drawStringByEmbeddedFont(font:EmbeddedFont, text:String,
            color:Int, x:Float, y:Float, alignment:Int, alpha:Float):Void {
        
        color = color | (Std.int(alpha * 255) << 24);
        
        #if cpp
        font.textFormat.color = color;
        #end
        
        var field:TextField = new TextField();
        field.antiAliasType = AntiAliasType.NORMAL;
        field.defaultTextFormat = font.textFormat;
        field.textColor = color;
        field.embedFonts = true;
        //field.width = _bitmapData.width;
        field.height = _bitmapData.height;
        
        #if js
        field.x = x;
        field.y = y;
        #end
        field.text = text;
        field.setTextFormat(field.defaultTextFormat);
        
        field.autoSize = TextFieldAutoSize.LEFT;
        
        if (alignment == Font.CENTER) {
            x -= Std.int(field.width / 2);
        } else if (alignment == Font.RIGHT) {
            x -= field.width;
        }
        
        #if !js
        _bitmapData.draw(field, new Matrix(1, 0, 0, 1, x, y));
        #else
        _bitmapData.draw(field);
        #end
    }
    
}
