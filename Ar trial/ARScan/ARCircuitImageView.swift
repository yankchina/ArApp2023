//
//  ARCircuitImageView.swift
//  Ar trial
//
//  Created by niudan on 2023/5/22.
//

import SwiftUI

struct ARCircuitImageView: View {
    @ObservedObject var appmodel:ARappARpartmodel
    @Binding var extraviewmode:scanmode
    @Binding var ispresent:Bool
    let Geometrysize:CGSize
    let magnifyratio:CGFloat=1.5
    @State var imagemagnify:Bool=false
    /// Animation type to toggle ispresent
    let PresentToggleAnimation:Animation?
    
    /// Width of circuit image,   =0 when !ispresent, =normal size when (ispresent && !imagemagnify)
    /// ,=large size when (ispresent && imagemagnify)
    var Imagewidth:CGFloat{
        ispresent ? imagemagnify ? Geometrysize.width/2*magnifyratio : Geometrysize.width/2 : 0
    }
    
    /// DragGesture of circuit image, horizontal right dragging and
    /// vertical upper dragging hides the image
    var CircuitImageDraggesture:some Gesture{
        DragGesture()
            .onEnded { value in
                let dragsize=value.translation
                if dragsize.width > 50 || dragsize.height < -50 {
                    withAnimation(PresentToggleAnimation) {
                        ispresent.toggle()
                    }
                }
            }
    }
    var body: some View {
        VStack{
            HStack{
                Spacer()
                if let name=extraviewmode.Imagename(){
                    Image(name)
                        .resizable().scaledToFit()
                        .frame(width:Imagewidth)
                        .opacity(ispresent ? 1 : 0.2)
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                imagemagnify.toggle()
                            }
                        }
                        .gesture(CircuitImageDraggesture)
                }else{
                    
                }
            }
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .safeAreaInset(edge: .top, alignment:.trailing,spacing: 0) {
            VStack(spacing: .zero){
                Rectangle().opacity(0)
                    .frame(height:Geometrysize.height*0.04)
            }
                .frame(width:Imagewidth)
        }
        .ignoresSafeArea(.all, edges: .top)
    }
}

