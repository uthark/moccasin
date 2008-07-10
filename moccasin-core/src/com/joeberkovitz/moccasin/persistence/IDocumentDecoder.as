package com.joeberkovitz.moccasin.persistence
{
    import com.joeberkovitz.moccasin.model.ModelRoot;
    
    public interface IDocumentDecoder
    {
        function decodeDocument(data:*):ModelRoot
    }
}
