//
//  ARscanView.swift
//  Ar trial
//
//  Created by niudan on 2023/3/16.
//

import SwiftUI
import RealityKit
import Combine

//MARK: ARscanView
struct ARscanView:View{
    
    
    //MARK: parameters
    @StateObject var ARappARpart:ARappARpartmodel=ARappARpartmodel()
    let startmode:scanmode?
    @State var updatemode:scanmode?
    @State var extraviewmode:scanmode
    @State var showmodeinformation:Bool=false
    @State var release:Bool=false
    @StateObject var Sequencemodel:Sequencegeneratormodel=Sequencegeneratormodel()
    @StateObject var Proportionalmodel:Proportionalcircuitmodel=Proportionalcircuitmodel()
    //MARK: body
    var body: some View{
        
        ZStack {
            //Main AR View
            ARViewContainer(startmode: startmode,updatemode: $updatemode,extraviewmode:$extraviewmode).ignoresSafeArea(.all, edges: .top)
                .alert(isPresented: $showmodeinformation){
                    ARappARpartmodel.generatemodeinform(mode: extraviewmode)
                }
            modeextraview
            ARUpdatetabView(startmode:startmode!,updatemode: $updatemode, extraviewmode: $extraviewmode)
            topleadingbuttons
            if !ARappARpart.Tipconfirmed{
                ARTipView()
            }
            //returnbutton
        }
        .environmentObject(Proportionalmodel)
        .environmentObject(Sequencemodel)
        .environmentObject(ARappARpart)
        .onAppear {
            print("ar Appear")
        }
        .onDisappear {
            print("ar disappear")
        }
    }
}
extension ARscanView{
    /// Extra view that depends on current scanning mode
    private var modeextraview:some View{
        ZStack{
            switch extraviewmode {
            case .Squarewavegenerator:SquarewaveextraView()
            case .Secondorder:SecondorderfilterextraView()
            case .Sequence:SequencegeneratorextraView()
            default:ZStack{Spacer()}
            }
        }
    }
    /// Button to show mode information alert
    private var topleadingbuttons:some View{
        ZStack{
            VStack{
                Button {
                    showmodeinformation=true
                } label: {
                        Image(systemName: "info.circle")
                        .foregroundColor(Color.accentColor)
                            .font(.title)
                }
//                Button {
//                    showmodeinformation=true
//                } label: {
//                        Image(systemName: "eye.square")
//                            .foregroundColor(Color.accentColor)
//                            .font(.title)
//                }
//                Button {
//                    showmodeinformation=true
//                } label: {
//                        Image(systemName: "photo")
//                            .foregroundColor(Color.accentColor)
//                            .font(.title)
//                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
}


//MARK: ARViewContainer
/// The main AR view
struct ARViewContainer: UIViewRepresentable {
    
    /// The AR mode when AR view starts
    let startmode:scanmode?
    @EnvironmentObject var appmodel:ARappARpartmodel
    @EnvironmentObject var Sequencemodel:Sequencegeneratormodel
    /// Temporal variable for updating AR mode
    @Binding var updatemode:scanmode?
    /// Temporal variable for updating AR mode
    @Binding var extraviewmode:scanmode
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        guard let scanmode=startmode else {
            return arView
        }
        
        //MARK: add lights
        appmodel.addlight()
        //MARK: add anchors
        appmodel.addanchor(ARview: arView,mode: scanmode)
        
        //MARK: enable direct gesture(translate,rotate,scale)
        appmodel.enablegesture(arView: arView, mode: scanmode)
        
        
        //MARK: define triggers
        appmodel.definetriggeractions(Sequencemodel: Sequencemodel)
        
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let mode=updatemode{
            //remove all anchors
            uiView.scene.anchors.removeAll()
            //add anchor according to update mode
            appmodel.addanchor(ARview: uiView,mode: mode)
            appmodel.enablegesture(arView: uiView,mode: mode)
            DispatchQueue.main.async {
                Sequencemodel.clear()
                extraviewmode=updatemode!
                updatemode=nil
            }
        }
        
    }
    
}
