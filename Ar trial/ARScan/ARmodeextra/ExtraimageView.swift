//
//  ExtraimageView.swift
//  Ar trial
//
//  Created by niudan on 2023/4/6.
//

import SwiftUI
import RealityKit

struct ExtraimageView:View{
    @Binding var display:Bool
    var geometry:GeometryProxy
    @Binding var Imagemagnifyamount:CGFloat
    @Binding var Imagemagnifylastamount:CGFloat
    let extraimage:Image
    
    
    var body: some View{
        HStack(spacing: .zero){
            VStack {
                if !display{
                    Button {
                        display.toggle()
                    } label: {
                        Image(systemName: display ? "chevron.left.circle":"chevron.right.circle")
                            .foregroundColor(Color.accentColor)
                            .font(.title)
                    }
                }else{
                    HStack(spacing: .zero){
                        extraimage.resizable().scaledToFit()
                            .gesture(
                                DragGesture()
                                    .onChanged { value in}
                                    .onEnded { value in
                                        withAnimation(.spring()) {
                                            if value.translation.width < -20 {
                                                display.toggle()
                                                Imagemagnifylastamount = 0
                                                Imagemagnifyamount = 0
                                            }
                                        }
                                    }
                            )
                            .gesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        withAnimation(.spring()) {
                                            Imagemagnifyamount = value - 1
                                        }
                                    }
                                    .onEnded { value in
                                        withAnimation(.spring()) {
                                            Imagemagnifylastamount += Imagemagnifyamount
                                            Imagemagnifyamount = 0
                                        }
                                    }
                            )
                        Button {
                            display.toggle()
                            Imagemagnifylastamount = 0
                            Imagemagnifyamount = 0
                        } label: {
                            Image(systemName: "chevron.left.circle")
                                .foregroundColor(Color.accentColor)
                                .font(.title)
                        }.controlSize(.large)
                        //.background(RoundedRectangle(cornerRadius: 2).fill(Color.white.opacity(0.75)).frame(height:geometry.size.height*0.2*(1 + Imagemagnifylastamount + Imagemagnifyamount)))
                    }
                    
                    //.background(RoundedRectangle(cornerRadius: 2).fill(Color.white.opacity(0.75)).frame(height:geometry.size.height*0.2*(1 + Imagemagnifylastamount + Imagemagnifyamount)))
                }
            }
            Spacer()
        }.frame(height:geometry.size.height*0.4*(1 + Imagemagnifylastamount + Imagemagnifyamount))
            .frame(maxHeight:geometry.size.height*0.5)
    }
}

//struct ExtraimageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExtraimageView()
//    }
//}
