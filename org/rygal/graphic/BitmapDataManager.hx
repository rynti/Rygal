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

/**
 * <h2>Description</h2>
 * <p>
 *  Keeps track of bitmap datas and provides unique identifiers.
 * </p>
 * 
 * @author Robert Böhm
 */
class BitmapDataManager {
    
    public static var size(default, null):Int = 0;
    private static var nextIdentifier:Int = 0;
    private static var bitmapDatas:IntHash<BitmapData> = new IntHash<BitmapData>();
    private static var allocations:IntHash<Int> = new IntHash<Int>();
    
    /** BitmapDataManager is not instanceable! */
    private function new() { }
    
    /**
     * Allocates the given bitmap data so the identifier will be valid until you free the bitmap
     * data.
     * 
     * @return  A valid identifier for the given bitmap data.
     */
    public static function allocBitmapData(bitmapData:BitmapData):Int {
        var identifier:Int = getIdentifier(bitmapData);
        if (identifier < 0) {
            size++;
            bitmapDatas.set(nextIdentifier, bitmapData);
            allocations.set(nextIdentifier, 0);
            return nextIdentifier++;
        } else {
            allocations.set(identifier, allocations.get(identifier) + 1);
            return identifier;
        }
    }
    
    /**
     * Frees the given bitmap data if it's not used by anyone anymore.
     */
    public static function freeBitmapData(bitmapData:BitmapData):Void {
        var identifier:Int = getIdentifier(bitmapData);
        if (identifier >= 0) {
            allocations.set(identifier, allocations.get(identifier) - 1);
            if (allocations.get(identifier) <= 0) {
                size--;
                bitmapDatas.remove(identifier);
                allocations.remove(identifier);
                TilesheetManager.free(identifier);
            }
        }
    }
    
    /**
     * Returns the bitmap data for the given identifier.
     */
    public static function getBitmapData(identifier:Int):BitmapData {
        return bitmapDatas.get(identifier);
    }
    
    /**
     * Returns the identifier for the given bitmap data or -1 if it doesn't exist.
     */
    public static function getIdentifier(bitmapData:BitmapData):Int {
        // TODO: This method may not be required!
        for (i in bitmapDatas.keys()) {
            if (bitmapDatas.get(i) == bitmapData) {
                return i;
            }
        }
        return -1;
    }
    
}
