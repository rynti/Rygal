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


package org.rygal.util;

#if !js
import nme.net.SharedObject;
#end

/**
 * <h2>Description</h2>
 * <p>
 *  A class that manages data storage that is persistent over time, thus it can
 *  be used for storing configuration data, savegames, etc.
 * </p>
 * 
 * <h2>Example (Writing)</h2>
 * <code>
 *  var name:String = "John Doe";<br />
 *  var settings:Storage = new Storage("settings");<br />
 *  settings.put("name", name);<br />
 *  settings.close();
 * </code>
 * 
 * <h2>Example (Reading)</h2>
 * <code>
 *  var settings:Storage = new Storage("settings");<br />
 *  var name:String = settings.get("name", "Anonymous");<br />
 *  settings.close();
 * </code>
 * 
 * @author Robert Böhm
 */
class Storage {
	
    #if js
    
	public var autoFlush:Bool = true;
	
    // NME/HTML5 doesn't support SharedObject.
    public function new(name:String) {}
    public static function canStore():Bool { return false; }
    public function clear():Void {}
    public function isset(key:String):Bool { return false; }
    public function unset(key:String):Void {}
    public function put(key:String, data:Dynamic):Void {}
    public function get(key:String, defaultData:Dynamic = null):Dynamic {
        return defaultData;
    }
    public function close():Void { }
	public function flush():Void { }
    
    #else
    
	/** Determines if this storage automatically flushes after each insertion. */
	public var autoFlush(getAutoFlush, setAutoFlush):Bool;
    
	
	/** The internal variable that determines if this storage automatically flushes after each insertion. */
	private var _autoFlush:Bool = true;
	
    /** The internal shared object this storage is based on. */
    private var _object:SharedObject;
    
    
    /**
     * Creates a new Storage-object with the given name.
     * 
     * @param   name    The name of this storage-object. To regain access to
     *                  this storage data, you have to use the identical name.
     */
    public function new(name:String) {
        _object = SharedObject.getLocal(name);
    }
    
    
    /**
     * Determines if this storage is able to hold data.
     * 
     * @return  True, except you're compiling for an unsupported platform.
     */
    public static function canStore():Bool {
        return true;
    }
    
    
    /**
     * Clears the data of this storage object.
     */
    public function clear():Void {
        _object.clear();
		this.flush();
    }
    
    /**
     * Determines if the given value is already defined.
     * 
     * @param   key The name of the value.
     * @return  True if the value is already defined.
     */
    public function isset(key:String):Bool {
        return Reflect.hasField(_object.data, key);
    }
    
    /**
     * Undefines the given value.
     * 
     * @param   key The name of the value.
     */
    public function unset(key:String):Void {
        Reflect.deleteField(_object.data, key);
		if(autoFlush)
			this.flush();
    }
    
    /**
     * Fills the given value with the given data.
     * 
     * @param   key     The name of the value.
     * @param   data    The data that will be stored.
     */
    public function put(key:String, data:Dynamic):Void {
        Reflect.setField(_object.data, key, data);
		if(autoFlush)
			this.flush();
    }
    
    /**
     * Closes this storage object, which means you shouldn't modify the data
     * unless you create a new storage object with the same name.
     */
    public function close():Void {
        // _object.close() only works in flash
        #if flash
        _object.close();
        #end
        
        _object = null;
    }
    
    /**
     * Returns the data of the given value.
     * @param   key         The name of the value.
     * @param   defaultData The default data. (Will be returned in case the data
     *                      isn't defined yet)
     * @return  The stored data or the default data if necessary.
     */
    public function get(key:String, defaultData:Dynamic=null):Dynamic {
        if (isset(key)) {
            return Reflect.field(_object.data, key);
        } else {
            return defaultData;
        }
    }
	
	/**
	 * Flushes the data of this storage.
	 */
	public function flush():Void {
		_object.flush();
	}
	
	
	/**
	 * Determines if this storage automatically flushes after each insertion.
	 * 
	 * @return	Determines if this storage automatically flushes after each insertion.
	 */
	private function getAutoFlush():Bool {
		return _autoFlush;
	}
	
	/**
	 * Defines if this storage shall automatically flush after each insertion.
	 * 
	 * @param	autoFlush	True, if this storage should automatically flush after each insertion.
	 * @return	True, if this storage should automatically flush after each insertion.
	 */
	private function setAutoFlush(autoFlush:Bool):Bool {
		if (autoFlush && !_autoFlush) {
			this.flush();
		}
		return _autoFlush = autoFlush;
	}
    
    #end
    
}
