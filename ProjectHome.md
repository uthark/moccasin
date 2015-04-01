Moccasin is an ActionScript3 library which supplies the basic infrastructure needed to build an graphical editor in which a graphical view of some set of distinct objects is manipulated using keyboard and mouse gestures.  It supplies such fundamentals as a robust MVCS-style architecture with Mediators, object selection, object repainting and highlighting, multilevel undo/redo, document marshalling and persistence, and view scaling.

Moccasin is based on Flex/AIR.  In version 0.21, Moccasin allows Flex UIComponent-based view hierarchies, but also supports more lightweight Flash Sprite-based view classes.

The Moccasin project today has two main components: `moccasin-core` and `simpleworld`.

`moccasin-core` is the framework project.  When built, it exposes a SWC containing the full Moccasin library.

`simpleworld` is a fully functional AIR application in which squares can be created within a 2D graphical world, positioned, and resized.  These worlds can be loaded and saved as XML documents, support a number of different selection techniques, and all operations are undoable.  Although this is not a very rich application, it demonstrates most of the key capabilities of Moccasin and is a good starting point for creating more complex apps based on Moccasin.