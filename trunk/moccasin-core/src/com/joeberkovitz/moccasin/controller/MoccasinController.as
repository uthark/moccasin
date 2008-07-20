package com.joeberkovitz.moccasin.controller
{
    import com.joeberkovitz.moccasin.document.IClipboard;
    import com.joeberkovitz.moccasin.document.ISelection;
    import com.joeberkovitz.moccasin.document.MoccasinDocument;
    import com.joeberkovitz.moccasin.document.ObjectSelection;
    import com.joeberkovitz.moccasin.event.ControllerEvent;
    import com.joeberkovitz.moccasin.event.SelectEvent;
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.model.ModelRoot;
    
    import flash.events.EventDispatcher;

    [Event(name="documentChange",type="com.joeberkovitz.moccasin.event.ControllerEvent")]
    [Event(name="addSelection",type="com.joeberkovitz.moccasin.event.SelectEvent")]
    [Event(name="removeSelection",type="com.joeberkovitz.moccasin.event.SelectEvent")]
    
    public class MoccasinController extends EventDispatcher implements IMoccasinController
    {
        private var _document:MoccasinDocument;
        private var _clipboard:IClipboard = null;
                
        public function MoccasinController(document:MoccasinDocument)
        {
            this.document = document;
        }
        
        public function get root():ModelRoot
        {
            return _document.root;
        }
        
        public function get clipboard():IClipboard
        {
            return _clipboard;
        }
        
        public function get selection():ISelection
        {
            return _document.selection;
        }
        
        [Bindable("documentChange")]
        public function get document():MoccasinDocument
        {
            return _document;
        }
        
        public function set document(d:MoccasinDocument):void
        {
            if (_document != null)
            {
                _document.removeEventListener(SelectEvent.ADD_SELECTION, handleSelectEvent);
                _document.removeEventListener(SelectEvent.REMOVE_SELECTION, handleSelectEvent);
            }
            _document = d;
            if (_document != null)
            {
                _document.addEventListener(SelectEvent.ADD_SELECTION, handleSelectEvent, false, 0, true);
                _document.addEventListener(SelectEvent.REMOVE_SELECTION, handleSelectEvent, false, 0, true);
            }
            
            dispatchEvent(new ControllerEvent(ControllerEvent.DOCUMENT_CHANGE));
        }
        
        public function copyClipboard():void
        {
            if (_document.selection != null && !_document.selection.empty)
            {
                _clipboard = _document.selection.createClipboard();
            }
        }
        
        public function cutClipboard():void
        {
            if (_document.selection != null && !_document.selection.empty)
            {
                _clipboard = _document.selection.createClipboard();
                removeSelection();
            }
        }
        
        public function pasteClipboard():void
        {
            if (_clipboard != null)
            {
                //pasteAt(_clipboard, selection);
            }
        }
        
        public function undo():void
        {
            _document.undoHistory.undo();
        }
        
        public function redo():void
        {
            _document.undoHistory.redo();
        }
        
        private function get selectedModels():Array
        {
            if (selection != null)
            {
                return selection.selectedModels;
            }
            else
            {
                return [];
            }
        }
        
        /**
         * Select exactly one object in the document 
         * @param m the object to be selected.
         */
        public function selectSingleModel(m:MoccasinModel):void
        {
            document.selection = new ObjectSelection(root, [m]);
        }

        /**
         * Extend an existing selection to include a model object 
         * @param n the object whose selected status is to be modified.
         */
        public function modifySelection(m:MoccasinModel):void
        {
            if (selection == null || selection.empty)
            {
                selectSingleModel(m);
            }
            else
            {
                // NOTE: didn't use polymorphism here because in the ObjectSelection case, we're
                // modifying the document; would prefer selection objects not to know about documents.
                //             
                if (selection is ObjectSelection)
                {
                    if (selection.contains(m))
                    {
                        _document.deselect(new ObjectSelection(root, [m]));
                    }
                    else
                    {
                        _document.select(new ObjectSelection(root, [m]));
                    }
                }
            }
        }

        /**
         * Clear any current selection for the document.  
         * 
         */
        public function clearSelection():void
        {
            document.selection = null;
        }
        
        /**
         * Remove all notes in the current selection. 
         */
        public function removeSelection():void
        {
            if (selection is ObjectSelection)
            {
                applyToSelection(function(m:MoccasinModel):void {
                    m.parent.removeChild(m);
                });
            }
        }
        
         /**
         * Apply some function to all selected note sets, including parent note sets of
         * selected notes. 
         */
        private function applyToSelection(f:Function):void
        {
            for each (var m:MoccasinModel in selectedModels)
            {
                f(m);
            }
        }
        

        /**
         * Handle all SelectEvents by redispatching, for convenience to our clients which would
         * rather not be bothered tracking changes in the ScoreDocument. 
         */
        private function handleSelectEvent(e:SelectEvent):void
        {
            dispatchEvent(e);
        }
    }
}
