//
//  SquarewaveDRextraView.swift
//  Ar trial
//
//  Created by niudan on 2023/4/20.
//

import SwiftUI
import Combine


struct SquarewaveDRextraView: View {
    //View properties
    @EnvironmentObject var Usermodel:Appusermodel
    @StateObject var vm = ARsquarewaveDRmodel()
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
                StartButton(yoffset: -Geometrysize.height*0.08,Buttonaction: vm.startforward)
            case .input:
                ZStack{
                    VStack(alignment:.trailing,spacing:.zero){
                        VStack(alignment:.trailing,spacing:.zero){
                            InputupperLabel(backwardButtonaction: vm.inputbackward)
                            Group{
                                StoptimeTextField(leadingtext: Usermodel.Language ? "仿真截止时间" : "stoptime",
                                                  Stoptimetext: $vm.stoptimetext, unittext: "s", TextfieldWidth: Geometrysize.width/8,
                                                  TextFieldKeyboardTyperawValue: 2
                                )
                                InputSlider(leadingtext: "RT:", Slidervalue: $vm.RT, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                                InputSlider(leadingtext: "CT:", Slidervalue: $vm.CT, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "𝛍F")
                                InputSlider(leadingtext: "Uz:", Slidervalue: $vm.Uz, minimumValue: 1, maximumValue: 15, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "V")
                                InputSlider(leadingtext: "RW:", Slidervalue: $vm.RW, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                                InputSlider(leadingtext: "RWRatio:", Slidervalue: $vm.RWRatio, minimumValue: 0, maximumValue: 1, SlidervalueStep: 0.01, ValueLabelDecimalplaces: 2, unittext: "")
                            }
                            InputSlider(leadingtext: "R1:", Slidervalue: $vm.R1, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                            InputSlider(leadingtext: "R2:", Slidervalue: $vm.R2, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
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
                        .offset(y:-geometry.size.height*0.08)
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
                        )                    //.frame(maxWidth: geometry.size.width*0.9)
                        .offset(y: vm.imageyoffset-geometry.size.height*0.08)
                        .gesture(
                            AsyncImageDraggesture
                        )
                }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomTrailing)

                
            }
        }
        .onReceive(Usermodel.Timereveryonesecond, perform: Usermodel.SimulationImageRefreshCountdown)
        
    }
}

struct SquarewaveDRextraView_Previews: PreviewProvider {
    static var previews: some View {
        SquarewaveDRextraView()
    }
}
