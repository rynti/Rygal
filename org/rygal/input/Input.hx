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


package org.rygal.input;

import nme.events.EventDispatcher;
import org.rygal.Game;
import org.rygal.util.Storage;

/**
 * ...
 * @author Robert Böhm
 */
class Input extends EventDispatcher {
	
	public var name(default, null):String;
	
	public var game(default, null):Game;
	
	public var storage(default, null):Storage;
	
	
	public function new(game:Game, name:String) {
		this.game = game;
		this.name = name;
	}
	
	
	public function connect(storage:Storage):Void {
		this.storage = storage;
	}
	
}