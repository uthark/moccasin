package com.joeberkovitz.moccasin.view
{
    import com.joeberkovitz.moccasin.event.EditorEvent;
    import com.joeberkovitz.moccasin.view.ViewContext;
    
    import flash.display.Sprite;
    import flash.geom.Point;

    /**
     * A graphic used for manipulating a control point of some object, whose apparent size must remain constant
     * as the editor zoom scale is changed.
     */
    public class AbstractHandle extends Sprite
    {
        public var apparentSize:Number = 8;
        
        private var _context:ViewContext;
        private var _handleSize:Number;
        
        public function AbstractHandle(context:ViewContext)
        {
            _context = context;
            _context.editor.addEventListener(EditorEvent.DISPLAY_SCALE_CHANGE, handleScaleChange, false, 0, true);
            updateHandleSize();
            updateGraphics();
        }
        
        protected function updateGraphics():void
        {
        }
        
        protected function updateHandleSize():void
        {
            // Compensate for zoom factor in view to keep handle sizes constant
            _handleSize = apparentSize / _context.info.displayScale;
        }
        
        public function get handleSize():Number
        {
            return _handleSize;
        }

        private function handleScaleChange(e:EditorEvent):void
        {
            updateHandleSize();
            updateGraphics();
        }
        
        public function get position():Point
        {
            return new Point(x, y);
        }
        
        public function set position(p:Point):void
        {
            x = p.x;
            y = p.y;
        }
    }
}