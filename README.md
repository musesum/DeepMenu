Deep Menu 


Naming convention

    Mu<name>Model - A persistent model of nodes, shared by Mu<name> views (MVVM "Model")
    Mu<name>Vm - ObservableObject companion to a Mu<name>View (MVVM "ViewModel")
    Mu<name>View - Always a SwiftUI View (MVVM "View")
    
    prefixes - may be a single letter to prefix to a variable name
    
        x* - point x in a CGPoint
    
        y* - point y in a CGPoint
    
        w* - width in a CGSize
    
        h* - height in a CGSize
    
        r* - radius / distance from center of a node
    
        s* - spacing between nodes
        
        spot* - spotlight on current Node, Branch
         
        parent - super `Node` or `Model` / parent in a hierarchy
         
Programming convention

    Views don't own Nodes, Branches, Limb, or Root,
        which may be synchroniozed accross devices,
        like iPhone, iBranch, TV, watch, shareplay
    So, no @State or @StateObjects are used
        Keep View(s) as functions, which don't own source of truth
        Instead, use a 1:1 class:struct Mu<name>Vm:Mu<name>View

Components - Mu<Name>

    Main - content View containing Root and Space

    Space - non menu content 

    Touch - Helper to manage touch deltas and tap timing

    Pilot - move from node to node or into open space

    Root - starting point in the corners, contains 1 or 2 limbs

    Limb - unfolding horizontal or vertical branches

    Branch - a series of sub-menu (sub-branches)

    Node - individual nodes aligned along branch

    Leaf - last sub-branch contains a special node 

    Panel - backing view for touch controls  

Use cases - 

    Conductor style menu for Handpose (AR Glasses?)
    
    Replace MuseSky Tr3Thumb Panel
