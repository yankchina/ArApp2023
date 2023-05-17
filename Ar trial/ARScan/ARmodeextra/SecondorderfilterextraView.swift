//
//  ARSecondorderfilterextraView.swift
//  Ar trial
//
//  Created by niudan on 2023/4/20.
//

import SwiftUI
import Combine

//MARK: ARsquarewaveDRmodel
class ARSecondorderfiltermodel: ObservableObject {
    @Published var R1:Double
    @Published var R2:Double
    @Published var R3:Double
    @Published var R4:Double
    @Published var R5:Double
    @Published var R6:Double
    @Published var RF:Double
    @Published var CF:Double
    @Published var Simulationurl:URL?
    @Published var requestcount:Int
    @Published var status:ARSimulationextraviewstatus
    @Published var inputwindowyoffset:CGFloat
    @Published var imageyoffset:CGFloat
    @Published var imagezoom:Bool
    var imagezoomratio: CGFloat{return imagezoom ? 1.5:1}
    var cancellables = Set<AnyCancellable>()
    
    init() {
        R1=10
        R2=100
        R3=100
        R4=10
        R5=1.1
        R6=10
        RF=16
        CF=0.01
        requestcount=0
        status = .start
        inputwindowyoffset=0
        imageyoffset=0
        imagezoom=false
        //getValues()
    }
    func statusforward()->Void{
        if let newstatus=ARSimulationextraviewstatus(rawValue: status.rawValue+1){
            status=newstatus
        }else{
            status=ARSimulationextraviewstatus(rawValue: 0)!
        }
    }
    func statusbackward()->Void{
        if let newstatus=ARSimulationextraviewstatus(rawValue: status.rawValue-1){
            status=newstatus
        }else{
            status=ARSimulationextraviewstatus(rawValue: 0)!
        }
    }
    func startforward()->Void{statusforward()}
    func inputforward(userurl:String)->Void{
        requestcount += 1
        Simulationurl=URL(string: "http://"+userurl+"/AR/Simulation/Secondorderfilter?R1=\(R1)&R2=\(R2)&R3=\(R3)&R4\(R4)&R5=\(R5)&R6=\(R6)&RF=\(RF)&CF=\(CF)&requestcount=\(requestcount)")
        statusforward()
    }
    func inputbackward()->Void{statusbackward()}
    func imagebackward()->Void{statusbackward()}
    func imageforward()->Void{statusforward()}
    func imagerefresh(userurl:String)->Void {
        requestcount += 1
        Simulationurl=URL(string: "http://"+userurl+"/AR/Simulation/Secondorderfilter?R1=\(R1)&R2=\(R2)&R3=\(R3)&R4\(R4)&R5=\(R5)&R6=\(R6)&RF=\(RF)&CF=\(CF)&requestcount=\(requestcount)")
    }
    func Valuelegal()->Bool{
        return true
    }
        
}
struct SecondorderfilterextraView: View {
    @EnvironmentObject var Usermodel:Appusermodel
    @StateObject var vm = ARSecondorderfiltermodel()
    
    var body: some View {
        GeometryReader{geometry in
            switch vm.status {
            case .start:
                ZStack{
                    Button(action: vm.startforward) {
                        Text("Simulation")
                    }.buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle(radius: 2))
                        .offset(y:-geometry.size.height*0.08)

                }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomTrailing)
            case .input:
                ZStack{
                    VStack(alignment:.trailing,spacing:.zero){
                        VStack(alignment:.trailing,spacing:.zero){
                            HStack{
                                Button(action: vm.inputbackward) {
                                    Image(systemName: "chevron.down")
                                        .font(.title2)
                                }
                                Spacer()
                            }.padding(.bottom,5)
                            Group{
                                HStack{
                                    Text("R1:")
                                    Slider(value: $vm.R1, in: 1...100, step: 1, label: {Text("R1")}, minimumValueLabel: {Text("1")}, maximumValueLabel: {Text("100")}) { _ in}
                                    Text(String(format: "%.0f", vm.R1).appending("k𝛀"))
                                }.padding(.vertical,5)
                                HStack{
                                    Text("R2:")
                                    Slider(value: $vm.R2, in: 1...1000, step: 1, label: {Text("R2")}, minimumValueLabel: {Text("1")}, maximumValueLabel: {Text("1000")}) { _ in}
                                    Text(String(format: "%.0f", vm.R2).appending("k𝛀"))
                                }.padding(.vertical,5)
                                HStack{
                                    Text("R3:")
                                    Slider(value: $vm.R3, in: 1...1000, step: 1, label: {Text("R3")}, minimumValueLabel: {Text("1")}, maximumValueLabel: {Text("1000")}) { _ in}
                                    Text(String(format: "%.0f", vm.R3).appending("k𝛀"))
                                }.padding(.vertical,5)
                                HStack{
                                    Text("R4:")
                                    Slider(value: $vm.R4, in: 1...100, step: 1, label: {Text("R4")}, minimumValueLabel: {Text("1")}, maximumValueLabel: {Text("100")}) { _ in}
                                    Text(String(format: "%.0f", vm.R4).appending("k𝛀"))
                                }.padding(.vertical,5)
                                HStack{
                                    Text("R5:")
                                    Slider(value: $vm.R5, in: 1...10, step: 0.1, label: {Text("R5")}, minimumValueLabel: {Text("1")}, maximumValueLabel: {Text("10")}) { _ in}
                                    Text(String(format: "%.1f", vm.R5).appending("k𝛀"))
                                }.padding(.vertical,5)
                                HStack{
                                    Text("R6:")
                                    Slider(value: $vm.R5, in: 1...100, step: 1, label: {Text("R6")}, minimumValueLabel: {Text("1")}, maximumValueLabel: {Text("10")}) { _ in}
                                    Text(String(format: "%.0f", vm.R6).appending("k𝛀"))
                                }.padding(.vertical,5)
                            }
                            HStack{
                                Text("RF:")
                                Slider(value: $vm.RF, in: 1...100, step: 1, label: {Text("RF")}, minimumValueLabel: {Text("1")}, maximumValueLabel: {Text("100")}) { _ in}
                                Text(String(format: "%.0f", vm.RF).appending("k𝛀"))
                            }.padding(.vertical,5)
                            HStack{
                                Text("CF:")
                                Slider(value: $vm.CF, in: 0.01...100, step: 0.01, label: {Text("CF")}, minimumValueLabel: {Text("0.01")}, maximumValueLabel: {Text("1000")}) { _ in}
                                Text(String(format: "%.2f", vm.CF).appending("𝛍F"))
                            }.padding(.vertical,5)
                        }.frame(width:geometry.size.width*0.35)
                            .padding(.horizontal,1)
                        Button{
                            vm.inputforward(userurl: Usermodel.user.simulationurl)
                            Usermodel.SimulationImagedisplay()
                        }label: {
                            Text("Confirm")
                                .foregroundColor(!vm.Valuelegal() ? Color.secondary:Color.white)
                        }.disabled(!vm.Valuelegal())
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.roundedRectangle(radius: 1))
                    }.frame(width:geometry.size.width*0.35)
                        .background(
                            InputbackgroundView()
                        )
                        .offset(y: -geometry.size.height*0.08)
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
                        HStack{
                            Button(action: vm.imagebackward) {
                                Image(systemName: "arrow.left")
                                    .font(.title2)
                            }.padding(.trailing,5)
                            Button{
                                vm.imagerefresh(userurl: Usermodel.user.simulationurl)
                                Usermodel.SimulationimageRefreshDisable=true
                            }label: {
                                Image(systemName: "arrow.clockwise")
                                    .font(.title2)
                                    .foregroundColor(Usermodel.SimulationimageRefreshDisable ? .secondary : .accentColor)
                            }
                            .padding(.trailing,5)
                            .disabled(Usermodel.SimulationimageRefreshDisable)
                            .onReceive(Usermodel.Timereveryonesecond, perform: Usermodel.SimulationImageRefreshCountdown)
                            Button{
                                withAnimation(Animation.spring()) {vm.imagezoom.toggle()}
                            }label: {
                                Image(systemName:vm.imagezoom ? "arrow.down.right.and.arrow.up.left":"arrow.up.left.and.arrow.down.right")
                                    .font(.title2)
                            }
                            .padding(.trailing,5)
                            Spacer()
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
        
    }
}

struct ARSecondorderfilterextraView_Previews: PreviewProvider {
    static var previews: some View {
        SecondorderfilterextraView()
    }
}
