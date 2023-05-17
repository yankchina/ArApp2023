//
//  SquarewaveDRextraView.swift
//  Ar trial
//
//  Created by niudan on 2023/4/20.
//

import SwiftUI
import Combine


//MARK: ARsquarewaveDRmodel
class ARsquarewaveDRmodel: ObservableObject {
    @Published var stoptime:Double
    @Published var stoptimetext:String
    @Published var RT:Double
    @Published var CT:Double
    @Published var Uz:Double
    @Published var RW:Double
    @Published var RWRatio:Double
    @Published var R1:Double
    @Published var R2:Double
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
        Uz=5
        RW=1
        RWRatio=0.5
        R1=100
        R2=100
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
        stoptime=Double(stoptimetext)!
        requestcount += 1
        Simulationurl=URL(string: "http://"+userurl+"/AR/Simulation/squarewaveDR?stoptime=\(stoptime)&RT=\(RT)&CT=\(CT)&Uz=\(Uz)&RW=\(RW)&RWRatio=\(RWRatio)&R1=\(R1)&R2=\(R2)&requestcount=\(requestcount)")
        statusforward()
    }
    func inputbackward()->Void{statusbackward()}
    func imagebackward()->Void{statusbackward()}
    func imageforward()->Void{statusforward()}
    func imagerefresh(userurl:String)->Void {
        requestcount += 1
        Simulationurl=URL(string: "http://"+userurl+"/AR/Simulation/squarewaveDR?stoptime=\(stoptime)&RT=\(RT)&CT=\(CT)&Uz=\(Uz)&RW=\(RW)&RWRatio=\(RWRatio)&R1=\(R1)&R2=\(R2)&requestcount=\(requestcount)")
    }
    func Valuelegal()->Bool{
        guard let stoptimevalue=Double(stoptimetext) else {return false}
        return stoptimevalue>0
    }
        
}
struct SquarewaveDRextraView: View {
    @EnvironmentObject var Usermodel:Appusermodel
    @StateObject var vm = ARsquarewaveDRmodel()
    
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
                                    Text("stoptime:")
                                    TextField("stoptime", text: $vm.stoptimetext)
                                        .keyboardType(.numberPad)
                                        .frame(width:geometry.size.width/8)
                                        .background(Color.gray.opacity(0.3).cornerRadius(1))
                                    Text("s")
                                }.padding(.vertical,5)
                                HStack{
                                    Text("RT:")
                                    Slider(value: $vm.RT, in: 1...1000, step: 1, label: {Text("RT")}, minimumValueLabel: {Text("1")}, maximumValueLabel: {Text("1000")}) { _ in}
                                    Text(String(format: "%.0f", vm.RT).appending("k𝛀"))
                                }.padding(.vertical,5)
                                HStack{
                                    Text("CT:")
                                    Slider(value: $vm.CT, in: 1...1000, step: 1, label: {Text("CT")}, minimumValueLabel: {Text("1")}, maximumValueLabel: {Text("1000")}) { _ in}
                                    Text(String(format: "%.0f", vm.CT).appending("𝛍F"))
                                }.padding(.vertical,5)
                                HStack{
                                    Text("Uz:")
                                    Slider(value: $vm.Uz, in: 1...15, step: 1, label: {Text("VCC")}, minimumValueLabel: {Text("1")}, maximumValueLabel: {Text("15")}) { _ in}
                                    Text(String(format: "%.0f", vm.Uz).appending("V"))
                                }.padding(.vertical,5)
                                HStack{
                                    Text("RW:")
                                    Slider(value: $vm.RW, in: 1...1000, step: 1, label: {Text("RW")}, minimumValueLabel: {Text("1")}, maximumValueLabel: {Text("1000")}) { _ in}
                                    Text(String(format: "%.0f", vm.RW).appending("k𝛀"))
                                }.padding(.vertical,5)
                                HStack{
                                    Text("RWRatio:")
                                    Slider(value: $vm.RWRatio, in: 0...1, step: 0.01, label: {Text("RWRatio")}, minimumValueLabel: {Text("0")}, maximumValueLabel: {Text("1")}) { _ in}
                                    Text(String(format: "%.2f", vm.RWRatio))
                                }.padding(.vertical,5)
                            }
                            HStack{
                                Text("R1:")
                                Slider(value: $vm.R1, in: 1...1000, step: 1, label: {Text("R1")}, minimumValueLabel: {Text("1")}, maximumValueLabel: {Text("1000")}) { _ in}
                                Text(String(format: "%.0f", vm.R1).appending("k𝛀"))
                            }.padding(.vertical,5)
                            HStack{
                                Text("R2:")
                                Slider(value: $vm.R2, in: 1...1000, step: 1, label: {Text("R2")}, minimumValueLabel: {Text("1")}, maximumValueLabel: {Text("1000")}) { _ in}
                                Text(String(format: "%.0f", vm.R2).appending("k𝛀"))
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
                        )                    //.frame(maxWidth: geometry.size.width*0.9)
                        .offset(y: vm.imageyoffset-geometry.size.height*0.08)
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

struct SquarewaveDRextraView_Previews: PreviewProvider {
    static var previews: some View {
        SquarewaveDRextraView()
    }
}
