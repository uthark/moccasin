package com.joeberkovitz.simpleworld.view
{
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.controller.SizeDragMediator;
    import com.joeberkovitz.simpleworld.model.Square;
    
    import flash.display.Sprite;

    /**
     * Feedback variation of a SquareView that displays associated resizing handle in the editor's
     * feedbackLayer UIComponent. Note that this extends ShapeView and thus inherits its position-tracking behavior.
     */
    public class SquareFeedback extends ShapeView
    {
        private var _sizeHandle:Sprite;
        
        public function SquareFeedback(context:ViewContext, model:MoccasinModel=null)
        {
            super(context, model, false);
            initialize();
            
            new SizeDragMediator(context).handleViewEvents(this, _sizeHandle);
        }
        
        public function get square():Square
        {
            return model.value as Square;
        }
        
        override protected function createChildren():void
        {
            super.createChildren();

            // create the resize handle
            _sizeHandle = new Sprite();
            addChild(_sizeHandle);
        }

        override protected function updateView():void
        {
            super.updateView();
            
            // Draw a gray selection border around the square
            graphics.lineStyle(1, 0x999999);
            graphics.drawRect(0, 0, square.size, square.size);

            // draw the resizing handle
            _sizeHandle.graphics.clear();
            _sizeHandle.graphics.lineStyle(1, 0);
            _sizeHandle.graphics.beginFill(0xFFFFFF);
            _sizeHandle.graphics.drawRect(square.size - 3, square.size - 3, 6, 6);
            _sizeHandle.graphics.endFill();
        }
    }
}