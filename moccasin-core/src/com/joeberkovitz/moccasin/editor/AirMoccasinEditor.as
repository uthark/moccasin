package com.joeberkovitz.moccasin.editor
{
    import com.joeberkovitz.moccasin.service.MoccasinDocumentData;
    
    import flash.events.Event;
    import flash.filesystem.File;
    
    /**
     * Extension of MoccasinEditor with some AIR-specific capabilities. 
     */
    public class AirMoccasinEditor extends MoccasinEditor
    {
        /**
         * Open a particular score -- this has nothing to do with training. 
         */
        public function openFile():void
        {
            var file:File = new File();
            file.browseForOpen("Open Document");
            file.addEventListener(Event.SELECT, handleSelectOpen);            
        }
        
        private function handleSelectOpen(e:Event):void
        {
            var file:File = e.target as File;
            loadDocument(file.url);
        }
        
        public function saveAsFile():void
        {
            var file:File = new File();
            file.browseForSave("Save Document As...");
            file.addEventListener(Event.SELECT, handleSelectSaveAs);            
        }
        
        private function handleSelectSaveAs(e:Event):void
        {
            var file:File = e.target as File;
            
            if (documentData == null)
            {
                documentData = new MoccasinDocumentData(_document.root, file.url);
            }
            else
            {
                documentData.documentId = file.url;
            }
            
            saveDocument();
        }
     }
}