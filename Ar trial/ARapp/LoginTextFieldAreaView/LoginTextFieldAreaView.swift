//
//  LoginTextFieldAreaView.swift
//  Ar trial
//
//  Created by niudan on 2023/5/5.
//
import Foundation
import SwiftUI

struct LoginTextFieldAreaView: View {
    let TextFieldWidth:CGFloat?
    let TextFieldLeadingLabel:[String]
    let TextFieldTypeisSecure:[Bool]
    var TextFieldtext:[Binding<String>]
    let TextFieldkeyboardtype:[UIKeyboardType]
    @State var TextFieldSecure:[Bool]
    let InputLegal:Bool
    init(width:CGFloat?,
         TextFieldLeadingLabel:[String],
         TextFieldTypeisSecure:[Bool],
         TextFieldtext:[Binding<String>],
         TextFieldkeyboardtype:[Int])
    {
        TextFieldWidth=width
        self.TextFieldLeadingLabel=TextFieldLeadingLabel
        self.TextFieldTypeisSecure=TextFieldTypeisSecure
        self.TextFieldtext=TextFieldtext
        self.TextFieldkeyboardtype=TextFieldkeyboardtype.map{
            UIKeyboardType(rawValue: $0) ?? UIKeyboardType.default
        }
        TextFieldSecure=Array(repeating: true, count: TextFieldLeadingLabel.count)
        let Length:[Int]=[TextFieldLeadingLabel.count,TextFieldTypeisSecure.count,TextFieldtext.count]
        if Length.max() == Length.min(){
            InputLegal=true
        }else{
            InputLegal=false
        }
    }
    
    var body: some View {
        VStack(alignment: .trailing){
            if InputLegal{
                ForEach(0..<TextFieldLeadingLabel.count,id: \.self){index in
                    HStack(spacing:.zero){
                        Text(TextFieldLeadingLabel[index]+":")
                        ZStack{
                            if TextFieldTypeisSecure[index]{
                                SecureField("", text: TextFieldtext[index])
                                    .keyboardType(TextFieldkeyboardtype[index])
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                TextField("", text: TextFieldtext[index])
                                    .keyboardType(TextFieldkeyboardtype[index])
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .opacity(TextFieldSecure[index] ? 0 : 1)
                            }else{
                                TextField("", text: TextFieldtext[index])
                                    .keyboardType(TextFieldkeyboardtype[index])
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                        .lineLimit(1)
                        .frame(width:TextFieldWidth)
                        .padding(.horizontal,5)
                        
                        if TextFieldTypeisSecure[index] {
                            Button {
                                TextFieldSecure[index].toggle()
                            } label: {
                                Image(systemName: TextFieldSecure[index] ? "eye.slash" : "eye")
                                    .foregroundColor(.accentColor)
                            }.controlSize(ControlSize.large)
                        }else{
                            Button {

                            } label: {
                                Image(systemName: "eye")
                                    .foregroundColor(.accentColor)
                            }.disabled(true).controlSize(ControlSize.large).hidden()
                        }
                        
                    }
                }
            }else{
            }
            
            
        }
        
            
        }
    
}
