Deep Menu 


Naming convention

    Mu<name>Model - A persistent model of nodes, shared by Mu<name> views (MVVM "Model")
    Mu<name> - ObservableObject companion to a Mu<name>View (MVVM "ViewModel")
    Mu<name>View - Always a SwiftUI View (MVVM "View")

    The <name> views follows a hierarchy of

        Space - where content and menues are

        Pilot - follows your finger/thumb/pencil to select Nodes and stack Branches

        Root - Corner of Space that contains one or two Limbs
            each limb is aligned horizonal or vertical

        Limb - a hierarchy of stacked Branches
            vLimb instance - a static hierarchy of vertical Branches
            hLimb instance - a dynamic history of horizontal Branches

        Branch - a viewable collection of Nodes
            stacked in levels of increasing detail
            
        Node - an individual item
            spotNode - spotlight node highlighted in bar
            same node can be on multiple branches

        Border - Border and bounds for branch

    
    spot* - spotlight on current Node, Branch
    
    prefixes - may be a single letter to prefix to a variable name
    
        x* - point x in a CGPoint
    
        y* - point y in a CGPoint
    
        w* - width in a CGSize
    
        h* - height in a CGSize
    
        r* - radius / distance from center of a node
    
        s* - spacing between nodes
        
        parent - super `Node` or `Model` / parent in a hierarchy
         
Programming convention

    Views don't own Nodes, Branches, Limb, or Root,
        which may be synchroniozed accross devices,
        like iPhone, iBranch, TV, watch, shareplay
    So, no @State or @StateObjects are used
        Keep View(s) as functions, which down own source of truth
        Instead, use a 1:1 class:struct Mu<name>:Mu<name>View

Components - Mu<Name>

    Main - content View containing Root and Space

    Space - where the actual non menu content goes

    Touch - Helper to manage touch deltas and tap timing

    Pilot - move from node to node or into open space

    Root - starting point in the corners, contains 1 or 2 limbs

    Limb - unfolding horizontal or vertical branches

    Branch - a series of sub-menu (sub-branches)

    Node - individual nodes aligned along branch

    Leaf - last sub-branch contains a special node 

    Border - helper function for drawing bezel around branches 

Use case - Replace MuseSky Tr3Thumb Panel -- see DeepMuseMenu.h
