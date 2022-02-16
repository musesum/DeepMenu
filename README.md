Deep Menu 


Naming convention

    Mu<name>View - Always a SwiftUI View
    Mu<name>Model - A persistent model of pods, shared by Mu<name> views
    Mu<name> - ObservableObject companion to a Mu<name>View

    The <name> views follows a hierarchy of

        Space - where content and menues are

        Pilot - follows your finger/thumb/pencil to select Pods and stack Docks

        Hub - Corner of Space that contains one or two Spokes
            each spoke is aligned horizonal or vertical

        Spoke - a hierarchy of stacked Docks
            vSpoke instance - a static hierarchy of Docks for vert
            hSpoke instance - a dynamic history of vert

        Dock - contains one or more Pods
            stacked in levels of increasing detail
            landing bay multiple docking pods

        Pod - an individual item to select
            spotPod - spotlight pod highlighted in bar
            pods don't move -

        Border - Border and bounds for dock

    Spot* - spotlight on current Pod, Dock
Programming convention

    Views don't own Pods, Docks, Spoke, or Hub,
        which may be synchroniozed accross devices,
        like iPhone, iDock, TV, watch, shareplay
    So, no @State or @StateObjects are used
        Keep View(s) as functions, which down own source of truth
        Instead, use a 1:1 class:struct Mu<name>:Mu<name>View

Components - Mu<Name>
    Main - content View containing Hub and Space
    Space - where the actual non menu content goes
    Touch - Helper to manage touch deltas and tap timing
    Pilot - move from pod to pod or into open space
    Hub - starting poinrt in the corners, contains 1 or 2 spokes
    Spoke - contains unfolding docks of either horizontal or vertical docs
    Dock - a series of sub-menue (sub-docks)
    Pod - individual nodes aligned along dock
    Leaf - last sub-dock contains a special pod 
    Border - helper function for drawing bezel around docks 
