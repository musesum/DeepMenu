# Deep Menu 

### Components - Mu<Name>[Vm,View]

   ![Screenshot](Components.png)


#### MuRoot* - starting point for one of more MuTree(s)
    MuRootVm - touch, corner, pilot, trees, branchNow, nodeNow
    MuRootView - manage UIViews for each corner 
    MuRootStatus - publish changed state in [root,tree,edit,space]

#### MuTree* - horizonatal or vertical hierarcy of Branches 
    MuTreeVm - select MuNode, add or remove sub-branches
    MuTreeView - SwiftUI view collection of MuBranch's 

#### MuBranch* - one level in a hierachy containing MuNodes
    MuBranchVm - view model of a branch
    MuBranchView - SwiftUI view collection of MuNodeViews
    MuBranchPanelView - background panel for MuBranchView
        
#### MuNode* - A persistent model of items (shared by many Mu*Vms)
 
    MuNode - a generic node, may be shared my many NodeVm's (and views)
    MuNodeTr3 - a node proxy for Tr3 items 
    MuNodeVm - a view model for a View, may share a Node from another Vm
    MuNodeView - a SwiftUI view, has a companion MuNodeVm
    MuNodeIconView - a subview of MuNodeView for icons
    MuNodeTextView - a subview of MuNodeView for text
        
#### MuLeaf* - subclass of MuNode with a user touch control  

    MuLeafTap - tap to activate, like a drum pad
    MuLeafTog - toggle a switch 0 or 1
    MuLeafSeg - segmented control
    MuLeafVal - single dimension value
    MuLeafVxy - 2 dimension xy control
   
#### MuPanel* - stroke+fill branches and bounds for node views

    MuPanelVm - type, axis, size, and margins for View
    MuPanelView - SwiftUI background 
    MuPanelAxisView - vertical or horizontal PanelView 

#### MuTouch* - capture touches which are captured by a branchf
   	MuTouch - manage touch's [begin,moved,ended] state plus taps
   	MuTouchVm - state for root and drag nodes
  	MuTouchView - view for root and drag nodes
   
        
### suffixes 

    <name>*Vm - instance of view model
    <name>*Vms - array of [<name>*Vm]
   
    x* - x in a CGPoint(x:y:)
    y* - y in a CGPoint(x:y:)
    w* - width  in CGSize(width:height)
    h* - height in CGSize(width:height)
    r* - radius / distance from center of a node
    s* - spacing between nodes
    
    spot* - spotlight on current Node, Branch
     
    parent* - parent in model hierarchy
    children* - [child] array in model hierarchy
    child - current child in for loop
    
    super - a parent in a view hierarchy
    sub - a child in view hierarcy
             

#### relationships between classes and structs  (1:1, 1:M, M:N) 

    node     to nodeVm   {0,}   // 1:M may be cached and unattached
    nodeVm   to branchVm {1,1}  // 1:1 one branchVm for each nodeVm
    branchVm to nodeVm   {1,}   // 1:M a branchVm has 1 or more nodeVms
    treeVm   to branchVm {1,}   // 1:M array [branchVm]s expanded  
    
    node ->> nodeVm -> branchVm <<- treeVm
    
    note, in the future, the user may 
        remove a nodeVm, without modifying the original node, or
        change the sequence of nodeVms withing a branchVm.
        however, this feature is not yet available.      
    
#### Programming conventions and violations

    Views don't own Nodes, Branches, Limb, or Root,
        which may be synchroniozed accross devices,
        like iPhone, iPad, TV, watch, shareplay
        
    So, no @State or @StateObjects are used
        Keep View(s) as functions, which don't own source of truth
        Instead, use a 1:1 class:struct Mu<name>Vm:Mu<name>View
        
    violates some SwiftLint conventions (and most C lint)
        strong emphasis on vertical alignment
            Human Readable; catch mistakes
            amenable to column-wise cursor to edit multiple rows at a time
        cons: when refactoring, may need manual fixup 
        
        exceptions 
            lvalue = rvalue, "+" sign is always single space from lvalue
            for example 
                name = value
                longerName = value
            not 
                name       = value
                longerNmae = value
            need consistent search for assignments
                on "name =" 
                or "longerName =" 
##### whitespace - 
     separate spacer line after `func <name> (...) {`
         easier to scan code for functions
         exception for `guard <parm> = <parm> else { return }` statements
         extension of `(...)` in `func <name> (...)`
     see [Baeker & Marcus: https://dl.acm.org/doi/pdf/10.1145/800045.801621] 
         workaround for single monospace font in code editor
         
##### cyclomatic complexity 
     max 5 +/- 2 parameters in function 
           


#### Use cases 

    Conductor style menu for Hand pose (AR Glasses?)
    
    Replace MuseSky Tr3Thumb Panel
