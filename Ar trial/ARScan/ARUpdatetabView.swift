//
//  ARUpdatetabView.swift
//  Ar trial
//
//  Created by niudan on 2023/3/26.
//

import SwiftUI

//MARK: UpdatetabView
/// Update tab
struct ARUpdatetabView:View{
    @ObservedObject var appmodel:ARappARpartmodel
    @EnvironmentObject var Usermodel:Appusermodel
    /// Circuit mode while starting ARView
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
                                ForEach(appmodel.scaaningmodes) { Scanmodeforvm in
                                    HStack(spacing:.zero){
                                        Rectangle().fill(Color.secondary.opacity(0.5))
                                            .frame(width:1)
                                        Button{
                                            updatemode=Scanmodeforvm.mode
                                        }label: {
                                            ZStack{
                                                Text(
                                                    Usermodel.Language ?
                                                    Scanmodeforvm.mode == extraviewmode ?
                                                    Scanmodeforvm.mode.RawValuebyLanguage(Language: Usermodel.Language).appending(Usermodel.Language ? "(现在)" : " (Current)")
                                                    :
                                                        Scanmodeforvm.mode.RawValuebyLanguage(Language: Usermodel.Language)
                                                    :
                                                        Scanmodeforvm.mode == extraviewmode ?
                                                        Scanmodeforvm.mode.rawValue.appending(Usermodel.Language ? "(现在)" : " (Current)")
                                                        :
                                                            Scanmodeforvm.mode.rawValue
                                                )
                                                    .foregroundColor(Scanmodeforvm.mode == extraviewmode ? Color.accentColor:Color.primary)
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
