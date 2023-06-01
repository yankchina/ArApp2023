//
//  VoltageregulatorextraView.swift
//  Ar trial
//
//  Created by niudan on 2023/5/24.
//

import SwiftUI

struct VoltageregulatorextraView: View {
    //View properties
    @EnvironmentObject var Usermodel:Appusermodel
    @StateObject var vm = ARvoltageregulatormodel()
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
                StartButton(yoffset: -Geometrysize.height*Usermodel.Circuitupdatetabheightratio,Buttonaction: vm.startforward)
            case .input:
                ZStack{
                    VStack(alignment:.trailing,spacing:.zero){
                        VStack(alignment:.trailing,spacing:.zero){
                            InputupperLabel(backwardButtonaction: vm.inputbackward)
                            Group{
                                InputSlider(leadingtext: "R2:", Slidervalue: $vm.R2, minimumValue: 0.1, maximumValue: 1, SlidervalueStep: 0.01, ValueLabelDecimalplaces: 2, unittext: "k𝛀")
                                InputSlider(leadingtext: "UD1:", Slidervalue: $vm.UD1, minimumValue: 1, maximumValue: 5, SlidervalueStep: 0.1, ValueLabelDecimalplaces: 1, unittext: "V")
                            }
                        }.frame(width:geometry.size.width*0.35)
                            .padding(.horizontal,1)
                        InputConfirmButton(Buttondisable: !vm.Valuelegal()){
                            vm.inputforward(userurl: Usermodel.user.simulationurl)
                            Usermodel.SimulationImagedisplay()
                        }
                    }.frame(width:geometry.size.width*0.35)
                        .background(
                            InputbackgroundView()
                        )
                        .offset(y: -geometry.size.height*Usermodel.Circuitupdatetabheightratio)
                        .gesture(
                            DragGesture()
                                    .onEnded { value in
                                        if value.translation.height > 20 {
                                            vm.inputbackward()
                                        }
                                    }
                        )
                        
                }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomTrailing)
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
                        )
                }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomTrailing)

                
            }
        }
        .onReceive(Usermodel.Timereveryonesecond, perform: Usermodel.SimulationImageRefreshCountdown)
        
    }
}

