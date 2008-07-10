package com.joeberkovitz.moccasin.document
{
    import com.joeberkovitz.moccasin.event.DocumentUpdateEvent;
    import com.joeberkovitz.moccasin.event.ModelEvent;
    import com.joeberkovitz.moccasin.event.ModelUpdateEvent;
    import com.joeberkovitz.moccasin.event.SelectEvent;
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.model.ModelRoot;
    
    import flash.events.EventDispatcher;
    
    [Event(name="addSelection",type="com.joeberkovitz.moccasin.event.SelectEvent")]
    [Event(name="removeSelection",type="com.joeberkovitz.moccasin.event.SelectEvent")]
    [Event(name="documentUpdate",type="com.joeberkovitz.moccasin.event.DocumentUpdateEvent")]
     
    [Bindable]
    public class MoccasinDocument extends EventDispatcher
    {
        private var _root:ModelRoot;
        private var _selection:ISelection = null;
        private var _undoHistory:UndoHistory = new UndoHistory();
        
        public function MoccasinDocument(root:ModelRoot = null)
        {
            super();
            this.root = root;
        }
        
        public function get undoHistory():UndoHistory
        {
            return _undoHistory;
        }
        
        public function get root():ModelRoot
        {
            return _root;
        }
        
        public function set root(s:ModelRoot):void
        {
            if (_root == s)
            {
                return;
            }
            
            if (_root != null)
            {
                _root.removeEventListener(ModelEvent.MODEL_CHANGE, handleModelChange);
                _root.removeEventListener(ModelUpdateEvent.MODEL_UPDATE, handleModelUpdate);
            }
            
            _root = s;
            _undoHistory.clear();
            
            if (_root != null)
            {
                _root.addEventListener(ModelEvent.MODEL_CHANGE, handleModelChange);
                _root.addEventListener(ModelUpdateEvent.MODEL_UPDATE, handleModelUpdate);
            }
        }

        public function get selection():ISelection
        {
            return _selection;
        }
        
        public function set selection(newSelection:ISelection):void
        {
            var oldSelection:ISelection = _selection;
            _selection = newSelection;
            if (oldSelection != null || newSelection != null)
            {
                if (oldSelection == null)
                {
                    dispatchSelectEvent(SelectEvent.ADD_SELECTION, newSelection);
                }
                else if (newSelection == null)
                {
                    dispatchSelectEvent(SelectEvent.REMOVE_SELECTION, oldSelection);
                }
                else if ((oldSelection is ObjectSelection) && (newSelection is ObjectSelection))
                {
                    var oSel:ObjectSelection = oldSelection as ObjectSelection; 
                    var nSel:ObjectSelection = newSelection as ObjectSelection; 
                    dispatchSelectEvent(SelectEvent.REMOVE_SELECTION, oSel.difference(nSel));
                    dispatchSelectEvent(SelectEvent.ADD_SELECTION, nSel.difference(oSel));
                }
                else
                {
                    dispatchSelectEvent(SelectEvent.REMOVE_SELECTION, oldSelection);
                    dispatchSelectEvent(SelectEvent.ADD_SELECTION, newSelection);
                }
            }
        }
        
        public function select(sel:ISelection):void
        {
            if (selection == null || selection.empty)
            {
                selection = sel;
            }
            else if ((selection is ObjectSelection) && (sel is ObjectSelection))
            {
                selection = ObjectSelection(selection).union(ObjectSelection(sel));
            }
            else
            {
                // In this case, we can't really compute a meaningful union, so just select the new selection
                selection = sel;
            }
        } 
        
        public function deselect(sel:ISelection):void
        {
            if ((selection is ObjectSelection) && (sel is ObjectSelection))
            {
                selection = ObjectSelection(selection).difference(ObjectSelection(sel));
            }
            else
            {
                // In this case, we can't really compute a meaningful difference, so clear the selection.
                selection = null;
            }
        }
        
        public function deselectDescendants(model:MoccasinModel):void
        {
            if (selection is ObjectSelection)
            {
                deselect(new ObjectSelection(root, [model]));
                
                for (var i:int = 0; i < model.numChildren; i++)
                {
                    deselectDescendants(model.getChildAt(i));
                }
            }
        }
        
        private function handleModelChange(e:ModelEvent):void
        {
            // All model updates are routed to the undo history.
            _undoHistory.addEdit(new UndoableModelEdit(e));
            
            if (e.kind == ModelEvent.REMOVING_CHILD_MODEL)
            {
                // deselect a dying object if it is in the selection, or one of its descendants
                deselectDescendants(e.child);
            }
        }
        
        private function handleModelUpdate(e:ModelUpdateEvent):void
        {
            // All model updates are routed to the undo history.
            _undoHistory.addEdit(new UndoableModelUpdate(e));
        }
        
        /**
         * Dispatch and internally handle any selection change events 
         * @param type the type of selection event
         * @param sel the selection which is being added or removed
         */
        private function dispatchSelectEvent(type:String, sel:ISelection):void
        {
            if (sel != null && !sel.empty)
            {
                // Dispatch the event to any listeners
                var selEvent:SelectEvent = new SelectEvent(type, sel); 
                dispatchEvent (selEvent);
            
                // Add the selection change to the undo history
                _undoHistory.addEdit(new UndoableSelectionChange(selEvent));
                
                // Dispatch status change events off of all objects in the model hierarchy that
                // have views who would care.
                sel.dispatchStatusChange();
            }
        }
    }
}
