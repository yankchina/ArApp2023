//
//  LoginTextFieldAreaView.swift
//  Ar trial
//
//  Created by niudan on 2023/5/5.
//
import Foundation
import SwiftUI

/// Login TextFields View
struct LoginTextFieldAreaView: View {
    /// Width of all TextField
    let TextFieldWidth:CGFloat?
    /// Leading description of TextField binding text
    let TextFieldLeadingLabel:[String]
    /// Whether each TextField enables secure mode
    let TextFieldTypeisSecure:[Bool]
    /// Binding text of each TextField
    var TextFieldtext:[Binding<String>]
    /// KeyboardType of each TextField
    let TextFieldkeyboardtype:[UIKeyboardType]
    /// Each TextField is in secure mode
    @State var TextFieldSecure:[Bool]
    /// Whether input is valid
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
