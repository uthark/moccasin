package com.joeberkovitz.simpleworld.editor
{
    import com.joeberkovitz.moccasin.editor.EditorMenuBar;
    import com.joeberkovitz.simpleworld.controller.SimpleController;
    
    public class AirMenuBar extends EditorMenuBar
    {
        public function AirMenuBar()
        {
            super();
        }
        
        public function get airEditor():SimpleWorldEditor
        {
            return editor as SimpleWorldEditor;
        }
        
        public function get simpleController():SimpleController
        {
            return editor.controller as SimpleController;
        }
        
        override protected function initializeMenuItems():void
        {
            super.initializeMenuItems();
            
            var fileMenu:XML = menuBarDefinition.(@id == "file")[0];
            fileMenu.insertChildBefore(fileMenu.menuitem.(@id == "save"), <menuitem id="open" label="Open..."/>);
            fileMenu.insertChildAfter(fileMenu.menuitem.(@id == "save"), <menuitem id="saveAs" label="Save As..."/>);
            
            menuBarDefinition +=
                <menuitem id="simpleWorld" label="SimpleWorld">
                    <menuitem id="addObject" label="Add Object"/>
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

            case "addObject":
                simpleController.addObject();           
               
            default:
                super.handleCommand(commandName);
            }
        }
    }
}