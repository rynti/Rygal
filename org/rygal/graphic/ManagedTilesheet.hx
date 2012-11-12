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

import nme.display.BitmapData;
import nme.display.Tilesheet;
import nme.geom.Point;
import nme.geom.Rectangle;

/**
 * <h2>Description</h2>
 * <p>
 *  Adds functionality to Tilesheets.
 * </p>
 * 
 * @author Robert Böhm
 */
class ManagedTilesheet extends Tilesheet {
    
    public var tileRects:Array<Rectangle>;
    public var centerPoints:Array<Point>;
    public var bitmapData(default, null):BitmapData;
    
    public function new(bitmapData:BitmapData) {
        super(bitmapData);
        
        this.bitmapData = bitmapData;
        this.tileRects = new Array<Rectangle>();
        this.centerPoints = new Array<Point>();
    }
    
    public function requestTileRect(rectangle:Rectangle, centerPoint:Point = null):Int {
        for (i in 0...tileRects.length) {
            if (tileRects[i].equals(rectangle) &&
                    (centerPoints[i] == null && centerPoint == null) ||
                    (centerPoints[i] != null && centerPoint != null &&
                        centerPoints[i].equals(centerPoint))) {
                
                return i;
            }
        }
        addTileRect(rectangle, centerPoint);
        return tileRects.length - 1;
    }
    
    override public function addTileRect(rectangle:Rectangle, centerPoint:Point = null):Void {
        super.addTileRect(rectangle, centerPoint);
        tileRects.push(rectangle);
        centerPoints.push(centerPoint);
    }
    
}
