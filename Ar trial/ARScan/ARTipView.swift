//
//  ARTipView.swift
//  Ar trial
//
//  Created by niudan on 2023/4/10.
//

import SwiftUI
//import RealityKit

/// Tips when first entering ARView
struct ARTipView: View {
    @ObservedObject var appmodel:ARappARpartmodel
    @EnvironmentObject var Usermodel:Appusermodel

    var body: some View {
        ZStack{
            Color.gray.ignoresSafeArea(.all)
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
                    Text(Usermodel.Language ? "现在" : "Press the reset button to move model back to original location or to clear scanning traces(useful in plane detection while a improper plane is detected as anchor).")
                    Button{
                        appmodel.ARapptipEntity[0].tipviewed=true
                        appmodel.SaveTipData()
                        appmodel.Updatetipstatus()
                    }label: {
                        Text(Usermodel.Language ? "好的" : "OK").foregroundColor(.accentColor)
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
                    Text(Usermodel.Language ? "点击按钮查看电路理论图，图片可缩放。再次点击按钮即可收起电路理论图" : "Press the arrow.right button to see the circuit diagram, then freely magnify the image to adjust its size. While displaying circuit diagram, press the arrow.left button or drag the image left to hide the circuit diagram.")
                    Button {
                        appmodel.ARapptipEntity[1].tipviewed=true
                        appmodel.SaveTipData()
                        appmodel.Updatetipstatus()
                    } label: {
                        Text(Usermodel.Language ? "好的" : "OK").foregroundColor(.accentColor)
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
                    Text(Usermodel.Language ? "点击信息按钮查看电路简介图" : "Press the info icon to see the description of the circuit")
                    Button{
                        appmodel.ARapptipEntity[2].tipviewed=true
                        appmodel.SaveTipData()
                        appmodel.Updatetipstatus()
                    }label: {
                        Text(Usermodel.Language ? "好的" : "OK").foregroundColor(.accentColor)
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
                    Text(Usermodel.Language ? "这里是电路仿真区域，点击仿真按钮即可开始。" : "This is the simulation area, please ensure the parameters are proper.")
                    Button {
                        appmodel.ARapptipEntity[3].tipviewed=true
                        appmodel.SaveTipData()
                        appmodel.Updatetipstatus()
                    }label: {
                        Text(Usermodel.Language ? "好的" : "OK").foregroundColor(.accentColor)
                    }
                }.frame(width:geometry.size.width/4)
                .background(RoundedRectangle(cornerRadius: 2).fill(Color.white.opacity(0.8)))
            }.frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottomTrailing)
        }
        
    }
}
