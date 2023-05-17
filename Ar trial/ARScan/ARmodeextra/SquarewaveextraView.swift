//
//  SquarewaveView.swift
//  Ar trial
//
//  Created by niudan on 2023/4/18.
//

import SwiftUI
import Combine
import RealityKit
enum ARSimulationextraviewstatus:Int {
    case start=0
    case input=1
    case image=2
}
//MARK: ARsquarewavemodel
class ARsquarewavemodel: ObservableObject {
    @Published var stoptime:Double
    @Published var stoptimetext:String
    @Published var RT:Double
    @Published var CT:Double
    @Published var VCC:Double
    @Published var R1:Double
    @Published var R2:Double
    @Published var R3:Double
    @Published var Simulationurl:URL?
    @Published var requestcount:Int
    @Published var status:ARSimulationextraviewstatus
    @Published var inputwindowyoffset:CGFloat
    @Published var imageyoffset:CGFloat
    @Published var imagezoom:Bool
    var imagezoomratio: CGFloat{return imagezoom ? 1.5:1}
    var cancellables = Set<AnyCancellable>()
    
    init() {
        stoptime=0.01
        stoptimetext="0.01"
        RT=1
        CT=1
        VCC=5
        R1=100
        R2=100
        R3=100
        requestcount=0
        status = .start
        inputwindowyoffset=0
        imageyoffset=0
        imagezoom=false
        //getValues()
    }
    func statusforward()->Void{
        status=ARSimulationextraviewstatus(rawValue: status.rawValue+1) ?? ARSimulationextraviewstatus(rawValue: 0)!
    }
    func statusbackward()->Void{
        status=ARSimulationextraviewstatus(rawValue: status.rawValue-1) ?? ARSimulationextraviewstatus(rawValue: 0)!
    }
    func startforward()->Void{statusforward()}
    func inputforward(userurl:String)->Void{
        stoptime=Double(stoptimetext)!
        requestcount += 1
        Simulationurl=URL(string:"http://"+userurl+"/AR/Simulation/squarewave?stoptime=\(stoptime)&RT=\(RT)&CT=\(CT)&VCC=\(VCC)&R1=\(R1)&R2=\(R2)&R3=\(R3)&requestcount=\(requestcount)")
        statusforward()
    }
    func inputbackward()->Void{statusbackward()}
    func imagebackward()->Void{statusbackward()}
    func imageforward()->Void{statusforward()}
    func imagerefresh(userurl:String)->Void {
        requestcount += 1
        Simulationurl=URL(string:"http://"+userurl+"/AR/Simulation/squarewave?stoptime=\(stoptime)&RT=\(RT)&CT=\(CT)&VCC=\(VCC)&R1=\(R1)&R2=\(R2)&R3=\(R3)&requestcount=\(requestcount)")
    }
    func Valuelegal()->Bool{
        guard let stoptimevalue=Double(stoptimetext)else{return false}
        return stoptimevalue > 0
    }
        
}

//MARK: SquarewaveView
struct SquarewaveextraView: View {
//    @EnvironmentObject var Usermodel:Appusermodel
    @StateObject var Usermodel=Appusermodel()
    @StateObject var vm = ARsquarewavemodel()
    @State var testonly:CGFloat = 100


    var body: some View {
        GeometryReader{geometry in
            let Geometrysize=geometry.size
            switch vm.status {
            case .start:
                //MARK: Start status view
                Startbutton(-Geometrysize.height*0.08)
                
                
                
                //MARK: Input status view
            case .input:
                ZStack{
                    VStack(alignment:.trailing,spacing:.zero){
                        VStack(alignment:.trailing,spacing:.zero){
                            InputupperLabel(backwardButtonaction: vm.inputbackward)
                            StoptimeTextField(leadingtext: "stoptime", Stoptimetext: $vm.stoptimetext, unittext: "s", TextfieldWidth: Geometrysize.width/8,TextFieldKeyboardTyperawValue: 2)
                            InputSlider(leadingtext: "RT:", Slidervalue: $vm.RT, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                            InputSlider(leadingtext: "CT:", Slidervalue: $vm.CT, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "𝛍F")
                            InputSlider(leadingtext: "VCC:", Slidervalue: $vm.VCC, minimumValue: 1, maximumValue: 15, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "V")
                            InputSlider(leadingtext: "R1:", Slidervalue: $vm.R1, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                            InputSlider(leadingtext: "R2:", Slidervalue: $vm.R1, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                            InputSlider(leadingtext: "R3:", Slidervalue: $vm.R1, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                        }.frame(width:Geometrysize.width*0.35)
                            .padding(.horizontal,1)
                        InputConfirmButton(Buttondisable: !vm.Valuelegal()){
                            vm.inputforward(userurl: Usermodel.user.simulationurl)
                            Usermodel.SimulationImagedisplay()
                        }
                    }.frame(width:geometry.size.width*0.35)
                        .background(
                            InputbackgroundView()
                        )
                        .offset(y:-Geometrysize.height*0.08)
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
                        .offset(y:-geometry.size.height*0.08+vm.imageyoffset)

                    //.frame(maxWidth: geometry.size.width*0.9)
                        .gesture(
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
                        )
                }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomTrailing)
            }
        }
        .onReceive(Usermodel.Timereveryonesecond, perform: Usermodel.SimulationImageRefreshCountdown)
    }
    
    @ViewBuilder
    func Startbutton(_ yoffset:CGFloat)->some View{
        ZStack{
            Button(action: vm.startforward) {
                Text("Simulation")
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 2))
            .offset(y:yoffset)
        }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomTrailing)
    }
    
    
    
}
