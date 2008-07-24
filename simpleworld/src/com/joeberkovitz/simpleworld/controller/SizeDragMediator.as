package com.joeberkovitz.simpleworld.controller
{
    import com.joeberkovitz.moccasin.controller.DragMediator;
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.model.Square;
    import com.joeberkovitz.simpleworld.view.ShapeView;
    
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;

    /**
     * Mediator to resize a shape. 
     */
    public class SizeDragMediator extends DragMediator
    {
        private var _shapeView:ShapeView;
        private var _oldSizes:Array; /* of Numbers */
        
        public function SizeDragMediator(context:ViewContext)
        {
            super(context);
        }
        
        /**
         * When asked to work with a ShapeView, take note of the view and add a listener for mouseDown.
         */
        public function handleViewEvents(view:ShapeView):void
        {
            _shapeView = view;
            view.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        }
        
        /**
         * At the start of a drag, capture the sizes of all selected shapes so that we
         * can resize them all by the same delta later on.
         */
        override protected function handleDragStart(e:MouseEvent):void
        {
            context.controller.document.undoHistory.openGroup("Resize Shapes");
            _oldSizes = [];
            for each (var m:MoccasinModel in context.controller.selection.selectedModels)
            {
                var sq:Square = Square(m.value);
                _oldSizes.push(sq.size);
            }
        }
        
        /**
         * For each move during the drag, resize the models appropriately.
         */
        override protected function handleDragMove(e:MouseEvent):void
        {
            var i:int = 0;
            for each (var m:MoccasinModel in context.controller.selection.selectedModels)
            {
                var sq:Square = Square(m.value);
                sq.size = _oldSizes[i++] + Math.max(documentDragDelta.x, documentDragDelta.y);
            }
        }
    }
}