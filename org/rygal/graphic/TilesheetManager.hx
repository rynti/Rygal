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
    
    private static var tilesheets:IntHash<ManagedTilesheet> = new IntHash<ManagedTilesheet>();
    
    /** TilesheetManager is not instanceable! */
    private function new() { }
    
    public static function requestTileId(id:Int, rectangle:Rectangle, centerPoint:Point = null):Int {
        if (!tilesheets.exists(id)) {
            tilesheets.set(id, new ManagedTilesheet(BitmapDataManager.getBitmapData(id)));
        }
        var tilesheet:ManagedTilesheet = tilesheets.get(id);
        return tilesheet.requestTileRect(rectangle, centerPoint);
    }
    
    public static function get(id:Int):ManagedTilesheet {
        return tilesheets.get(id);
    }
    
    public static function free(id:Int):Void {
        if (tilesheets.exists(id))
            tilesheets.remove(id);
    }
    
}
