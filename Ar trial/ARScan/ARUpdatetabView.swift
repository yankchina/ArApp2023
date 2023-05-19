//
//  ARUpdatetabView.swift
//  Ar trial
//
//  Created by niudan on 2023/3/26.
//

import SwiftUI

//MARK: UpdatetabView
struct ARUpdatetabView:View{
    @ObservedObject var appmodel:ARappARpartmodel
    let startmode:scanmode
    @Binding var updatemode:scanmode?
    @Binding var extraviewmode:scanmode
    var body: some View{
        GeometryReader{geometry in
            ZStack{
                VStack(spacing: .zero){
                    Spacer()
                    Rectangle().fill(.primary).frame( height: 1).frame(maxWidth: .infinity)
                    //Scroll Hstack containing buttons to adjust scanning mode
                    ScrollView(.horizontal, showsIndicators: false){
                        ScrollViewReader{proxy in
                            LazyHStack(spacing:.zero){
                                ForEach(appmodel.scaaningmodes.indices,id:\.self) { index in
                                    HStack(spacing:.zero){
                                        if index == 0 {
                                            Rectangle().fill(Color.secondary.opacity(0.5))
                                                .frame(width:1)
                                        }
                                        Button{
                                            updatemode=appmodel.scaaningmodes[index]
                                        }label: {
                                            ZStack{
                                                
                                                Text(appmodel.scaaningmodes[index] == extraviewmode ?  appmodel.scaaningmodes[index].rawValue.appending(" (Current)"):appmodel.scaaningmodes[index].rawValue)
                                                    .foregroundColor(appmodel.scaaningmodes[index] == extraviewmode ? Color.accentColor:Color.primary)
                                            }.frame(width:geometry.size.width*0.3)
                                        }.controlSize(.large)
                                        .frame(width:geometry.size.width*0.3)
                                        Rectangle().fill(Color.secondary.opacity(0.5))
                                            .frame(width:1)
                                    }
                                }
                            }.frame(height:geometry.size.height*0.08)
                                .onAppear {
                                    if let modeindex=appmodel.scanmodeindex[startmode]{
                                        proxy.scrollTo(modeindex+1, anchor: .center)
                                    }
                                }
                        }
                    }.background(Color.BackgroundprimaryColor.frame(maxWidth: .infinity))
                }
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity,alignment:.bottomLeading)
        }
        
    }
}

//struct ARUpdatetabView_Previews: PreviewProvider {
//    static var previews: some View {
//        ARUpdatetabView()
//    }
//}
