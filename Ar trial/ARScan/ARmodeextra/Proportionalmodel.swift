//
//  Proportionalmodel.swift
//  Ar trial
//
//  Created by niudan on 2023/4/2.
//

import SwiftUI
//MARK: Later add new input modes(sawtooth wave...), after adding a new mode, edit its modetext and statistics
/// Proportional circuit input mode
enum proportionalinputmode:Int {
    case DC=0
    case Sine=1
    case Squarewave=2
    case Triangularwave=3
}
extension proportionalinputmode{
    /// Mode related text
    var modetext:String{
        switch self {
        case .DC:return "DC"
        case .Sine:return "Sine"
        case .Squarewave:return "Squarewave"
        case .Triangularwave:return "Triangularwave"
        }
    }
}
enum ProportionalcircuitExtraviewstatus:Int{
    case start=0
    case resistance=1
    case input=2
    case chart=3
}
/// Input struct
struct input {
    var mode:proportionalinputmode
    /// Peak value
    var peak:Double
    /// Input frequency(f HZ)
    var frequency:Double
}
/// Proportional circuit model
class Proportionalcircuitmodel:ObservableObject,Identifiable{
    //MARK: parameters
    @Published var ExtraViewstatus:ProportionalcircuitExtraviewstatus
    /// Resistance of each plus input
    @Published var resistanceplus:[Double]
    /// Textfield text of resistance of each plus input
    @Published var resistanceplustext:[String]
    /// Resistance of each plus input
    @Published var resistanceminus:[Double]
    /// Textfield text of resistance of each plus input
    @Published var resistanceminustext:[String]
    @Published var resistancea:Double
    @Published var resistanceatext:String
    @Published var resistancef:Double
    @Published var resistanceftext:String
    /// Plusinput array
    @Published var plusinput:[input]
    @Published var plusinputpeaktext:[String]
    @Published var plusinputfrequencytext:[String]
    /// Minusinput array
    @Published var minusinput:[input]
    @Published var minusinputpeaktext:[String]
    @Published var minusinputfrequencytext:[String]
    /// Display alert before chart is presented
    @Published var showvaluealert:Bool
    /// Zooming chart
    @Published var zooming:Bool
    /// All possible input modes
    var possiblemodes:[proportionalinputmode]{
        var returnarray:[proportionalinputmode]=[]
        var index=0
        while proportionalinputmode(rawValue: index) != nil{
            returnarray.append(proportionalinputmode(rawValue: index)!)
            index += 1
        }
        return returnarray
    }
    let zoomratio:CGFloat=2.5
    
    
    //MARK: initiate
    init() {
        ExtraViewstatus = .start
        resistanceplus=[1]
        resistanceplustext=[""]
        resistanceminus=[1]
        resistanceminustext=[""]
        resistancea=1
        resistanceatext=""
        resistancef=1
        resistanceftext=""
        plusinput=[input(mode: .DC, peak: 1, frequency: 1)]
        plusinputpeaktext=[""]
        plusinputfrequencytext=[""]
        minusinput=[input(mode: .DC, peak: 1, frequency: 1)]
        minusinputpeaktext=[""]
        minusinputfrequencytext=[""]
        showvaluealert=false
        zooming=false
    }
    //MARK: functions
    /// Extra View status go forward
    func Statusforward()->Void{
        let rawvalue=ExtraViewstatus.rawValue+1
        ExtraViewstatus=ProportionalcircuitExtraviewstatus(rawValue: rawvalue) ?? .start
    }
    /// Extra View status go backward
    func Statusbackward()->Void{
        let rawvalue=ExtraViewstatus.rawValue-1
        ExtraViewstatus=ProportionalcircuitExtraviewstatus(rawValue: rawvalue) ?? .start
    }
    /// Add a plus input
    func addplus()->Void{
        if resistanceplus.count<3{
            resistanceplus.append(1)
            resistanceplustext.append("")
            plusinput.append(input(mode: .DC, peak: 1, frequency: 1))
            plusinputpeaktext.append("")
            plusinputfrequencytext.append("")
        }
    }
    /// Add a minus input
    func addminus()->Void{
        if resistanceminus.count<3{
            resistanceminus.append(1)
            resistanceminustext.append("")
            minusinput.append(input(mode: .DC, peak: 1, frequency: 1))
            minusinputpeaktext.append("")
            minusinputfrequencytext.append("")
        }
    }
    /// Reduce a plus input
    func reduceplus()->Void{
        if resistanceplus.count>1{
            resistanceplus.removeLast()
            resistanceplustext.removeLast()
            plusinput.removeLast()
            plusinputpeaktext.removeLast()
            plusinputfrequencytext.removeLast()
        }
    }
    /// Reduce a minus input
    func reduceminus()->Void{
        if resistanceminus.count>1{
            resistanceminus.removeLast()
            resistanceminustext.removeLast()
            minusinput.removeLast()
            minusinputpeaktext.removeLast()
            minusinputfrequencytext.removeLast()
        }
    }
    /// Decide whether resistance values are legal
    /// - Returns: (all resistance values are typed in textfield)&&(all resistance values>0)
    func resistancevaluelegal() -> Bool {
        guard (Double(resistanceatext) != nil)&&(Double(resistanceftext) != nil) else {return false}
        if Double(resistanceatext)! <= 0 || Double(resistanceftext)! <= 0{
            return false
        }
        for index in resistanceplustext.indices {
            if (Double(resistanceplustext[index]) == nil) {
                return false
            }
            if (Double(resistanceplustext[index])! <= 0) {
                return false
            }
        }
        for index in resistanceminustext.indices {
            if (Double(resistanceminustext[index]) == nil) {
                return false
            }
            if (Double(resistanceminustext[index])! <= 0) {
                return false
            }
        }
        return true
    }
    /// Decide whether input values are legal
    /// - Returns: (all input peak values are typed in textfield) && (all AC input frequency values are typed in textfield) && (all input peak values>0) && (all AC input frequency values >0)
    func inputvaluelegal()->Bool{
        for index in plusinputpeaktext.indices {
            if (Double(plusinputpeaktext[index]) == nil) {
                return false
            }
            if (Double(plusinputpeaktext[index])! <= 0) {
                return false
            }
        }
        for index in minusinputpeaktext.indices {
            if (Double(minusinputpeaktext[index]) == nil) {
                return false
            }
            if (Double(minusinputpeaktext[index])! <= 0) {
                return false
            }
        }
        for index in plusinputfrequencytext.indices {
            if plusinput[index].mode.rawValue != 0,(Double(plusinputfrequencytext[index]) == nil) {
                return false
            }
            if plusinput[index].mode.rawValue != 0,(Double(plusinputfrequencytext[index])! <= 0) {
                return false
            }
        }
        for index in minusinputfrequencytext.indices {
            if minusinput[index].mode.rawValue != 0,(Double(minusinputfrequencytext[index]) == nil) {
                return false
            }
            if minusinput[index].mode.rawValue != 0,(Double(minusinputfrequencytext[index])! <= 0) {
                return false
            }
        }
        return true
    }
    
    /// Automatically decide whether values are legal
    func valuelegal()->Bool{
        switch ExtraViewstatus {
        case .resistance:
            return resistancevaluelegal()
        case .input:
            return inputvaluelegal()
        default:break
        }
        return false
    }
    
    /// Confirm resistance values in textfield
    func confirmresistancevalue()->Void{
        resistancea=Double(resistanceatext)!
        resistancef=Double(resistanceftext)!
        for index in resistanceplustext.indices {
            resistanceplus[index]=Double(resistanceplustext[index])!
        }
        for index in resistanceminustext.indices {
            resistanceminus[index]=Double(resistanceminustext[index])!
        }
        Statusforward()
    }
    /// Confirm input values in textfield
    func confirminputvalue()->Void{
        for index in plusinputpeaktext.indices {
            plusinput[index].peak=Double(plusinputpeaktext[index])!
            if plusinput[index].mode.rawValue != 0{
                plusinput[index].frequency=Double(plusinputfrequencytext[index])!
            }
            
        }
        for index in minusinputpeaktext.indices {
            minusinput[index].peak=Double(minusinputpeaktext[index])!
            if minusinput[index].mode.rawValue != 0{
                minusinput[index].frequency=Double(minusinputfrequencytext[index])!

            }
        }
    }
    /// Automatically confirm values in textfield
    func confirmvalue()->Void{
        switch ExtraViewstatus {
        case .resistance:
            confirmresistancevalue()
        case .input:
            confirminputvalue()
        default:return
        }
        
    }
    //MARK: static functions
    
    /// Generates chart inform label
    /// - Parameters:
    ///   - chartinformstring: chartinform constant String array, part 0: String for 0, part 1: [String] for plus inputs, part 2: [String] for minus inputs, part 3: Sring for output
    ///   - chartinformcolor: chartinform constant Color array, part 0: Color for 0, part 1: [Color] for plus inputs, part 2: [Color] for minus inputs, part 3: Color for output
    ///   - plusinput: Plusinput array
    ///   - minusinput: Minusinput array
    /// - Returns: Chart inform label
    static func generatechartinform(chartinformstring:(String,[String],[String],String),chartinformcolor:(Color,[Color],[Color],Color),_ plusinput:[input],_ minusinput:[input])->([String],[Color]){
        var returnstringarray:[String]=[chartinformstring.0]
        var returncolorarray:[Color]=[chartinformcolor.0]
        for index in plusinput.indices {
            returnstringarray.append(chartinformstring.1[index])
            returncolorarray.append(chartinformcolor.1[index])
        }
        for index in minusinput.indices {
            returnstringarray.append(chartinformstring.2[index])
            returncolorarray.append(chartinformcolor.2[index])
        }
        returnstringarray.append(chartinformstring.3)
        returncolorarray.append(chartinformcolor.3)
        return (returnstringarray,returncolorarray)
    }
    //MARK: set statistics
    /// Generates statistics for presenting chart from all resistances and inputs
    /// - Parameters:
    ///   - Rplus: Resistance of each plus input
    ///   - Rminus: Resistance of each minus input
    ///   - plusinput: Plusinput array
    ///   - minusinput: Minusinput array
    /// - Returns: Statistics for generating chart data
    static func getstatistic(Ra:Double,Rf:Double,Rplus:[Double],Rminus:[Double],plusinput:[input],minusinput:[input])->([Double],[[Double]],[[Double]],[Double]){
        var returnarray:([Double],[[Double]],[[Double]],[Double])=([],[],[],[])
        var referarray:[Double]=[]
        var range:(Double?,Double?)=(nil,nil)
        let minfrequency:Double?
        //var test:[input]?
        //MARK: Edit mode statistics
        switch (plusinput.filter{$0.mode.rawValue != 0}.isEmpty,minusinput.filter{$0.mode.rawValue != 0}.isEmpty) {
        case (true,true):range=(-1.5,3.5)
        case (true,false):
            minfrequency=minusinput.filter{$0.mode.rawValue != 0}.sorted{$0.frequency<=$1.frequency}.first!.frequency
            range=(-1.5/minfrequency!,3.5/minfrequency!)
        case (false,true):
            //test=plusinput.filter{$0.mode.rawValue != 0}.sorted{$0.frequency<=$1.frequency}
            minfrequency=plusinput.filter{$0.mode.rawValue != 0}.sorted{$0.frequency<=$1.frequency}.first!.frequency
            range=(-1.5/minfrequency!,3.5/minfrequency!)
        default:minfrequency=min(minusinput.filter{$0.mode.rawValue != 0}.sorted{$0.frequency<=$1.frequency}.first!.frequency,plusinput.filter{$0.mode.rawValue != 0}.sorted{$0.frequency<=$1.frequency}.first!.frequency)
            range=(-1.5/minfrequency!,3.5/minfrequency!)
        }
        referarray=stride(from: range.0!, to: range.1!, by: (range.1!-range.0!)/1000).map{$0}
        returnarray.0=referarray.map{_ in 0}
        returnarray.3=referarray.map{_ in 0}
        for index in plusinput.indices {
            switch plusinput[index].mode.rawValue {
            case 0:returnarray.1.append(referarray.map{_ in plusinput[index].peak})
            case 1:returnarray.1.append(referarray.map{sin($0*plusinput[index].frequency*2*Double.pi)*plusinput[index].peak})
            case 2:returnarray.1.append(referarray.map{ceil($0*plusinput[index].frequency)-$0*plusinput[index].frequency >= 0.5 ? plusinput[index].peak:-plusinput[index].peak})
            case 3:returnarray.1.append(referarray.map{
                (time:Double)->Double in
                let distance:Double=ceil(time*plusinput[index].frequency)-time*plusinput[index].frequency
                switch distance {
                case 0...0.25:return -4*distance*plusinput[index].peak
                case 0.25...0.75:return (4*distance-2)*plusinput[index].peak
                case 0.75...1:return (4-4*distance)*plusinput[index].peak
                default:return 0
                }
            })
            default:break
                
            }
        }
        for index in minusinput.indices {
            switch minusinput[index].mode.rawValue {
            case 0:returnarray.2.append(referarray.map{_ in minusinput[index].peak})
            case 1:returnarray.2.append(referarray.map{sin($0*minusinput[index].frequency*2*Double.pi)*minusinput[index].peak})
            case 2:returnarray.2.append(referarray.map{ceil($0*minusinput[index].frequency)-$0*minusinput[index].frequency >= 0.5 ? minusinput[index].peak:-minusinput[index].peak})
            case 3:returnarray.2.append(referarray.map{
                (time:Double)->Double in
                let distance:Double=ceil(time*minusinput[index].frequency)-time*minusinput[index].frequency
                switch distance {
                case 0...0.25:return -4*distance*minusinput[index].peak
                case 0.25...0.75:return (4*distance-2)*minusinput[index].peak
                case 0.75...1:return (4-4*distance)*minusinput[index].peak
                default:return 0
                }
            })
            default:break
                
            }
        }
        for indexo in returnarray.3.indices{
            for indexp in returnarray.1.indices {
                returnarray.3[indexo] += returnarray.1[indexp][indexo]*Ra/Rplus[indexp]
            }
            for indexm in returnarray.2.indices {
                returnarray.3[indexo] -= returnarray.2[indexm][indexo]*Rf/Rminus[indexm]
            }
        }
        
        
        return returnarray
    }
    
    /// Generates chart data
    /// - Parameters:
    ///   - statistic: Statistics generated from all resistances and inputs
    ///   - gradientcolors: Constant gradientcolors
    /// - Returns: Data for presenting chart
    static func getdata(statistic:([Double],[[Double]],[[Double]],[Double]),gradientcolors:(GradientColor,[GradientColor],[GradientColor],GradientColor))->[([Double], GradientColor)]{
        var returnarray:[([Double], GradientColor)]=[(statistic.0,gradientcolors.0)]
        for index in statistic.1.indices {
            returnarray.append((statistic.1[index],gradientcolors.1[index]))
        }
        for index in statistic.2.indices {
            returnarray.append((statistic.2[index],gradientcolors.2[index]))
        }
        returnarray.append((statistic.3,gradientcolors.3))
        return returnarray
    }
    
}

