package com.joeberkovitz.simpleworld.controller
{
    import com.joeberkovitz.moccasin.controller.DragMediator;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.view.SquareFeedback;
    
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;

    /**
     * Mediator to resize a shape. 
     */
    public class SizeDragMediator extends DragMediator
    {
        private var _squareView:SquareFeedback;
        private var _oldSize:Number;
        
        public function SizeDragMediator(context:ViewContext)
        {
            super(context);
        }
        
        /**
         * When asked to work with a SquareFeedback, take note of the view and add a listener for mouseDown.
         */
        public function handleViewEvents(view:SquareFeedback, handle:DisplayObject):void
        {
            _squareView = view;
            handle.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        }
        
        /**
         * At the start of a drag, capture the size the selected shape.
         */
        override protected function handleDragStart(e:MouseEvent):void
        {
            context.controller.document.undoHistory.openGroup("Resize Square");
            _oldSize = _squareView.square.size;
        }
        
        /**
         * For each move during the drag, resize the model appropriately.
         */
        override protected function handleDragMove(e:MouseEvent):void
        {
            _squareView.square.size = _oldSize + Math.max(documentDragDelta.x, documentDragDelta.y);
        }
    }
}