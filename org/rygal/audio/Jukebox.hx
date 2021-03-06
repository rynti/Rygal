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


package org.rygal.audio;

/**
 * <h2>Description</h2>
 * <p>
 *  A jukebox that plays music in the background.
 * </p>
 * 
 * <h2>Example</h2>
 * <code>
 *  var jukebox:Jukebox = new Jukebox(Jukebox.MODE_RANDOM);<br />
 *  jukebox.addSound(Sound.fromAssets("assets/music1.mp3"));<br />
 *  jukebox.addSound(Sound.fromAssets("assets/music2.mp3"));<br />
 *  jukebox.addSound(Sound.fromAssets("assets/music3.mp3"));<br />
 *  jukebox.start();
 * </code>
 * 
 * @author Robert Böhm
 */
class Jukebox {
    
    /** Looping playmode. */
    public static inline var MODE_LOOP:Int = 0;
    
    /** Random playmode. */
    public static inline var MODE_RANDOM:Int = 1;
    
    
    /** Current playmode. */
    public var mode:Int;
    
    
    /** The instance of the currently playing sound. */
    private var _currentSoundInstance:SoundInstance;
    
    /** The currently playing sound. */
    private var _currentSound:Sound;
    
    /** The index of the next sound. */
    private var _nextIndex:Int;
    
    /** The array with all _sounds. */
    private var _sounds:Array<Sound>;
    
    /** Determines if this jukebox is playing. */
    private var _running:Bool;
    
    
    /**
     * Creates a new jukebox with the given playmode.
     * 
     * @param   mode    The playmode of this jukebox, by default it's looping.
     */
    public function new(mode:Int = 0) {
        this.mode = mode;
        this._sounds = new Array<Sound>();
        this._nextIndex = 0;
    }
    
    
    /**
     * Adds a sound to this jukebox.
     * 
     * @param   sound   The sound that will be added to the jukebox.
     */
    public function addSound(sound:Sound):Void {
        if(sound != null)
            this._sounds.push(sound);
    }
    
    /**
     * Removes a sound from this jukebox.
     * 
     * @param   sound   The sound that'll be removed.
     */
    public function removeSound(sound:Sound):Void {
        this._sounds.remove(sound);
        if (_currentSound == sound) {
            nextSound();
        }
    }
    
    /**
     * Forces the jukebox to play the next sound.
     * Will be automatically called when a sound is played completely.
     */
    public function nextSound():Void {
        if (this._sounds.length == 0) {
            stop();
        } else if (isRunning()) {
            if (mode == MODE_LOOP) {
                if (_nextIndex >= _sounds.length) {
                    _nextIndex = 0;
                }
                _currentSound = _sounds[_nextIndex++];
                
            } else {
                _currentSound = _sounds[
                        Std.int(Math.random() * _sounds.length)
                    ];
            }
            
            if (_currentSound != null) {
                _currentSoundInstance = _currentSound.play();
                if (_currentSoundInstance != null) {
                    _currentSoundInstance.addEventListener(
                        SoundEvent.SOUND_COMPLETE, onSoundComplete);
                } else {
                    _running = false;
                }
            } else {
                _running = false;
            }
        }
    }
    
    /**
     * Starts this jukebox.
     */
    public function start():Void {
        if (!isRunning() && this._sounds.length > 0) {
            _running = true;
            this.nextSound();
        }
    }
    
    /**
     * Stops this jukebox.
     */
    public function stop():Void {
        if (isRunning()) {
            _running = false;
            if(_currentSoundInstance != null)
                _currentSoundInstance.stop();
            
            _currentSound = null;
            _currentSoundInstance = null;
            _nextIndex = 0;
        }
    }
    
    /**
     * Determines if this jukebox is currently _running.
     * 
     * @return  True if this jukebox is _running.
     */
    public function isRunning():Bool {
        return _running;
    }
    
    /**
     * Returns the count of Sounds in this Jukebox
     *
     * @return count of Sounds
     */
    public function getSoundCount():Int {
        return this._sounds.length;
    }
    
    
    /**
     * A callback that will be called as soon as the current sound has ended.
     * 
     * @param   e   Event parameters.
     */
    private function onSoundComplete(e:SoundEvent):Void {
        _currentSoundInstance.removeEventListener(SoundEvent.SOUND_COMPLETE,
            onSoundComplete);
        nextSound();
    }
    
}
