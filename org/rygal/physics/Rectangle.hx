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


package org.rygal.physics;

/**
 * <h2>Description</h2>
 * <p>
 *  A non-rotated rectangle.
 * </p>
 * 
 * @author Robert Böhm
 */
class Rectangle implements Primitive {
    
    /** The x-coordinate of this rectangle. */
    public var x(default, null):Float;
    
    /** The y-coordinate of this rectangle. */
    public var y(default, null):Float;
    
    /** The width of this rectangle. */
    public var width(default, null):Float;
    
    /** The height of this rectangle. */
    public var height(default, null):Float;
    
    /** The nme.geom.Rectangle this rectangle is based on. */
    public var rect(default, null):nme.geom.Rectangle;
    
    
    /**
     * Creates a new rectangle.
     * 
     * @param   x       The x-coordinate of this rectangle.
     * @param   y       The x-coordinate of this rectangle.
     * @param   width   The width of this rectangle.
     * @param   height  The height of this rectangle.
     */
    public function new(x:Float, y:Float, width:Float, height:Float) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.rect = new nme.geom.Rectangle(x, y, width, height);
    }
    
    
    /**
     * Returns this rectangle.
     * 
     * @return  An identical object.
     */
    public function getPrimitive():Primitive {
        return this;
    }
    
    /**
     * Checks whether this rectangle contains the given point.
     * 
     * @param   x   The x-coordinate.
     * @param   y   The y-coordinate.
     * @return  True if this rectangle contains the given point.
     */
    public function contains(x:Float, y:Float):Bool {
        return this.rect.contains(x, y);
    }
    
    /**
     * Checks whether this rectangle collides with another physical object.
     * 
     * @param   obj The other object.
     * @return  True if this rectangle collides with the other object.
     */
    public function collides(obj:PhysicalObject):Bool {
        if (Std.is(obj, Rectangle)) {
            // Rectangle
            return this.rect.intersects(cast(obj, Rectangle).rect);
            
        } else if (Std.is(obj, Primitive)) {
            // User-implemented primitives
            return obj.collides(this);
            
        } else {
            // Non-primitives
            return this.collides(obj.getPrimitive());
        }
    }
    
}
