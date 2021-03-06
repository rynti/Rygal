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

import nme.events.Event;

/**
 * <h2>Description</h2>
 * <p>
 *  A keyboard event. It contains information about the related key.
 * </p>
 * 
 * <h2>Example <i>(Inside a scene)</i></h2>
 * <code>
 *  public function load(game:Game):Void {<br />
 *  &nbsp;&nbsp;super.load(game);<br />
 *  &nbsp;&nbsp;this.game.keyboard.addEventListener(KeyboardEvent.CHAR_TYPED,
 *  <br />
 *  &nbsp;&nbsp;&nbsp;&nbsp;onCharTyped);<br />
 *  }<br />
 *  <br />
 *  public function onCharTyped(e:KeyboardEvent):Void {<br />
 *  &nbsp;&nbsp;trace("Character " + e.charString + " typed!");<br />
 *  }
 * </code>
 * 
 * @author Robert Böhm
 */
class KeyboardEvent extends Event {
    
    /** An event that will be called when a key is pressed. */
    public static inline var KEY_DOWN:String = "keyDown";
    
    /** An event that will be called when a key is released. */
    public static inline var KEY_UP:String = "keyUp";
    
    /** An event that will be called when a key is typed. */
    public static inline var KEY_TYPED:String = "keyTyped";
    
    /** An event that will be called when a character is typed. */
    public static inline var CHAR_TYPED:String = "charTyped";
    
    
    /** The keycode of the related key. */
    public var keyCode(default, null):Int;
    
    /** The charcode of the related key. */
    public var charCode(default, null):Int;
    
    /** The string representation of the related key. */
    public var charString(default, null):String;
    
    
    /** The related keyboard. */
    private var _keyboard:Keyboard;
    
    
    /**
     * Creates a new KeyboardEvent.
     * 
     * @param   type        The type of this event, use one of the constants of
     *                      KeyboardEvent, for instance KeyboardEvent.KEY_UP.
     * @param   keyboard    The related keyboard.
     * @param   keyCode     The keycode of the related key.
     * @param   charCode    The charcode of the related key.
     */
    public function new(type:String, keyboard:Keyboard, keyCode:Int,
            charCode:Int) {
        
        super(type);
        
        this._keyboard = keyboard;
        this.keyCode = keyCode;
        this.charCode = charCode;
        if (charCode != 0) {
            this.charString = String.fromCharCode(charCode);
        } else {
            this.charString = "";
        }
    }
    
    
    /**
     * Determines whether a key is pressed or not.
     * 
     * @param   keyCode The keycode to be checked.
     * @return  True if the key is pressed.
     */
    public function isKeyPressed(keyCode:Int):Bool {
        return _keyboard.isKeyPressed(keyCode);
    }
    
}
