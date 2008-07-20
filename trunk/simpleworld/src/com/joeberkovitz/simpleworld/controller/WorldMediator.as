package com.joeberkovitz.simpleworld.controller
{
    import com.joeberkovitz.moccasin.controller.DragMediator;
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.MoccasinView;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.model.SquareModel;
    import com.joeberkovitz.simpleworld.view.WorldView;
    
    import flash.events.MouseEvent;

    public class WorldMediator extends DragMediator
    {
        public function WorldMediator(context:ViewContext)
        {
            super(context);
        }
        
        public function handleViewEvents(view:MoccasinView):void
        {
            view.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        }
        
        override protected function handleClick(e:MouseEvent):void
        {
            context.controller.document.undoHistory.openGroup("Add Square");
            var square:SquareModel = new SquareModel();
            square.x = e.localX;
            square.y = e.localY;
            square.size = 25;
            WorldView(e.target).world.shapes.addItem(square);
            context.controller.selectSingleModel(MoccasinModel.forValue(square));
        }
        
    }
}