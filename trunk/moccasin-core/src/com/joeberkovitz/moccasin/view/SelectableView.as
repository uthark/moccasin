package com.joeberkovitz.moccasin.view
{
    import com.joeberkovitz.moccasin.controller.SelectionMediator;
    import com.joeberkovitz.moccasin.document.ObjectSelection;
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    
    import flash.events.MouseEvent;
    import flash.filters.BitmapFilter;
    import flash.filters.GlowFilter;
    
    /**
     * Abstract class providing a range of functionality for selectable views and objects,
     * supporting mouse-based selection and rollover feedback.
     * @author joeb
     * 
     */
    public class SelectableView extends MoccasinView
    {
        private var _rolled:Boolean = false;
        
        public function SelectableView(context:ViewContext, model:MoccasinModel)
        {
            super(context, model);
            addEventListener(MouseEvent.ROLL_OVER, addRollHighlight);
            addEventListener(MouseEvent.ROLL_OUT, removeRollHighlight);
        }
        
        /**
         * Use a SelectionMediator to provide handling of selection gestures.
         */
        override protected function initialize():void
        {
            super.initialize();
            new SelectionMediator().handleViewEvents(this);
        }

        /**
         * Determine whether this object is selected or not by consulting the document's selection.
         */
        override public function get selected():Boolean
        {
            if (context.document == null || context.document.selection == null)
            {
                return false;
            }
            
            return context.document.selection.includes(model);
        }

        override public function updateStatus():void
        {
            super.updateStatus();
            
            if (_rolled && model.enabled && !feedback)
            {
                var f:BitmapFilter = new GlowFilter(context.info.selectionColors[0], 0.25, 10, 10, 8);
                filters = [f];
            }
            else
            {
                filters = null;
            }
        }
        
        protected function addRollHighlight(e:MouseEvent):void
        {
            _rolled = true;
            updateStatus();
            e.stopPropagation();
        }
        
        protected function removeRollHighlight(e:MouseEvent):void
        {
            _rolled = false;
            updateStatus();
            e.stopPropagation();
        }
    }
}
