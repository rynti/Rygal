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
 *  Keeps track of tilesheets.
 * </p>
 * 
 * @author Robert Böhm
 */
class TilesheetManager {
    
    private var bitmapDatas:Array<BitmapData>;
    private var tilesheets:Array<ManagedTilesheet>;
    
    public function new() {
		this.bitmapDatas = new Array<BitmapData>();
		this.tilesheets = new Array<ManagedTilesheet>();
	}
    
    public function clear():Void {
		bitmapDatas = new Array<BitmapData>();
        tilesheets = new Array<ManagedTilesheet>();
    }
    
    public function requestBitmapId(bitmapData:BitmapData):Int {
        for (i in 0...bitmapDatas.length) {
            if (bitmapDatas[i] == bitmapData) {
                return i;
            }
        }
		tilesheets.push(new ManagedTilesheet(bitmapData));
		return bitmapDatas.push(bitmapData) - 1;
    }
    
    public function getBitmapData(identifier:Int):BitmapData {
        return bitmapDatas[identifier];
    }
    
    public function getBitmapId(bitmapData:BitmapData):Int {
        // TODO: This method may not be required!
        for (i in 0...bitmapDatas.length) {
            if (bitmapDatas[i] == bitmapData) {
                return i;
            }
        }
        return -1;
    }
    
    public function requestTileId(id:Int, rectangle:Rectangle, centerPoint:Point = null):Int {
        return tilesheets[id].requestTileRect(rectangle, centerPoint);
    }
    
    public function getTilesheet(id:Int):ManagedTilesheet {
        return tilesheets[id];
    }
    
}
