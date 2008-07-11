package com.joeberkovitz.moccasin.controller
{
    import com.joeberkovitz.moccasin.event.ModelEvent;
    import com.joeberkovitz.moccasin.event.ModelStatusEvent;
    import com.joeberkovitz.moccasin.event.ModelUpdateEvent;
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.MoccasinView;
    
    import flash.events.MouseEvent;
    import flash.utils.getTimer;

    public class SelectionMediator
    {
        private var _view:MoccasinView;

        private var _lastClickMillis:Number = 0;
        
        public function SelectionMediator()
        {
        }

        public function handleViewEvents(view:MoccasinView):void
        {
            _view = view;
                  
            _view.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        }
        
        private function handleMouseDown(e:MouseEvent):void
        {
            var now:Number = getTimer();
            var doubleClick:Boolean = (now - _lastClickMillis) <= _view.context.info.doubleClickMillis;
            _lastClickMillis = now;

            if (!_view.model.enabled)
            {
                // some notations don't permit interaction
                return;
            }
            
            var model:MoccasinModel = _view.model;

            // TODO: add hook for appropriate drag mediators
            // If there was a click on a value notation (or something under one) and no
            // modifiers were pressed, then start a potential transposition drag operation.
            //
            //
            //      new XYZDragMediator(_view.context, notation, "Transpose").handleMouseDown(e);

            if (e.ctrlKey)
            {
                // extend an object selection to include the clicked model.
                _view.context.document.undoHistory.openGroup("Select Object");
                _view.context.controller.modifySelection(model);
            }
            else if (doubleClick)
            {
                // hook for editing
            }
            else if (_view.context.document.selection == null
                     || !_view.context.document.selection.includes(model))
            {
                // select the single model that was just clicked
                //
                _view.context.document.undoHistory.openGroup("Select Object");
                _view.context.controller.selectSingleModel(model);
            }
            e.stopPropagation();
            _view.context.editor.setFocus();
        }
    }
}
