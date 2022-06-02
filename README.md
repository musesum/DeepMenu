# Deep Menu 

### Components
![Screenshot](Components.png)

#### Naming convention for components
+ Mu*View - SwiftUI View for [root,tree,branch,panel,node,leaf] 
+ Mu*Vm   - view model for [root,tree,branch,panel,node,leaf] 
   
#### MuRoot* - starting point for one of more MuTree(s)
+ MuRootVm - touch, corner, pilot, trees, branchNow, nodeNow
+ MuRootView - manage UIViews for each corner 
+ MuRootStatus - publish changed state in [root,tree,edit,space]

##### MuTree* - horizonatal or vertical hierarcy of MuBranches 
+ MuTreeVm - select MuNode, add or remove sub-branches
+ MuTreeView - SwiftUI view collection of MuBranch's 

##### MuBranch* - one level in a hierachy containing MuNodes
+ MuBranchVm - view model of a branch
+ MuBranchView - SwiftUI view collection of MuNodeViews
+ MuBranchPanelView - background panel for MuBranchView
        
##### MuNode* - A persistent model of items (shared by many Mu*Vms) 
+ MuNode - a generic node, may be shared my many NodeVm's (and views)
+ MuNodeTr3 - a node proxy for Tr3 items 
+ MuNodeVm - a view model for a View, may share a Node from another Vm
+ MuNodeView - a SwiftUI view, has a companion MuNodeVm
+ MuNodeIconView - a subview of MuNodeView for icons
+ MuNodeTextView - a subview of MuNodeView for text
        
##### MuLeaf* - subclass of MuNode with a user touch control  
+ MuLeafTap - tap to activate, like a drum pad
+ MuLeafTog - toggle a switch 0 or 1
+ MuLeafSeg - segmented control
+ MuLeafVal - single dimension value
+ MuLeafVxy - 2 dimension xy control
   
##### MuPanel* - stroke+fill branches and bounds for node views

+ MuPanelVm - type, axis, size, and margins for View
+ MuPanelView - SwiftUI background 
+ MuPanelAxisView - vertical or horizontal PanelView 

##### MuTouch* - capture touches which are captured by a branches
  - MuTouch - manage touch's [begin,moved,ended] state plus taps
  - MuTouchVm - state for root and drag nodes
  - MuTouchView - view for root and drag nodes
   
##### Prefixes and Suffixes
+ components 
  - <name>*Vm - instance of view model
  - <name>*Vms - array of [<name>*Vm]
+ point, size, radius, spacing 
  - x* - x in a CGPoint(x:y:)
  - y* - y in a CGPoint(x:y:)
  - w* - width  in CGSize(width:height)
  - h* - height in CGSize(width:height)
  - r* - radius / distance from center of a node
  - s* - spacing between nodes
+ hierarchy
  - spot* - spotlight on current Node, Branch
  - parent* - parent in model hierarchy
  - children* - [child] array in model hierarchy
  - child - current child in for loop
  - super - a parent in a view hierarchy
  - sub - a child in view hierarcy
             
### Relationships between classes and structs  (1:1, 1:M, M:N) 
+ treeVm ->> branchVm ->> nodeVm <-> node

  - treeVm   to branchVm {1,}   // 1:M array [branchVm]s expanded  
  - branchVm to nodeVm   {1,}   // 1:M a branchVm has 1 or more nodeVms
  - nodeVm   to node     {1,1}  // 1:1 one branchVm for each nodeVm    
  - node     to nodeVm   {0,}   // 1:M may be shared by many or cached
  
   
    
### SwiftUI restrictions

+ SwiftUI Views cannot modify its own state  
  - So, no @State or @StateObjects are used
  + Instead, change state in view model (Vm)
        
+ View Model(Vm) is a class, not struct
  - fine tuned @Published to update View
  - synchronize state between devices, including: iPhone, iPad, TV, watch, Shareplay
            
+ pros: @State has been somewhat buggy in the past
        
+ cons: requires a manually enforced coding policy 
        
### SwiftLint violations - emphasis on columnwise alignment
    
+ column-wise comments on right side 
+ finitw state machine colums for case statements

+ pros
  - Human Readable; catch mistakes
  - allow column-wise cursor to edit multiple rows at a time    

+ cons 
  - when refactoring, may need manual fixup
  - will not pass standard SwiftLint
  - requires a manually enforced coding policy 
  - cannot build documentation with right column /// comments  
        
##### Exceptions to columnwise alignment 
        
+ lvalue = rvalue

    equals(=) sign is always single space from lvalue

         name = value
         longerName = value
    
    avoid (do NOT align)
      
         name       = value
         longerNmae = value
         
    to allow later searches 

         name =
         longerName =
             
##### Whitespace row after func (...)
 
+ separate spacer line after `func <name> (...) {`

  easier to scan code for functions
    
+ exception for `guard <parm> = <parm> else { return }` statements

  extension of `(...)` in `func <name> (...)`
  
see [Baeker & Marcus](https://dl.acm.org/doi/pdf/10.1145/800045.801621)
        using typography for source code
         

#### Use cases 

    Conductor style menu for hand pose (AR Glasses?)
    
    Replace MuseSky Tr3Thumb Panel
	
	Hardware device


#### To Do
+ Bugs
  - Branch Fix navigation
+ Root
  - Tap toggles hide/show last Views
+ Tree
  - Slide-in hides super-branches
  - Transparent while editing leaf
+ Node
  - Show icons 
+ Leaf 
  - Tr3 Callback & persist
  - Drag leaf to Sky
+ Touch 
  - finder latency to hop accross Branches
+ Devices 
  - Synchonize Vms
  - iPad Mac layout
  - Apple Watch Layout
+ Touch.AI demos
  - Handpose overlay
  - Apple Watch Dial
  - Touch.AI web setup
    
+ MuseSky integration
  - Sky as UIKit compatible view
  - replace Tr3Thumb.package
  - replace panel.*.tr3.h
  - refactor sky.tr3.h
  - refactor shader.tr3.h
  - refactor midi.tr3.h
            
