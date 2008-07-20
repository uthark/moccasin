package com.joeberkovitz.simpleworld.controller
{
    import com.joeberkovitz.moccasin.controller.DragMediator;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.model.ShapeModel;
    import com.joeberkovitz.simpleworld.view.ShapeView;
    
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    import mx.utils.ObjectUtil;

    public class ShapeDragMediator extends DragMediator
    {
        private var _shapeView:ShapeView;
        private var _oldShape:ShapeModel;
        
        public function ShapeDragMediator(context:ViewContext)
        {
            super(context);
        }
        
        public function handleViewEvents(view:ShapeView):void
        {
            _shapeView = view;
            _shapeView.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        }
        
        override protected function handleDragStart(e:MouseEvent):void
        {
            context.controller.document.undoHistory.openGroup("Move Shapes");
            context.controller.selectSingleModel(_shapeView.model);
            _oldShape = ObjectUtil.copy(_shapeView.shape) as ShapeModel;
        }
        
        override protected function handleDragMove(e:MouseEvent):void
        {
            var shape:ShapeModel = _shapeView.shape;
            var p:Point = dragDelta;
            shape.x = _oldShape.x + p.x;
            shape.y = _oldShape.y + p.y;
        }
        
        override protected function handleDragEnd(e:MouseEvent):void
        {
            handleDragMove(e);
        }
        
    }
}