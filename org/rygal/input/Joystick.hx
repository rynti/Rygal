// Copyright (C) 2012 Robert Böhm, Christopher Kaster
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

import org.rygal.Game;
import org.rygal.input.JoystickEvent;

import nme.display.DisplayObject;
import nme.events.EventDispatcher;

/**
 * <h2>Description</h2>
 * <p>
 *  Coming soon....
 * </p>
 * @author Christopher Kaster
 */
class Joystick extends InputDevice {
    
    public var id(default, null):Int;
    public var deviceID(default, null):Int;
    
    public var x(default, null):Float;
    public var y(default, null):Float;
    public var z(default, null):Float;

    private var _game:Game;
    private var _buttonStates:IntHash<Bool>;
    
    public function new(game:Game, deviceID:Int) {
        super();
        
        this.deviceID = deviceID;
        this._game = game;
        
        this._buttonStates = new IntHash<Bool>();
    }
    
    #if (cpp || neko)
    public function updateFromEvent(e:nme.events.JoystickEvent) {
        this.id = e.id;
        this.x = e.x;
        this.y = e.y;
        this.z = e.z;
    }
    #end
    
    public function setButtonState(e:JoystickEvent, pressed:Bool) {
        _buttonStates.set(e.id, pressed);
    }
    
    public function isButtonPressed(id:Int) {
        if(_buttonStates.exists(id)) {
            return _buttonStates.get(id);
        } else {
            return false;
        }
    }
    
}
