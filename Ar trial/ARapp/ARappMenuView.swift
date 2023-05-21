//
//  ARMenuView.swift
//  Ar trial
//
//  Created by niudan on 2023/3/20.
//

import SwiftUI
import AVFoundation
import AVKit

//MARK: Appmenuview
/// App menu
struct ARappmenuView: View {
    /// Navigationlinks modes
    let scaaningmodes:[scanmode]=[.free,
                                  .Squarewavegenerator,
                                  .SquarewaveDRgenerator,
                                  .Secondorder,
                                  .Sequence,
                                  .Proportional]
    @EnvironmentObject var Usermodel:Appusermodel

    @StateObject var ARappMaterialpart:ARappMaterialpartmodel=ARappMaterialpartmodel()
    var body: some View {
        
        GeometryReader{geometry in
            List{
                //MARK: ARscan section placement
                Scansection
                

               
                
                //MARK: Material section placement
                Materialsection
                
                NavigationLink(destination: OnlineTaskView()) {
                    Text(Usermodel.Language ? "任务" : "Tasks").font(.title2)
                }
                NavigationLink(destination:
                                ZStack{}
                                .onAppear(perform: Usermodel.logout)
                ) {
                    Text(Usermodel.Language ? "登出" : "Log out")
                        .font(.title2)
                        .padding(5)
                        .foregroundColor(Color.BackgroundprimaryColor)
                        .background(Color.red.cornerRadius(3))
                }

//                Button(action: Usermodel.logout) {
//                    Text("Log out")
//                }
//                .buttonStyle(.borderedProminent)
//                .buttonBorderShape(.roundedRectangle(radius: 3))
//                .accentColor(Color.red)
                
//                  NavigationLink(
//                    destination:
//                        VideoPlayer(player: .init(url: URL(fileURLWithPath:
//                                                            Bundle.main.path(forResource: "ARtrial", ofType: "mp4") ?? Bundle.main.path(forResource: "ARtrial", ofType: "mp4")!)
//                                                 )
//                                   )
//                        .ignoresSafeArea(.all, edges: .top)
//                  ) {
//                      Text("Tutorial Video").font(.title2)
//                  }.padding(.vertical,10)
            }
            .navigationTitle(Usermodel.Language ? "主页" : "Menu")
            .toolbar{
                //Leading image to switch between two servers
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Picker(selection: $Usermodel.user.simulationurl){
                        ForEach(Usermodel.Urladdress.indices,id:\.self){index in
                            Image(systemName: "\(index).circle")
                                .foregroundColor(Color.accentColor)
                                .tag(Usermodel.Urladdress[index])
                        }
                    } label: {
                        Image(systemName: "network")
                            .foregroundColor(Color.accentColor)
                    }
                    .pickerStyle(.menu)
                    .padding(.trailing, 5)
                    //Button to switch language
                    Toggle(isOn: $Usermodel.Language) {
                        Text("")
                    }
                    .toggleStyle(.switch)

                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("SEUlogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height:geometry.size.height*0.05)
                }

            }
        }
    }
}

//MARK: Material section definition
extension ARappmenuView{
    
    
    /// Navigationlinks to all ARscan views
    private var Scansection:some View{
        Section(header: Text(Usermodel.Language ? "增强现实模块" : "ARscan").font(.title)) {
            ForEach(scaaningmodes.indices,id:\.self) { index in
                NavigationLink(destination: ARscanView(startmode:scaaningmodes[index],extraviewmode: scaaningmodes[index])) {
                    Text(
                        scaaningmodes[index].RawValuebyLanguage(Language: Usermodel.Language)
                    )
                        .font(.title2)
                }
//                .background(Color.BackgroundprimaryColor)

            }
        }
    }
    /// Navigationlinks to all Material views
    private var Materialsection:some View{
        Section(header: Text(Usermodel.Language ? "资料" : "Material").font(.title)) {
            ForEach(ARappMaterialpart.Material.indices,id:\.self) { index in
                NavigationLink(destination: ARappMaterialview(chapter: index, appmodel: ARappMaterialpart)) {
                    Text("Ch\(index)").font(.title2).bold()
                    if ARappMaterialpart.chapterviewed[index]{
                        Text(Usermodel.Language ?
                             "(上次看到:第\(ARappMaterialpart.imageprogress[index]))页" :
                                "(last viewing:page\(ARappMaterialpart.imageprogress[index]))"
                        ).font(.title3)
                    }
                }
                // Set image progress and chapter viewed from AppStorage and coredata
                .onAppear {
                    
                    if let object=UserDefaults.standard.object(forKey: "chapterprogress\(index)") {
                        ARappMaterialpart.imageprogress[index]=object as! Int
                    }
                    for index in ARappMaterialpart.chapterviewed.indices {
                        ARappMaterialpart.chapterviewed[index]=ARappMaterialpart.ARappchapterEntity[index].chapterviewed
                    }
                }
            }
        }
        
    }
    
    
}

////MARK: Scan section definition
//struct scansectionView: View {
//    @EnvironmentObject var appmodel:ARappmodel
//    let geometry:GeometryProxy
//    var body: some View {
//        Section(header: Text("ARscan")) {
//            ForEach(appmodel.scaaningmodes.indices) { index in
//                HStack {
//                    Text(appmodel.scaaningmodes[index].relatedtext)
//                        .font(.title2)
//                    Spacer()
//                    HStack {
//                        Image(systemName: "chevron.right.circle")
//                            .font(.title2)
//                            .foregroundColor(Color("arrowcolor1"))
//                            .padding(.trailing)
//
//                    }.onTapGesture{
//                        appmodel.currentscanmode=appmodel.scaaningmodes[index]
//                        appmodel.ARscanning=true
//                      }
//                }
//            }
//        }
//        .fullScreenCover(isPresented: $appmodel.ARscanning) {
//            ARscanView(startmode: appmodel.currentscanmode,extraviewmode:appmodel.currentscanmode)
//        }
//    }
//}

struct ARappView_Previews: PreviewProvider {
    static var previews: some View {
        ARappmenuView()
            
    }
}
