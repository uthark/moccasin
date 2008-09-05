package com.joeberkovitz.moccasin.view
{
    import com.joeberkovitz.moccasin.event.EditorEvent;
    import com.joeberkovitz.moccasin.view.ViewContext;
    
    import flash.geom.Point;

    /**
     * Square graphic used for dragging some control point of an object.
     */
    public class SelectionHandle extends AbstractHandle
    {
        public function SelectionHandle(context:ViewContext)
        {
            super(context);
        }
        
        override protected function updateGraphics():void
        {
            graphics.clear();
            graphics.lineStyle(1, 0);
            graphics.beginFill(0xFFFFFF);
            graphics.drawRect(-handleSize/2, -handleSize/2, handleSize, handleSize);
            graphics.endFill();
        }
    }
}