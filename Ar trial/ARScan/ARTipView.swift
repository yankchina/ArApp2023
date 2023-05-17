//
//  ARTipView.swift
//  Ar trial
//
//  Created by niudan on 2023/4/10.
//

import SwiftUI
import RealityKit

struct ARTipView: View {
    @EnvironmentObject var appmodel:ARappARpartmodel
    var body: some View {
        ZStack{
            Color.secondary.opacity(0.8).ignoresSafeArea(.all)
            if !appmodel.ARapptipEntity[0].tipviewed {
                resetbuttontip
            }
            if !appmodel.ARapptipEntity[1].tipviewed {
                circuitdiagramtip
            }
            if !appmodel.ARapptipEntity[2].tipviewed {
                informbuttonplusswitchbuttontip
            }
            if !appmodel.ARapptipEntity[3].tipviewed {
                simulationtip
            }
        }.frame(maxWidth: .infinity,maxHeight: .infinity)
    }
}

extension ARTipView{
    var resetbuttontip:some View{
        GeometryReader{geometry in
            ZStack{
                VStack(spacing:.zero){
                    Text("Press the reset button to move model back to original location or to clear scanning traces(useful in plane detection while a improper plane is detected as anchor).")
                    Button{
                        appmodel.ARapptipEntity[0].tipviewed=true
                        appmodel.SaveTipData()
                        appmodel.Updatetipstatus()
                    }label: {
                        Text("OK").foregroundColor(.accentColor)
                    }
                }.frame(width: geometry.size.width/4)
                .background(RoundedRectangle(cornerRadius: 2).fill(Color.white.opacity(0.8)))
            }.frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
        }
        
    }
    var circuitdiagramtip:some View{
        GeometryReader{geometry in
            ZStack{
                VStack(spacing:.zero){
                    Text("Press the arrow.right button to see the circuit diagram, then freely magnify the image to adjust its size. While displaying circuit diagram, press the arrow.left button or drag the image left to hide the circuit diagram.")
                    Button {
                        appmodel.ARapptipEntity[1].tipviewed=true
                        appmodel.SaveTipData()
                        appmodel.Updatetipstatus()
                    } label: {
                        Text("OK").foregroundColor(.accentColor)
                    }
                }.frame(width: geometry.size.width/4)
                .background(RoundedRectangle(cornerRadius: 2).fill(Color.white.opacity(0.8)))
            }.frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)
        }
        
    }
    var informbuttonplusswitchbuttontip:some View{
        GeometryReader{geometry in
            ZStack{
                VStack(spacing:.zero){
                    Text("Press the info icon to see the description of the circuit, press the eye icon to switch to image detection, press the image icon to switch to image detection, the default detection mode is plane detection")
                    Button{
                        appmodel.ARapptipEntity[2].tipviewed=true
                        appmodel.SaveTipData()
                        appmodel.Updatetipstatus()
                    }label: {
                        Text("OK").foregroundColor(.accentColor)
                    }
                }.frame(width:geometry.size.width/4)
                .background(RoundedRectangle(cornerRadius: 2).fill(Color.white.opacity(0.8)))
            }.frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topTrailing)
        }
        
    }
    var simulationtip:some View{
        GeometryReader{geometry in
            ZStack{
                VStack(spacing:.zero){
                    Text("This is the simulation area, please ensure the parameters are proper.")
                    Button {
                        appmodel.ARapptipEntity[3].tipviewed=true
                        appmodel.SaveTipData()
                        appmodel.Updatetipstatus()
                    }label: {
                        Text("OK").foregroundColor(.accentColor)
                    }
                }.frame(width:geometry.size.width/4)
                .background(RoundedRectangle(cornerRadius: 2).fill(Color.white.opacity(0.8)))
            }.frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottomTrailing)
        }
        
    }
}

struct ARTipView_Previews: PreviewProvider {
    static var previews: some View {
        ARTipView()
    }
}
