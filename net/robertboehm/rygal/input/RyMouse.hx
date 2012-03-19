// Copyright (C) 2012 Robert Böhm
// This file is part of Rygal.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with Rygal. If not, see: <http://www.gnu.org/licenses/>.


package net.robertboehm.rygal.input;
import nme.display.DisplayObject;
import nme.display.Stage;
import nme.events.EventDispatcher;
import nme.events.IEventDispatcher;
import nme.events.MouseEvent;

/**
 * ...
 * @author Robert Böhm
 */

class RyMouse extends EventDispatcher {
	
	public var x:Int;
	public var y:Int;
	public var isPressed:Bool;
	private var _zoom:Int;
	#if (js || cpp)
	// HTML5 Mouse Events don't work on sprites, but they do on the stage
	private var _handler:DisplayObject;
	#end
	
	public function new(handler:DisplayObject, zoom:Int = 1) {
		super();
		
		_zoom = zoom;
		#if (js || cpp)
		_handler = handler;
		handler.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		handler.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		handler.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		#else
		handler.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		handler.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		handler.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		#end
	}
	
	private function onMouseDown(e:MouseEvent):Void {
		isPressed = true;
		this.dispatchEvent(new RyMouseEvent(RyMouseEvent.MOUSE_DOWN, this));
	}
	
	private function onMouseUp(e:MouseEvent):Void {
		isPressed = false;
		this.dispatchEvent(new RyMouseEvent(RyMouseEvent.MOUSE_UP, this));
	}
	
	private function onMouseMove(e:MouseEvent):Void {
		#if js
		this.x = Math.floor((e.stageX - _handler.x) / _zoom);
		this.y = Math.floor((e.stageY - _handler.y) / _zoom);
		#else
		this.x = Math.floor(e.localX / _zoom);
		this.y = Math.floor(e.localY / _zoom);
		#end
		this.dispatchEvent(new RyMouseEvent(RyMouseEvent.MOUSE_MOVE, this));
	}
	
}
