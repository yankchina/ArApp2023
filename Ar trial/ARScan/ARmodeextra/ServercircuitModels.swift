//
//  ServercircuitModels.swift
//  Ar trial
//
//  Created by 何海心 on 2023/5/18.
//

import Foundation
import SwiftUI
import Combine

enum ARSimulationextraviewstatus:Int {
    case start=0
    case input=1
    case image=2
}

class ServercircuitViewModel:ObservableObject{
    @Published var Simulationurl:URL?
    @Published var requestcount:Int
    @Published var status:ARSimulationextraviewstatus
    @Published var inputwindowyoffset:CGFloat
    @Published var imageyoffset:CGFloat
    @Published var imagezoom:Bool
    var imagezoomratio: CGFloat{return imagezoom ? 1.5:1}
    var cancellables = Set<AnyCancellable>()
    
    init() {
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
        statusforward()
    }
    func inputbackward()->Void{statusbackward()}
    func imagebackward()->Void{statusbackward()}
    func imageforward()->Void{statusforward()}
    func imagerefresh(userurl:String)->Void {
        requestcount += 1
    }
    func Valuelegal()->Bool{
        return true
    }




}
//MARK: ARsquarewavemodel
class ARsquarewavemodel: ServercircuitViewModel {
    @Published var stoptime:Double
    @Published var stoptimetext:String
    @Published var RT:Double
    @Published var CT:Double
    @Published var VCC:Double
    @Published var R1:Double
    @Published var R2:Double
    @Published var R3:Double
    
    override init() {
        stoptime=0.01
        stoptimetext="0.01"
        RT=1
        CT=1
        VCC=5
        R1=100
        R2=100
        R3=100
        super.init()
    }
    override func inputforward(userurl:String)->Void{
        stoptime=Double(stoptimetext)!
        requestcount += 1
        Simulationurl=URL(string:"http://"+userurl+"/AR/Simulation/squarewave?stoptime=\(stoptime)&RT=\(RT)&CT=\(CT)&VCC=\(VCC)&R1=\(R1)&R2=\(R2)&R3=\(R3)&requestcount=\(requestcount)")
        super.inputforward(userurl: userurl)
    }
    override func imagerefresh(userurl:String)->Void {
        super.imagerefresh(userurl: userurl)
        Simulationurl=URL(string:"http://"+userurl+"/AR/Simulation/squarewave?stoptime=\(stoptime)&RT=\(RT)&CT=\(CT)&VCC=\(VCC)&R1=\(R1)&R2=\(R2)&R3=\(R3)&requestcount=\(requestcount)")
    }
    override func Valuelegal()->Bool{
        guard let stoptimevalue=Double(stoptimetext)else{return false}
        return stoptimevalue > 0
        super.Valuelegal()
    }
        
}


//MARK: ARsquarewaveDRmodel
class ARsquarewaveDRmodel: ServercircuitViewModel {
    @Published var stoptime:Double
    @Published var stoptimetext:String
    @Published var RT:Double
    @Published var CT:Double
    @Published var Uz:Double
    @Published var RW:Double
    @Published var RWRatio:Double
    @Published var R1:Double
    @Published var R2:Double
    
    override init() {
        stoptime=0.01
        stoptimetext="0.01"
        RT=1
        CT=1
        Uz=5
        RW=1
        RWRatio=0.5
        R1=100
        R2=100
        super.init()
    }
    override func inputforward(userurl:String)->Void{
        stoptime=Double(stoptimetext)!
        requestcount += 1
        Simulationurl=URL(string: "http://"+userurl+"/AR/Simulation/squarewaveDR?stoptime=\(stoptime)&RT=\(RT)&CT=\(CT)&Uz=\(Uz)&RW=\(RW)&RWRatio=\(RWRatio)&R1=\(R1)&R2=\(R2)&requestcount=\(requestcount)")
        super.inputforward(userurl: userurl)
    }
    override func imagerefresh(userurl:String)->Void {
        super.imagerefresh(userurl: userurl)
        Simulationurl=URL(string: "http://"+userurl+"/AR/Simulation/squarewaveDR?stoptime=\(stoptime)&RT=\(RT)&CT=\(CT)&Uz=\(Uz)&RW=\(RW)&RWRatio=\(RWRatio)&R1=\(R1)&R2=\(R2)&requestcount=\(requestcount)")
    }
    override func Valuelegal()->Bool{
        guard let stoptimevalue=Double(stoptimetext) else {return false}
        return stoptimevalue>0
        super.Valuelegal()
    }
        
}


//MARK: Secondorderfiltermodel
class ARSecondorderfiltermodel: ServercircuitViewModel {
    @Published var R1:Double
    @Published var R2:Double
    @Published var R3:Double
    @Published var R4:Double
    @Published var R5:Double
    @Published var R6:Double
    @Published var RF:Double
    @Published var CF:Double
    
    override init() {
        R1=10
        R2=100
        R3=100
        R4=10
        R5=1.1
        R6=10
        RF=16
        CF=0.01
        super.init()
    }
    override func inputforward(userurl:String)->Void{
        requestcount += 1
        Simulationurl=URL(string: "http://"+userurl+"/AR/Simulation/Secondorderfilter?R1=\(R1)&R2=\(R2)&R3=\(R3)&R4\(R4)&R5=\(R5)&R6=\(R6)&RF=\(RF)&CF=\(CF)&requestcount=\(requestcount)")
        statusforward()
    }
    override func imagerefresh(userurl:String)->Void {
        requestcount += 1
        Simulationurl=URL(string: "http://"+userurl+"/AR/Simulation/Secondorderfilter?R1=\(R1)&R2=\(R2)&R3=\(R3)&R4\(R4)&R5=\(R5)&R6=\(R6)&RF=\(RF)&CF=\(CF)&requestcount=\(requestcount)")
    }
        
}


//MARK: 555timermonostabletriggermodel
class AR555timertriggermodel: ServercircuitViewModel {
    @Published var R:Double
    @Published var C:Double
    @Published var SquarewaveAmplitude:Double
    @Published var Squarewaveoffset:Double
    @Published var Vcc:Double
    @Published var SquarewavePeriod:Double
    @Published var SquarewaveDR:Double
    
    override init() {
        R=10
        C=1
        SquarewaveAmplitude=5
        Squarewaveoffset=0
        Vcc=5
        SquarewavePeriod=20
        SquarewaveDR=90
        super.init()
    }
    override func inputforward(userurl:String)->Void{
        requestcount += 1
        Simulationurl=URL(string: "http://"+userurl+"/AR/Simulation/timer555monostabletrigger?R=\(R)&C=\(C)&Amplititude=\(SquarewaveAmplitude)&Offset\(Squarewaveoffset)&Vcc=\(Vcc)&Period=\(SquarewavePeriod)&Dutyratio=\(SquarewaveDR)&requestcount=\(requestcount)")
        super.inputforward(userurl: userurl)
    }
    override func imagerefresh(userurl:String)->Void {
        super.imagerefresh(userurl: userurl)
        Simulationurl=URL(string: "http://"+userurl+"/AR/Simulation/timer555monostabletrigger?R=\(R)&C=\(C)&Amplititude=\(SquarewaveAmplitude)&Offset\(Squarewaveoffset)&Vcc=\(Vcc)&Period=\(SquarewavePeriod)&Dutyratio=\(SquarewaveDR)&requestcount=\(requestcount)")
    }
        
}


//MARK: sinegeneratormodel
class ARsinegeneratormodel: ServercircuitViewModel {
    @Published var R:Double
    @Published var C:Double
    
    override init() {
        R=10
        C=1
        super.init()
    }
    override func inputforward(userurl:String)->Void{
        requestcount += 1
        Simulationurl=URL(string: "http://"+userurl+"/AR/Simulation/sinegenerator?R=\(R)&C=\(C)&requestcount=\(requestcount)")
        super.inputforward(userurl: userurl)
    }
    override func imagerefresh(userurl:String)->Void {
        super.imagerefresh(userurl: userurl)
        Simulationurl=URL(string: "http://"+userurl+"/AR/Simulation/sinegenerator?R=\(R)&C=\(C)&requestcount=\(requestcount)")
    }
        
}

//MARK: voltageregulatormodel
class ARvoltageregulatormodel: ServercircuitViewModel {
    @Published var R2:Double
    @Published var UD1:Double
    
    override init() {
        R2=1
        UD1=3.2
        super.init()
    }
    override func inputforward(userurl:String)->Void{
        requestcount += 1
        Simulationurl=URL(string: "http://"+userurl+"/AR/Simulation/Voltageregulator?R2=\(R2)&UD1=\(UD1)&requestcount=\(requestcount)")
        super.inputforward(userurl: userurl)
    }
    override func imagerefresh(userurl:String)->Void {
        super.imagerefresh(userurl: userurl)
        Simulationurl=URL(string: "http://"+userurl+"/AR/Simulation/Voltageregulator?R2=\(R2)&UD1=\(UD1)&requestcount=\(requestcount)")
    }
}
