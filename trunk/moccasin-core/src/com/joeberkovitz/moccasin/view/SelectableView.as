package com.joeberkovitz.moccasin.view
{
    import com.joeberkovitz.moccasin.controller.SelectionMediator;
    import com.joeberkovitz.moccasin.document.ObjectSelection;
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    
    import flash.events.MouseEvent;
    import flash.filters.BitmapFilter;
    import flash.filters.GlowFilter;
    
    public class SelectableView extends MoccasinView
    {
        private var _rolled:Boolean = false;
        
        public function SelectableView(context:ViewContext, model:MoccasinModel)
        {
            super(context, model);
            addEventListener(MouseEvent.ROLL_OVER, addRollHighlight);
            addEventListener(MouseEvent.ROLL_OUT, removeRollHighlight);
        }
        
        override public function initialize():void
        {
            super.initialize();
            new SelectionMediator().handleViewEvents(this);
        }

        override public function get selected():Boolean
        {
            if (context.document == null || context.document.selection == null)
            {
                return false;
            }
            
            if (context.document.selection.includes(model))
            {
                // Highlight this note if it is included within the current selection, with
                // one special exception: if this notation is subsidiary to some other ValueNotation (e.g. a Note),
                // and the selection isn't an ObjectSelection, then a parent view will be taking care of the selection and
                // it will look and act wrong to doubly highlight the note as well as the note set
                // to which it belongs.
                //
                return (context.document.selection is ObjectSelection);
            }
            
            return false;
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
