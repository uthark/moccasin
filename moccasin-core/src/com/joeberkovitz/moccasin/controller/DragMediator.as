package com.joeberkovitz.moccasin.controller
{
    import com.joeberkovitz.moccasin.view.ViewContext;
    
    import flash.events.MouseEvent;
    import flash.geom.Point;

    /**
     * An abstract mediator handling the body of a drag gesture.
     */    
    public class DragMediator
    {
        private var _context:ViewContext;
        private var _dragPoint:Point;
        private var _dragStarted:Boolean = false;
        
        public var minimumDrag:Number = 3;
        
        public function DragMediator(context:ViewContext)
        {
            _context = context;
        }
        
        public function handleMouseDown(e:MouseEvent):void
        {
            if (e.ctrlKey || e.shiftKey)
            {
                return;
            }
            
            _dragStarted = false;
            
            _dragPoint = new Point(_context.stage.mouseX, _context.stage.mouseY);
            _context.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
            _context.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
            e.stopPropagation();
        }

        protected function get context():ViewContext
        {
            return _context;
        }        
        
        protected function get dragPoint():Point
        {
            return _dragPoint;
        }
        
        protected function get dragDelta():Point
        {
            return new Point(_context.stage.mouseX, _context.stage.mouseY).subtract(_dragPoint);
        }
        
        protected function handleMouseMove(e:MouseEvent):void
        {
            if (!_dragStarted
                && e.buttonDown
                && _dragPoint != null
                && (Math.abs(_context.stage.mouseX -_dragPoint.x) >= minimumDrag
                    || Math.abs(_context.stage.mouseY -_dragPoint.y) >= minimumDrag))
            {
                _dragStarted = true;
                handleDragStart(e);
            }
            
            if (_dragStarted)
            {
                handleDragMove(e);
            }
            e.stopPropagation();
        }
        
        protected function handleMouseUp(e:MouseEvent):void
        {
            if (_dragStarted)
            {
                handleDragMove(e);
                handleDragEnd(e);
            }
            else
            {
                handleClick(e);
            }
            _context.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
            _context.stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
            e.stopPropagation();
        }

        protected function handleDragStart(e:MouseEvent):void
        {
        }

        protected function handleDragMove(e:MouseEvent):void
        {
        }

        protected function handleDragEnd(e:MouseEvent):void
        {
        }
        
        protected function handleClick(e:MouseEvent):void
        {
        }
    }
}
