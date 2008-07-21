package com.joeberkovitz.simpleworld.editor
{
    import com.joeberkovitz.moccasin.editor.EditorMenuBar;
    import com.joeberkovitz.simpleworld.controller.AppController;
    
    public class AppMenuBar extends EditorMenuBar
    {
        public function AppMenuBar()
        {
            super();
        }
        
        public function get airEditor():AppEditor
        {
            return editor as AppEditor;
        }
        
        public function get simpleController():AppController
        {
            return editor.controller as AppController;
        }
        
        override protected function initializeMenuItems():void
        {
            super.initializeMenuItems();
            
            var fileMenu:XML = menuBarDefinition.(@id == "file")[0];
            fileMenu.insertChildBefore(fileMenu.menuitem.(@id == "save"), <menuitem id="open" label="Open..."/>);
            fileMenu.insertChildAfter(fileMenu.menuitem.(@id == "save"), <menuitem id="saveAs" label="Save As..."/>);
            
            menuBarDefinition +=
                <menuitem id="simpleWorld" label="SimpleWorld">
                    <menuitem id="addSquare" label="Add Square"/>
                </menuitem>;
        }
        
        override protected function handleCommand(commandName:String):void
        {
            switch(commandName)
            {
            case "open":
                airEditor.openFile();
                break;
                
            case "saveAs":
                airEditor.saveAsFile();
                break;

            case "addSquare":
                simpleController.document.undoHistory.openGroup("Add Square");
                simpleController.addObject();           
               
            default:
                super.handleCommand(commandName);
            }
        }
    }
}