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
    var body: some View {
        VStack{
            HStack{
                Spacer()
                if let name=extraviewmode.Imagename(){
                    Image(name)
                        .resizable().scaledToFit()
                        .frame(width:
                                ispresent ? imagemagnify ? Geometrysize.width/2*magnifyratio : Geometrysize.width/2 : 0
                        )
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                imagemagnify.toggle()
                            }
                        }
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
                .frame(width:
                        ispresent ? imagemagnify ? Geometrysize.width/2*magnifyratio : Geometrysize.width/2 : 0
                       )
        }
        .ignoresSafeArea(.all, edges: .top)
    }
}

