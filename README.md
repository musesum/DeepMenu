Deep Menu 


Naming convention
    MuTouch* - capture touches which are captured by a branchf
        MuTouch - manage touch's [begin,moved,ended] state plus taps
        MuTouchVm - state for root and drag nodes
        MuTouchView - view for root and drag nodes
    MuRoot* - starting point for one of more MuTree(s)
        MuRootVm - touch, corner, pilot, trees, branchNow, nodeNow
        MuRootView - manage UIViews for each corner 
        MuRootStatus - publish changed state in [root,tree,edit,space]
    MuTree* - horizonatal or vertical hierarcy of Branches 
        MuTreeVm - select MuNode, add or remove sub-branches
        MuTreeView - SwiftUI view collection of MuBranch's 
    MuBranch* - one level in a hierachy containing MuNodes
        MuBranchVm - view model of a branch
        MuBranchView - SwiftUI view collection of MuNodeViews
        MuBranchPanelView - background panel for MuBranchView
    MuNode* - A persistent model of items, may be shared by many Mu*Vms
        MuNode - a generic node, may be shared my many NodeVm's (and views)
        MuNodeTr3 - a node proxy for Tr3 items 
        MuNodeVm - a view model for a View, may share a Node from another Vm
        MuNodeView - a SwiftUI view, has a companion MuNodeVm
        MuNodeIconView - a subview of MuNodeView for icons
        MuNodeTextView - a subview of MuNodeView for text
    MuLeaf* - subclass of MuNode with a user touch control  
        MuLeafTap - tap to activate, like a drum pad
        MuLeafTog - toggle a switch 0 or 1
        MuLeafSeg - segmented control
        MuLeafVal - single dimension value
        MuLeafVxy - 2 dimension xy control
    MuPanel* - background for MuBranchView and bounds for Mu[Node,Leaf]*View
        MuPanelVm - type, axis, size, and margins for View
        MuPanelView - SwiftUI background 
    class and struct suffixes 
        Mu*View - A SwiftUI View with corresponding Mu*Vm
        Mu*Vm  - View Model for comnpanion Mu*View
    
    var prefixes - may be a single letter to prefix to a variable name
    
        x* - x in a CGPoint(x:y:)
        y* - y in a CGPoint(x:y:)
    
        w* - width  in CGSize(width:height)
        h* - height in CGSize(width:height)
    
        r* - radius / distance from center of a node
        s* - spacing between nodes
        
        spot* - spotlight on current Node, Branch
         
        parent - super `Node` or `Model` / parent in a hierarchy
         
    Components - Mu<Name>[Vm,View]

   
Programming convention

    Views don't own Nodes, Branches, Limb, or Root,
        which may be synchroniozed accross devices,
        like iPhone, iPad, TV, watch, shareplay
        
    So, no @State or @StateObjects are used
        Keep View(s) as functions, which don't own source of truth
        Instead, use a 1:1 class:struct Mu<name>Vm:Mu<name>View


Use cases - 

    Conductor style menu for Handpose (AR Glasses?)
    
    Replace MuseSky Tr3Thumb Panel
