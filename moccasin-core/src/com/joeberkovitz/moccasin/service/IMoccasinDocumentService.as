package com.joeberkovitz.moccasin.service
{
    import com.joeberkovitz.moccasin.model.ModelRoot;
    
    /**
     * Interface definition for a service that handles the loading and saving of scores. 
     */
    public interface IMoccasinDocumentService
    {
        /**
         * Return an operation that will load a document from the given documentId when executed.
         * The result of the operation, when completed, is a MoccasinDocumentData object which includes
         * the document model along with other descriptive information.
         * 
         * @param documentUri the URI of a document to be loaded
         */
        function loadDocument(documentUri:String):IOperation;
        
        /**
         * Return an operation that will save a document from the given data.  The result of
         * this operation, when completed, is a new MoccasinDocumentData instance that may contain additional
         * descriptive information about the score such as its ID.
         *  
         * @param documentData a MoccasinDocumentData object describing a persisted document.
         */
        function saveDocument(documentData:MoccasinDocumentData):IOperation;
    }
}
