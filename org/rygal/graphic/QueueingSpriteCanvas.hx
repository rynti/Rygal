package org.rygal.graphic;

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.DisplayObject;
import nme.display.IBitmapDrawable;
import nme.display.SpreadMethod;
import nme.display.Tilesheet;
import nme.geom.ColorTransform;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.text.AntiAliasType;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;


/**
 * ...
 * @author Robert Böhm
 */
class QueueingSpriteCanvas extends BasicCanvas {
    
    public var sprite:nme.display.Sprite;
	
	private var _tilesheetManager:TilesheetManager;
    
    private var _baseQueue:DrawQueue;
    
    /** A pre-allocated point. */
    private var _drawPoint:Point;
    

    public function new(sprite:nme.display.Sprite) {
        super();
        
        this._tilesheetManager = new TilesheetManager();
        this._baseQueue = new DrawQueue(0);
        this.sprite = sprite;
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
        while (sprite.numChildren > 0) {
            sprite.removeChildAt(0);
        }
        sprite.graphics.clear();
		var nop:NMEDrawOperation;
		var rop:RectangleDrawOperation;
		var pop:PixelDrawOperation;
        var s:nme.display.Sprite;
        var displayObject:DisplayObject;
        var bData:BitmapData;
        var queue:DrawQueue = _baseQueue.findFirst();
        while (queue != null) {
            s = new nme.display.Sprite();
            for (k in queue.drawTileCalls.keys()) {
                var bitmapData:BitmapData = _tilesheetManager.getBitmapData(k);
                var tilesheet:ManagedTilesheet = _tilesheetManager.getTilesheet(k);
				
                tilesheet.drawTiles(s.graphics, queue.drawTileCalls.get(k));
                
                queue.drawTileCalls.remove(k);
            }
			for (op in queue.drawOperations) {
				if (Std.is(op, RectangleDrawOperation)) {
					rop = cast op;
                    sprite.graphics.beginFill(rop.color);
                    sprite.graphics.drawRect(rop.x, rop.y, rop.width, rop.height);
                    sprite.graphics.endFill();
				} else if (Std.is(op, NMEDrawOperation)) {
                    sprite.addChild(s);
                    s = new nme.display.Sprite();
                    
					nop = cast op;
                    sprite.addChild(nop.object);
					//_bitmapData.draw(nop.source, nop.matrix, nop.colorTransform, null, nop.clipRect);
				} else if (Std.is(op, PixelDrawOperation)) {
					pop = cast op;
					if (inBitmap(pop.x, pop.y)) {
                        sprite.graphics.beginFill(pop.color);
                        sprite.graphics.drawRect(pop.x, pop.y, 1, 1);
                        sprite.graphics.endFill();
					}
				}
			}
            sprite.addChild(s);
			
			queue.drawOperations.clear();
            queue = queue.nextQueue;
        }
		this._tilesheetManager.clear();
    }
    
    override public function clear(color:Int = 0):Void {
        // TODO: _bitmapData.fillRect(_bitmapData.rect, color);
    }
    
    override public function draw(texture:Texture, x:Float, y:Float, z:Int = 0):Void {
        if (texture == null)
            return;
        
        x += xTranslation;
        y += yTranslation;
        z += zTranslation;
		var bitmapId:Int = _tilesheetManager.requestBitmapId(texture.bitmapData);
        var tileCalls:IntHash<Array<Float>> = _baseQueue.findQueue(z).drawTileCalls;
        if (!tileCalls.exists(bitmapId))
            tileCalls.set(bitmapId, new Array<Float>());
        var tileData:Array<Float> = tileCalls.get(bitmapId);
        tileData.push(Std.int(x));
        tileData.push(Std.int(y));
        tileData.push(_tilesheetManager.requestTileId(bitmapId, texture.bitmapDataRect));
    }
    
    override public function setPixel(x:Int, y:Int, color:Int, z:Int = 0):Void {
        x += Std.int(xTranslation);
        y += Std.int(yTranslation);
		z += zTranslation;
		_baseQueue.findQueue(z).drawOperations.add(new PixelDrawOperation(color, x, y));
    }
    
    override public function drawPart(texture:Texture, x:Float, y:Float,
            leftOffset:Float = 0, topOffset:Float = 0, rightOffset:Float = 0,
            bottomOffset:Float = 0, z:Int = 0):Void {
        
        if (texture == null)
            return;
        
        var sourceRect:Rectangle = new Rectangle(
                texture.bitmapDataRect.x + leftOffset,
                texture.bitmapDataRect.y + topOffset,
                texture.bitmapDataRect.width - rightOffset - leftOffset,
                texture.bitmapDataRect.height - bottomOffset - topOffset
            );
        
        x += xTranslation + leftOffset;
        y += yTranslation + topOffset;
		z += zTranslation;
		var bitmapId:Int = _tilesheetManager.requestBitmapId(texture.bitmapData);
        var tileCalls:IntHash<Array<Float>> = _baseQueue.findQueue(z).drawTileCalls;
        if (!tileCalls.exists(bitmapId))
            tileCalls.set(bitmapId, new Array<Float>());
        var tileData:Array<Float> = tileCalls.get(bitmapId);
        tileData.push(Std.int(x));
        tileData.push(Std.int(y));
        tileData.push(_tilesheetManager.requestTileId(bitmapId, sourceRect));
    }
    
    override public function fillRect(color:Int, x:Float, y:Float, width:Float,
            height:Float, z:Int = 0):Void {
        
        x += xTranslation;
        y += yTranslation;
		z += zTranslation;
		_baseQueue.findQueue(z).drawOperations.add(new RectangleDrawOperation(color, x, y, width, height));
    }
    
    /*override public function toTexture():Texture {
        return new Texture(_bitmapData);
    }*/
    
    override public function drawDisplayObject(object:DisplayObject, ?clipRect:Rectangle, z:Int = 0):Void {
        
		/*if (matrix == null) {
			matrix = new Matrix(1, 0, 0, 1, xTranslation, yTranslation);
		} else {
			matrix = matrix.clone();
			matrix.translate(xTranslation, yTranslation);
		}*/
        var s:nme.display.Sprite = new nme.display.Sprite();
        var mask:nme.display.Sprite = new nme.display.Sprite();
        mask.graphics.beginFill(0xFFFFFF);
        mask.graphics.drawRect(clipRect.x, clipRect.y, clipRect.width, clipRect.height);
        mask.graphics.endFill();
        s.mask = mask;
        s.addChild(object);
        s.x = xTranslation;
        s.y = yTranslation;
		_baseQueue.findQueue(z + zTranslation).drawOperations.add(new NMEDrawOperation(s, clipRect));
    }
    /*
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
    */
}