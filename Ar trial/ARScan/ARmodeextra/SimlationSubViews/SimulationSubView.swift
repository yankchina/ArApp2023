//
//  InputbackgroundView.swift
//  Ar trial
//
//  Created by niudan on 2023/5/17.
//

import SwiftUI


struct StartButton:View{
    @EnvironmentObject var Usermodel:Appusermodel
    let yoffset:CGFloat
    let Buttonaction:()->Void
    var body: some View{
        ZStack{
            Button(action: Buttonaction) {
                Text(Usermodel.Language ? "仿真" : "Simulation")
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 2))
            .offset(y:yoffset)
        }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomTrailing)

    }
}
struct InputbackgroundView: View {
    var body:some View{
        RoundedRectangle(cornerRadius: 3).fill(Color.BackgroundprimaryColor.opacity(0.9))
    }
}
struct SimulationImagebackgroundView: View {
    var body:some View{
        RoundedRectangle(cornerRadius: 3).fill(Color.BackgroundprimaryColor.opacity(0.9))
    }
}
struct InputupperLabel: View {
    let backwardButtonaction:()->Void
    var body:some View{
        HStack{
            Button(action: backwardButtonaction) {
                Image(systemName: "chevron.down")
                    .font(.title2)
            }
            Spacer()
        }.padding(.bottom,5)
    }
}

struct StoptimeTextField: View {
    let leadingtext:String
    @Binding var Stoptimetext:String
    let unittext:String
    let TextfieldWidth:CGFloat?
    var TextFieldKeyboardTyperawValue:Int = 0
    var body:some View{
        HStack{
            Text(leadingtext)
            TextField("", text: $Stoptimetext)
                .keyboardType(UIKeyboardType(rawValue: TextFieldKeyboardTyperawValue) ?? .default)
                .frame(width:TextfieldWidth)
                .background(Color.gray.opacity(0.3).cornerRadius(1))
            Text(unittext)
        }.padding(.vertical,5)
    }
}
struct InputSlider: View {
    let leadingtext:String
    @Binding var Slidervalue:Double
    let minimumValue:Double
    let maximumValue:Double
    let SlidervalueStep:Double
    var ValueLabelDecimalplaces:Int=0
    let unittext:String
    var body:some View{
        HStack{
            Text(leadingtext)
            Slider(value: $Slidervalue, in: minimumValue...maximumValue, step: SlidervalueStep, label: {Text("")},
                   minimumValueLabel: {
                Text(String(format: "%.\(ValueLabelDecimalplaces)f",minimumValue))
            },
                   maximumValueLabel: {
                Text(String(format: "%.\(ValueLabelDecimalplaces)f",maximumValue))
            }) { _ in}
            Text(String(format: "%.\(ValueLabelDecimalplaces)f", Slidervalue)+unittext)
        }.padding(.vertical,5)

    }
}
struct InputConfirmButton: View {
    @EnvironmentObject var Usermodel:Appusermodel
    let Buttondisable:Bool
    let Buttonaction:()->Void
    var body:some View{
        Button(action: Buttonaction) {
            Text(Usermodel.Language ? "确认" : "Confirm")
                .foregroundColor(Buttondisable ? Color.secondary:Color.white)
        }
        .disabled(Buttondisable)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 1))
    }
}

struct SimulationImageupperLabel: View {
    let RefreshButtondisable:Bool
    let imagezoom:Bool
    let backwardButtonaction:()->Void
    let refreshButtonaction:()->Void
    let zoomButtonaction:()->Void
    var body:some View{
        HStack{
            Button(action: backwardButtonaction) {
                Image(systemName: "arrow.left")
                    .font(.title2)
            }.padding(.trailing,5)
            Button(action:refreshButtonaction){
                Image(systemName: "arrow.clockwise")
                    .font(.title2)
                    .foregroundColor(RefreshButtondisable ? .secondary : .accentColor)
            }
            .padding(.trailing,5)
            .disabled(RefreshButtondisable)
            Button(action:zoomButtonaction){
                Image(systemName:imagezoom ? "arrow.down.right.and.arrow.up.left":"arrow.up.left.and.arrow.down.right")
                    .font(.title2)
            }
            .padding(.trailing,5)
            Spacer()
        }
    }
}

