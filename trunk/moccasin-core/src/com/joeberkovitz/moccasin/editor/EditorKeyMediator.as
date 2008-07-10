package com.joeberkovitz.moccasin.editor
{
    import com.joeberkovitz.moccasin.controller.IMoccasinController;
    
    import flash.events.KeyboardEvent;
    
    public class EditorKeyMediator
    {
        private var _controller:IMoccasinController;
        protected var _editor:MoccasinEditor;

        public function EditorKeyMediator(controller:IMoccasinController, editor:MoccasinEditor)
        {
            _controller = controller;
            _editor = editor;
        }
        
        public function get controller():IMoccasinController
        {
            return _controller;
        }
        
        public function handleKey(e:KeyboardEvent):void
        {
            //trace("charCode = " + e.charCode.toString(16) + ", keyLocation = " + e.keyLocation.toString(16));
            var ch:String = String.fromCharCode(e.charCode);
            switch (ch)
            {
            case String.fromCharCode(0x03):   // Ctrl-C
                controller.copyClipboard();
                break;
                
            case "c":
                if (e.ctrlKey)
                {
                    controller.copyClipboard();
                    break;
                }
            case String.fromCharCode(0x16):
                controller.document.undoHistory.openGroup("Paste");
                controller.pasteClipboard();
                break;
                
            case "v":
                if (e.ctrlKey)
                {
                    controller.document.undoHistory.openGroup("Paste");
                    controller.pasteClipboard();
                }
                break;
                
            case String.fromCharCode(0x18):
                controller.document.undoHistory.openGroup("Cut");
                controller.cutClipboard();
                break;
                
            case "x":
                if (e.ctrlKey)
                {
                    controller.document.undoHistory.openGroup("Cut");
                    controller.cutClipboard();
                }
                break;
                
            case String.fromCharCode(0x19):
                controller.redo();
                break;
                
            case "y":
                if (e.ctrlKey)
                {
                    controller.redo();
                }
                break;
                
            case String.fromCharCode(0x1A):
                controller.undo();
                break;
                
            case "z":
                if (e.ctrlKey)
                {
                    controller.undo();
                }
                break;
                
            case String.fromCharCode(0x08):  // Delete, backspace or Ctrl-H
                controller.document.undoHistory.openGroup("Delete");
                controller.removeSelection();
                break;
                
            case String.fromCharCode(0x1B):   // Escape
                controller.document.undoHistory.openGroup("Clear Selection");
                controller.clearSelection();
                break;
                
            default:
                if (!handleKeyCode(e))
                    return;
                break;
            }
            
            // This needs to be aggressive, otherwise scrollbars can get arrow events.
            e.stopImmediatePropagation();
        }
        
        private function handleKeyCode(e:KeyboardEvent):Boolean
        {
            //trace("keyCode = " + e.keyCode.toString(16) + ", keyLocation = " + e.keyLocation.toString(16));
            switch (e.keyCode)
            {
            default:
                return false;
            }
            return true;
        }
}
    }
