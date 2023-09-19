//
//  SquarewaveView.swift
//  Ar trial
//
//  Created by niudan on 2023/4/18.
//

import SwiftUI
import Combine
import RealityKit
//MARK: SquarewaveView
struct SquarewaveextraView: View {
    
    //View properties
    @EnvironmentObject var Usermodel:Appusermodel
    @StateObject var vm = ARsquarewavemodel()
    @State var testonly:CGFloat = 100
    
    //View gestures
    var AsyncImageDraggesture:some Gesture{
        DragGesture()
                .onChanged { value in
                    if value.translation.height > 0 {
                        vm.imageyoffset=value.translation.height
                    }
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        if value.translation.height > 20 {
                            vm.imageforward()
                        }
                        vm.imageyoffset=0
                    }
                }
    }

    var body: some View {
        GeometryReader{geometry in
            let Geometrysize=geometry.size
            switch vm.status {
            case .start:
                //MARK: Start status view
                StartButton(
                    yoffset: -Geometrysize.height*Usermodel.Circuitupdatetabheightratio,
                    Buttonaction: vm.startforward
                )
                
                
                
                //MARK: Input status view
            case .input:
                ZStack{
                    VStack(alignment:.trailing,spacing:.zero){
                        VStack(alignment:.trailing,spacing:.zero){
                            InputupperLabel(backwardButtonaction: vm.inputbackward)
                            StoptimeTextField(leadingtext: Usermodel.Language ? "仿真截止时间" : "stoptime", Stoptimetext: $vm.stoptimetext, unittext: "s", TextfieldWidth: Geometrysize.width/8,TextFieldKeyboardTyperawValue: 2)
                            InputSlider(leadingtext: "RT:", Slidervalue: $vm.RT, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                            InputSlider(leadingtext: "CT:", Slidervalue: $vm.CT, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "𝛍F")
                            InputSlider(leadingtext: "VCC:", Slidervalue: $vm.VCC, minimumValue: 1, maximumValue: 15, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "V")
                            InputSlider(leadingtext: "R1:", Slidervalue: $vm.R1, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                            InputSlider(leadingtext: "R2:", Slidervalue: $vm.R2, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                            InputSlider(leadingtext: "R3:", Slidervalue: $vm.R3, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                        }.frame(width:Geometrysize.width*0.35)
                            .padding(.horizontal,1)
                        InputConfirmButton(Buttondisable: !vm.Valuelegal()){
                            vm.inputforward(userurl: Usermodel.user.simulationurl)
                            Usermodel.SimulationImagedisplay()
                            if let newkey=vm.Simulationurlstring,
                               Usermodel.manager.get(key: newkey) == nil{
                                let imagekey=vm.Simulationurlstringwithparamater ?? ""
                                Usermodel.downloadImage(
                                    Imageurl: newkey,
                                    imagekey: imagekey,
                                    mode: .Squarewavegenerator
                                )
                            }
                        }
                    }.frame(width:geometry.size.width*0.35)
                        .background(
                            InputbackgroundView()
                        )
                        .offset(y:-Geometrysize.height*Usermodel.Circuitupdatetabheightratio)
                    .gesture(
                        DragGesture()
                                .onChanged { value in}
                                .onEnded { value in
                                    if value.translation.height > 20 {
                                        vm.inputbackward()
                                    }
                                }
                    )
                }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomTrailing)
                
                
                //MARK: Image status view
            case .image:
                ZStack{
                    VStack(spacing:.zero){
                        SimulationImageupperLabel(RefreshButtondisable: Usermodel.SimulationimageRefreshDisable, imagezoom: vm.imagezoom, backwardButtonaction: vm.imagebackward) {
                            vm.imagerefresh(userurl: Usermodel.user.simulationurl)
                            Usermodel.SimulationimageRefreshDisable=true
                        } zoomButtonaction: {
                            withAnimation(Animation.spring()) {vm.imagezoom.toggle()}
                        }
                        Divider()
                        if let imageurl=vm.Simulationurl{
                            AsyncImage(url: imageurl) { phase in
                                switch phase {
                                case .empty:
                                    ZStack{
                                        ProgressView()
                                    }.frame(width: geometry.size.width/4*vm.imagezoomratio, height: geometry.size.width/4*vm.imagezoomratio)
                                case .success(let returnedImage):
                                    returnedImage
                                        .resizable()
                                        .aspectRatio(nil, contentMode: .fit)
                                        .cornerRadius(3)
                                        .onAppear {
                                            Usermodel.Receivedate=Date()
                                            print(Usermodel.Receivedate.timeIntervalSince(Usermodel.Actiondate))
                                        }
                                case .failure:
                                    ZStack{
                                        Image(systemName: "questionmark")
                                            .font(.headline)
                                    }.frame(width: geometry.size.width/4, height: geometry.size.width/4)
                                default:
                                    Image(systemName: "questionmark")
                                        .font(.headline)
                                }
                            }
                        }
                    }.frame(width: geometry.size.width/2*vm.imagezoomratio)
                        .padding(.horizontal,1)
                        .background(
                            SimulationImagebackgroundView()
                        )
                        .offset(y:-geometry.size.height*Usermodel.Circuitupdatetabheightratio+vm.imageyoffset)

                    //.frame(maxWidth: geometry.size.width*0.9)
                        .gesture(
                            AsyncImageDraggesture
//                            DragGesture()
//                                    .onChanged { value in
//                                        if value.translation.height > 0 {
//                                            vm.imageyoffset=value.translation.height
//                                        }
//                                    }
//                                    .onEnded { value in
//                                        withAnimation(.spring()) {
//                                            if value.translation.height > 20 {
//                                                vm.imageforward()
//                                            }
//                                            vm.imageyoffset=0
//                                        }
//                                    }
                        )
                }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomTrailing)
            }
        }
        .onReceive(Usermodel.Timereveryonesecond, perform: Usermodel.SimulationImageRefreshCountdown)
    }
    
    
}
