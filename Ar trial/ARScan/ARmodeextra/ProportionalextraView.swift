//
//  ProportionalextraView.swift
//  Ar trial
//
//  Created by niudan on 2023/3/29.
//

import SwiftUI
import RealityKit

struct ProportionalextraView: View {
    @ObservedObject var appmodel:ARappARpartmodel
    @ObservedObject var proportionalmodel:Proportionalcircuitmodel
    @State var display:Bool=false
    @State var Imagemagnifyamount:CGFloat=0
    @State var Imagemagnifylastamount:CGFloat=0

    var body: some View {
        GeometryReader{geometry in
            ZStack{
                ZStack{
                    ProportionalextrachartView(appmodel: appmodel, proportionalmodel: proportionalmodel, geometry: geometry)
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)

//                resetbutton
                //ExtraimageView(display: $display, geometry: geometry, Imagemagnifyamount: $Imagemagnifyamount, Imagemagnifylastamount: $Imagemagnifylastamount, extraimage: Image("proportional"))

            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)


        }


    }
}



//extension ProportionalextraView{
//
//    /// Button to reset model
//    private var resetbutton:some View{
//        ZStack{
//            Button {
//                appmodel.SecondorderfilterAnchor.notifications.reset.post()
//                Imagemagnifyamount=0
//                Imagemagnifylastamount=0
//            } label: {
//                Image(systemName: "arrow.clockwise")
//                    .foregroundColor(Color("arrowcolor1"))
//                    .font(.title)
//            }
//        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//    }
//}

struct ProportionalextrachartView:View{
    @EnvironmentObject var Usermodel:Appusermodel
    @ObservedObject var appmodel:ARappARpartmodel
    @ObservedObject var proportionalmodel:Proportionalcircuitmodel
    var geometry:GeometryProxy
    @State var showalert:Bool=false
    @State var zooming:Bool=false
    let zoomratio:CGFloat=2.5
    let chartinformcolor:(Color,[Color],[Color],Color)=(Color.primary,[Color.yellow,Color(hexString: "FEFB00"),Color(hexString: "FEFC78")],[Color.blue,Color(hexString:"75D5FF"),Color(hexString:"00FCFF")],Color.red)

    let chartinformstring:(String,[String],[String],String)=("0",["U+0","U+1","U+2"],["U-0","U-1","U-2"],"Uo")

    var chartinform:([String],[Color]){
        Proportionalcircuitmodel.generatechartinform(chartinformstring: chartinformstring, chartinformcolor: chartinformcolor, proportionalmodel.plusinput, proportionalmodel.minusinput)

    }

    let gradientcolors:(GradientColor,[GradientColor],[GradientColor],GradientColor)=(GradientColors.ARpriamry,[GradientColors.ARyellow,GradientColors.ARyellow1,GradientColors.ARyellow2],[GradientColors.ARblue,GradientColors.ARblue1,GradientColors.ARblue2],GradientColors.ARred)

    var statistic:([Double],[[Double]],[[Double]],[Double]){
        Proportionalcircuitmodel.getstatistic(Ra: proportionalmodel.resistancea, Rf: proportionalmodel.resistancef, Rplus: proportionalmodel.resistanceplus, Rminus: proportionalmodel.resistanceminus, plusinput: proportionalmodel.plusinput, minusinput: proportionalmodel.minusinput)
    }
    var body:some View{
        VStack(alignment:.trailing,spacing:.zero){
            if proportionalmodel.chartpresent {
                if zooming{
                    MultiLineChartRCView(
                        data: Proportionalcircuitmodel.getdata(statistic: self.statistic, gradientcolors: self.gradientcolors),
                        title: Usermodel.Language ? "加减法电路" : "Proportional",
                        chartwidth: geometry.size.width/4*zoomratio,
                        chartheight: geometry.size.height/5*zoomratio,
                        informlabel:chartinform,
                        isPresent: $proportionalmodel.chartpresent,
                        zooming: $zooming
                    )
                }else{
                    MultiLineChartRCView(
                        data: Proportionalcircuitmodel.getdata(statistic: self.statistic, gradientcolors: self.gradientcolors),
                        title: Usermodel.Language ? "加减法电路" : "Proportional",
                        chartwidth: geometry.size.width/4,
                        chartheight: geometry.size.height/5,
                        informlabel:chartinform,
                        isPresent: $proportionalmodel.chartpresent,
                        zooming: $zooming
                    )
                }

            }else{
                if proportionalmodel.resistancepresent{
                    VStack(alignment:.trailing,spacing: .zero){
                        HStack(spacing:10){
                            Button("- U+") {
                                switch proportionalmodel.plusinput.count {
                                case 2:appmodel.ProportionalAnchor.notifications.reduceplusinput1.post()
                                case 3:appmodel.ProportionalAnchor.notifications.reduceplusinput2.post()
                                default:break
                                }
                                proportionalmodel.reduceplus()

                            }
                            Button("+ U+") {
                                switch proportionalmodel.plusinput.count {
                                case 1:appmodel.ProportionalAnchor.notifications.addplusinput1.post()
                                case 2:appmodel.ProportionalAnchor.notifications.addplusinput2.post()
                                default:break
                                }
                                proportionalmodel.addplus()

                            }
                            Button("- U_") {
                                switch proportionalmodel.minusinput.count {
                                case 2:appmodel.ProportionalAnchor.notifications.reduceminusinput1.post()
                                case 3:appmodel.ProportionalAnchor.notifications.reduceminusinput2.post()
                                default:break
                                }
                                proportionalmodel.reduceminus()

                            }
                            Button("+ U_") {
                                switch proportionalmodel.minusinput.count {
                                case 1:appmodel.ProportionalAnchor.notifications.addminusinput1.post()
                                case 2:appmodel.ProportionalAnchor.notifications.addminusinput2.post()
                                default:break
                                }
                                proportionalmodel.addminus()

                            }
                        }
                        VStack(spacing:.zero){
                            VStack(alignment:.trailing, spacing:.zero){
                                ForEach(proportionalmodel.resistanceplus.indices,id:\.self) { index in
                                    HStack(spacing:.zero){
                                        Text("R+\(index):")
                                        TextField("", text: $proportionalmodel.resistanceplustext[index])
                                            .background(Color.gray.opacity(0.3).cornerRadius(1))
                                            .frame(width:geometry.size.width/8)
                                            .keyboardType(.numbersAndPunctuation)
                                        Text(" k𝛀")
                                    }
                                }
                            }
                            VStack(alignment:.trailing, spacing:.zero){
                                ForEach(proportionalmodel.resistanceminus.indices,id:\.self) { index in
                                    HStack(spacing:.zero){
                                        Text("R-\(index):")
                                        TextField("", text: $proportionalmodel.resistanceminustext[index])
                                            .background(Color.gray.opacity(0.3).cornerRadius(1))
                                            .frame(width:geometry.size.width/8)
                                            .keyboardType(.numbersAndPunctuation)
                                        Text(" k𝛀")
                                    }
                                }
                            }
                        }
                        HStack(spacing:.zero){
                            Text("Ra:")
                            TextField("", text: $proportionalmodel.resistanceatext)
                                .background(Color.gray.opacity(0.3).cornerRadius(1))
                                .frame(width:geometry.size.width/8)
                                .keyboardType(.numbersAndPunctuation)
                            Text(" k𝛀")
                        }
                        HStack(spacing:.zero){
                            Text("Rf:")
                            TextField("", text: $proportionalmodel.resistanceftext)
                                .background(Color.gray.opacity(0.3).cornerRadius(1))
                                .frame(width:geometry.size.width/8)
                                .keyboardType(.numbersAndPunctuation)
                            Text(" k𝛀")
                        }
                    }
                    .padding(.leading,3)
                }
                if proportionalmodel.inputpresent{
                    VStack(alignment:.trailing,spacing: .zero){
                        ForEach(proportionalmodel.plusinput.indices,id:\.self) { index in
                            HStack(spacing:.zero){
                                Picker(selection: $proportionalmodel.plusinput[index].mode,
                                    label: Text(proportionalmodel.plusinput[index].mode.modetext))
                                {
                                    ForEach(proportionalmodel.possiblemodes.indices,id:\.self) { indexp in
                                        Text(proportionalmodel.possiblemodes[indexp].modetext)
                                            .tag(proportionalmodel.possiblemodes[indexp])
                                    }
                                }.pickerStyle(MenuPickerStyle()).padding(.trailing, 5)
    //                            Button(proportionalmodel.plusinput[index].mode.modetext){
    //                                Proportionalcircuitmodel.convertmode(mode: &proportionalmodel.plusinput[index].mode)
    //                            }.padding(.trailing, 5)
                                Text("U+\(index):")
                                TextField("", text: $proportionalmodel.plusinputpeaktext[index])
                                    .background(Color.gray.opacity(0.3).cornerRadius(1))
                                    .frame(width:geometry.size.width/8)
                                    .keyboardType(.numbersAndPunctuation)
                                Text("V").padding(.trailing,5)
                                if proportionalmodel.plusinput[index].mode.rawValue != 0 {
                                    Text("f:").padding(.trailing,5)
                                    TextField("", text: $proportionalmodel.plusinputfrequencytext[index])
                                        .background(Color.gray.opacity(0.3).cornerRadius(1))
                                        .frame(width:geometry.size.width/8)
                                        .keyboardType(.numbersAndPunctuation)
                                    Text(" HZ")
                                }

                            }.padding(.bottom,5)
                        }
                        ForEach(proportionalmodel.minusinput.indices,id:\.self) { index in
                            HStack(spacing:.zero){
                                Picker(selection: $proportionalmodel.minusinput[index].mode,
                                    label: Text(proportionalmodel.minusinput[index].mode.modetext))
                                {
                                    ForEach(proportionalmodel.possiblemodes.indices,id:\.self) { indexm in
                                        Text(proportionalmodel.possiblemodes[indexm].modetext)
                                            .tag(proportionalmodel.possiblemodes[indexm])
                                    }
                                }.pickerStyle(MenuPickerStyle()).padding(.trailing, 5)
    //                            Button(proportionalmodel.minusinput[index].mode.modetext){
    //                                Proportionalcircuitmodel.convertmode(mode: &proportionalmodel.minusinput[index].mode)
    //                            }.padding(.trailing, 5)
                                Text("U-\(index):")
                                TextField("", text: $proportionalmodel.minusinputpeaktext[index])
                                    .background(Color.gray.opacity(0.3).cornerRadius(1))
                                    .frame(width:geometry.size.width/8)
                                    .keyboardType(.numbersAndPunctuation)
                                Text("V").padding(.trailing,5)
                                if proportionalmodel.minusinput[index].mode.rawValue != 0 {
                                    Text("f:").padding(.trailing,5)
                                    TextField("", text: $proportionalmodel.minusinputfrequencytext[index])
                                        .background(Color.gray.opacity(0.3).cornerRadius(1))
                                        .frame(width:geometry.size.width/8)
                                        .keyboardType(.numbersAndPunctuation)
                                    Text(" HZ")
                                }

                            }.padding(.bottom,5)
                        }

                    }
                    .padding(.leading,3)

                }
                HStack(spacing:.zero) {
                    if proportionalmodel.inputpresent {
                        Button {
                            proportionalmodel.returntoresistance()
                        } label: {
                            Text(Usermodel.Language ? "取消" : "Cancel")
                                .foregroundColor(.primary)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle(radius: 1))
                        .accentColor(Color.red)
                    }
                    Button {
                        if proportionalmodel.inputpresent{
                            showalert=true
                        }
                        proportionalmodel.confirmvalue()
                        appmodel.proportionalupdatetext(ratext: proportionalmodel.resistanceatext, rftext: proportionalmodel.resistanceftext, plusresistancetext: proportionalmodel.resistanceplustext, minusresistancetext: proportionalmodel.resistanceminustext)
                    } label: {
                        Text(Usermodel.Language ? "确认" : "Confirm")
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 1))
                    .accentColor(proportionalmodel.valuelegal() ? Color.accentColor : Color.gray)
                    .disabled(!proportionalmodel.valuelegal())
                }
            }
        }
        .background(Color.white.opacity(0.8).cornerRadius(5))
        .offset(y: -geometry.size.height*0.08)
        .alert(isPresented: $showalert) {
            Alert(
                title: Text(Usermodel.Language ? "即将展示仿真图像" : "Chart ready to display"),
                primaryButton: .destructive(
                    Text(Usermodel.Language ? "取消" : "Cancel").foregroundColor(.red)
                ) {
                    proportionalmodel.inputpresent=true
                    proportionalmodel.resistancepresent=false
                },
                secondaryButton: .default(
                    Text(Usermodel.Language ? "好的" : "OK")
                ){
                    proportionalmodel.chartpresent=true
                }
            )
        }
        .onChange(of: geometry.size) { value in
            guard proportionalmodel.chartpresent else {return}
            proportionalmodel.chartpresent=false
            proportionalmodel.inputpresent=false
            proportionalmodel.resistancepresent=true
        }
    }
}
