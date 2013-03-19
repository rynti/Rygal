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
import haxe.FastList;

/**
 * ...
 * @author Robert Böhm
 */
class DrawQueue {
    
    public var z(default, null):Int;
    public var previousQueue:DrawQueue;
    public var nextQueue:DrawQueue;
    
    public var drawTileCalls:IntHash<Array<Float>>;
	public var drawOperations:List<DrawOperation>;

    public function new(z:Int, ?previousQueue:DrawQueue, ?nextQueue:DrawQueue) {
        this.drawTileCalls = new IntHash<Array<Float>>();
		this.drawOperations = new List<DrawOperation>();
        this.z = z;
        if (previousQueue != null) {
            this.previousQueue = previousQueue;
            this.previousQueue.nextQueue = this;
        }
        if (nextQueue != null) {
            this.nextQueue = nextQueue;
            this.nextQueue.previousQueue = this;
        }
    }
    
    public function findQueue(z:Int):DrawQueue {
        if (z < this.z) {
            if (previousQueue == null) {
                // No previousQueue (Append new queue)
                return new DrawQueue(z, null, this);
            } else if (previousQueue.z < z) {
                // previousQueue too far (Insert new queue)
                return new DrawQueue(z, previousQueue, this);
            } else if (previousQueue.z > z) {
                // previousQueue too close (Let previous queue continue search)
                return previousQueue.findQueue(z);
            } else {
                // previousQueue correct
                return previousQueue;
            }
        } else if (z > this.z) {
            if (nextQueue == null) {
                // No nextQueue (Append new queue)
                return new DrawQueue(z, this);
            } else if (nextQueue.z > z) {
                // nextQueue too far (Insert new queue)
                return new DrawQueue(z, this, nextQueue);
            } else if (nextQueue.z < z) {
                // nextQueue too close (Let next queue continue search)
                return nextQueue.findQueue(z);
            } else {
                // nextQueue correct
                return nextQueue;
            }
        } else {
            // This is the correct one
            return this;
        }
    }
    
    public function findFirst():DrawQueue {
        var q:DrawQueue = this;
        while (q.previousQueue != null)
            q = q.previousQueue;
        
        return q;
    }
    
    public function findLast():DrawQueue {
        var q:DrawQueue = this;
        while (q.nextQueue != null)
            q = q.nextQueue;
        
        return q;
    }
    
}
