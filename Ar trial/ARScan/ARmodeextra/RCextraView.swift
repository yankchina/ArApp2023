//
//  ChartforRCView.swift
//  Ar trial
//
//  Created by niudan on 2023/3/17.
//

import SwiftUI

struct RCextraView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var pulsepresent:Bool=false
    @State var sinepresent:Bool=false
    @State var chartpresent:Bool=false
    @State var inputpresent:Bool=false
    @State var resistance:Double=1
    @State var resistancetext:String=""
    @State var capacitance:Double=10
    @State var capacitancetext:String=""
    @State var frequencybyomega:Double=1
    @State var frequencybyomegatext:String=""
    @State var showvaluealert:Bool=false
    @State var magnifyamount:CGFloat=0
    @State var zooming:Bool=false
    let zoomratio:CGFloat=2.5
    
    let chartinform:([String],[Color])=(["0","Us","Ur","Uc"],[Color.primary, Color.yellow,Color.blue,Color.red])
    var statistic:[[Double]]{
        getstatistic(R: resistance, C: capacitance,pulsepresent,sinepresent,frequency:frequencybyomega)
    }
    let gradientcolors:[GradientColor]=[GradientColors.ARpriamry,GradientColors.ARblue,GradientColors.ARred,GradientColors.ARyellow]
    
    func getstatistic(R:Double,C:Double,_ pulsepresent:Bool,_ sinepresent:Bool,frequency:Double)->[[Double]]{
        var returnarray:[[Double]]=[]
        var referarray:[Double]=[]
        if pulsepresent{
            referarray=stride(from: -R*C*3/10, to: R*C*3, by: R*C*3/1000).map{$0}
        }
        if sinepresent{
            referarray=stride(from: 0, to: 2*Double.pi/frequency*3, by: 2*Double.pi/frequency*3/1000).map{$0}
        }
        
        if pulsepresent{
            returnarray.append(contentsOf: [referarray.map{0*$0},
                                            referarray.map{$0>0 ? pow(M_E, -$0/R/C)/R:0},
                                            referarray.map{$0>0 ? 1-pow(M_E, -$0/R/C)/R:0},
                                            referarray.map{$0>0 ? 1:0}
                                           ])
        }
        if sinepresent{
            returnarray.append(contentsOf:[
                referarray.map{0*$0},
                referarray.map{
                    (number:Double) ->Double in
                return R/sqrt(pow(R,2)+pow(C*frequency,-2 ))*sin(number*frequency+atan2(1/frequency/C, R))
                },
                referarray.map{
                    (number:Double) ->Double in
                    return 1/sqrt(pow(R,2)+pow(C*frequency,-2 ))/frequency/C*sin(number*frequency+atan2(1/frequency/C, R)-Double.pi/2)
                },
                referarray.map{
                    (number:Double) ->Double in
                return sin(number*frequency)
                }
            ])
        }
        return returnarray
    }
    func getdata(statistic:[[Double]],gradientcolors:[GradientColor])->[([Double], GradientColor)]{
        var returnarray:[([Double], GradientColor)]=[]
        for index in gradientcolors.indices {
            returnarray.append((statistic[index],gradientcolors[index]))
        }
        return returnarray
    }
    func valuelegal()->Bool{
        guard (Double(resistancetext) != nil) && (Double(capacitancetext) != nil) && (Double(frequencybyomegatext) != nil) else {
            return false
        }
        return (Double(resistancetext)! > 0)&&(Double(capacitancetext)! > 0)&&(Double(frequencybyomegatext)! > 0)
    }
    func valueappropriate(pulsepresent:Bool,sinepresent:Bool)->Bool{
        if let resistancevalue=Double(resistancetext) ,let capacitancevalue=Double(capacitancetext) ,let frequencyvalue=Double(frequencybyomegatext){
            if pulsepresent{
                return (resistancevalue <= 3)&&(resistancevalue >= 1/3)
            }
            if sinepresent{
                return (resistancevalue*capacitancevalue*frequencyvalue <= 5)&&(resistancevalue*capacitancevalue*frequencyvalue >= 0.2)
            }
        }
        return false
    }
    var body: some View {
        GeometryReader{geometry in
            ZStack{
                HStack{
                    Spacer()
                    if pulsepresent&&chartpresent {
                        VStack{
                            if zooming{
                            }else{
                            }
                        }.onDisappear{chartpresent=false}
                    }else if sinepresent&&chartpresent{
                        VStack{
                            if zooming{
                            }else{
                            }
                        }.onDisappear{chartpresent=false}
                    }else{
                        if !inputpresent{
                            VStack(alignment:.trailing,spacing:.zero){
                                Button {
                                    pulsepresent=true
                                    inputpresent=true
                                } label: {
                                    Text("pulse input").font(.title3)
                                    
                                }.buttonStyle(.borderedProminent)
                                    .buttonBorderShape(.roundedRectangle(radius: 5))
                                Button {
                                    sinepresent=true
                                    inputpresent=true
                                } label: {
                                    Text("sine input").font(.title3)
                                    
                                }.buttonStyle(.borderedProminent)
                                    .buttonBorderShape(.roundedRectangle(radius: 5))
                            }
                        }else{
                            VStack(alignment:.trailing,spacing:.zero){
                                HStack(spacing:.zero){
                                    Text("R:")
                                    TextField("", text: $resistancetext)
                                        .background(Color.gray.opacity(0.3).cornerRadius(1))
                                        .frame(width:geometry.size.width/4)
                                        .keyboardType(.numberPad)
                                    
                                }
                                HStack(spacing:.zero){
                                    Text("C:")
                                    TextField("", text: $capacitancetext)
                                        .background(Color.gray.opacity(0.3).cornerRadius(1))
                                        .frame(width:geometry.size.width/4)
                                        .keyboardType(.numberPad)
                                    
                                }
                                HStack(spacing:.zero){
                                    Text("𝒘:")
                                    TextField("", text: $frequencybyomegatext)
                                        .background(Color.gray.opacity(0.3).cornerRadius(1))
                                        .frame(width:geometry.size.width/4)
                                        .keyboardType(.numberPad)
                                    
                                }
                                HStack(spacing:.zero) {
                                    Button {
                                        inputpresent=false
                                        pulsepresent=false
                                        sinepresent=false
                                    } label: {
                                        Text("Cancel").foregroundColor(.primary)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .buttonBorderShape(.roundedRectangle(radius: 1))
                                    .accentColor(Color.gray)
                                    Button {
                                        if valuelegal(){
                                            resistance=Double(resistancetext)!
                                            capacitance=Double(capacitancetext)!
                                            frequencybyomega=Double(frequencybyomegatext)!
                                            inputpresent=false
                                        }
                                        showvaluealert=true
                                    } label: {
                                        Text("Confirm").foregroundColor(.primary)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .buttonBorderShape(.roundedRectangle(radius: 1))
                                    .accentColor(valuelegal() ? Color.accentColor : Color.gray)
                                    .disabled(!valuelegal())
                                
                                }

                                
                            }.background(Color.white.opacity(0.8).cornerRadius(5))
                        }
                    }
                }
                .alert(isPresented: $showvaluealert) {
                    Alert(title: Text(Alerttext), primaryButton: .destructive(Text("Cancel").foregroundColor(.red)) {inputpresent=true}, secondaryButton: .default(valueappropriate(pulsepresent: pulsepresent,sinepresent: sinepresent) ? Text("OK") : Text("Continue Anyway")){chartpresent=true})
                    
                }
                .onChange(of: geometry.size) { value in
                    guard (sinepresent || pulsepresent) && chartpresent else {return}
                    sinepresent=false
                    pulsepresent=false
                    chartpresent=false
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
                
            
            
        }
    }
}

extension RCextraView{
    private var Alerttext:String{
        if valueappropriate(pulsepresent: pulsepresent,sinepresent: sinepresent){
            return "Chart ready to display"
        }else{
            if self.sinepresent{
                return "Values for sine input are inappropriate, please reset values to make 0.2<=R𝒘C<=5"
            }
            if self.pulsepresent{
                return "Values for pulse input are inappropriate, please reset values to make 1/3<=R<=3"
            }
        }
        return ""
    }
}

struct ChartforRCView_Previews: PreviewProvider {
    static var previews: some View {
        RCextraView()
    }
}
