package com.joeberkovitz.moccasin.persistence
{
    import com.joeberkovitz.moccasin.model.ModelRoot;
    
    public interface IDocumentEncoder
    {
        function encodeDocument(root:ModelRoot):*;
    }
}
