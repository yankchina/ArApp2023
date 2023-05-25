//
//  ArappLoginView.swift
//  Ar trial
//
//  Created by niudan on 2023/4/30.
//

import SwiftUI
import UIKit
import RealityKit

/// Login View, displays when appstatus == 0
struct ArappLoginView: View {
    /// Usermodel passed in by ContentView
    @EnvironmentObject var Usermodel:Appusermodel
    
    //MARK: body
    var body: some View {
        GeometryReader{geometry in
            HStack{
                Spacer()
                VStack{
                    //Upper image
                    Image("SEUlogo").resizable().aspectRatio(nil, contentMode: .fit)
                        .frame(width:geometry.size.width*0.4)
                    //Login TextFields
                    LoginTextFieldAreaView(
                        width: geometry.size.width*0.5,
                        TextFieldLeadingLabel: Usermodel.Language ? [
                         "用户名",
                         "密码",
                         "服务器地址"
                        ] :
                         [
                         "Username",
                         "Password",
                         "URL"
                        ],
                        TextFieldTypeisSecure: [false,true,true],
                        TextFieldtext: [$Usermodel.user.id,$Usermodel.user.password,$Usermodel.user.simulationurl],
                        TextFieldkeyboardtype: [0,0,2]
                    )
                    //Clear Button and Login Button
                    HStack{
                        Button(action: Usermodel.clearlogintype) {
                            Text(Usermodel.Language ? "清空" : "Clear")
                                .foregroundColor(Color.BackgroundprimaryColor)
                        }.disabled(false)
                            .padding()
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        Button(action: {
                            if Usermodel.user.id == "2",Usermodel.user.password == "2"{
                                Usermodel.appstatus=1
                                Usermodel.signinbuttonable=true
                            }else{
                                Usermodel.loginconfirm()
                            }
                        }) {
                            Text(Usermodel.Language ? "登录" : "Log in")
                                .foregroundColor(!Usermodel.signinbuttonable ? Color.secondary:Color.BackgroundprimaryColor)
                        }.disabled(!Usermodel.signinbuttonable || !Usermodel.Simulationurllegal())
                            .padding()
                            .background(!Usermodel.signinbuttonable || !Usermodel.Simulationurllegal() ? Color.secondary.opacity(0.7) : Color.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    //Signup button
                    Button(action: {Usermodel.UserSignup.toggle()}) {
                        Text(Usermodel.Language ? "注册" : "Sign up")
                    }
                    .padding()
                    .background(Capsule().stroke())
                    .foregroundColor(Color.accentColor)
                    .padding(.top)

                    
                    Spacer()
                }
                Spacer()
            }
            

        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Toggle(isOn: $Usermodel.Language) {
                    Text("")
                }
                .toggleStyle(.switch)
            }
        }
        .blurredSheet(Usermodel.blurredShapestyle, show: $Usermodel.UserSignup){

        }content: {
            ARappSignupView()
        }
        
        .alert(isPresented: $Usermodel.loginfailalert) {
            Alert(
                title: Text(Usermodel.Language ? "登录失败" : "Failed to log in."),
                message: nil,
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct ArappLoginViewiOS16: View {
    @EnvironmentObject var Usermodel:Appusermodel
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationView{
                GeometryReader{geometry in
                    HStack{
                        Spacer()
                        VStack{
                            Image("SEUlogo").resizable().aspectRatio(nil, contentMode: .fit)
                                .frame(width:geometry.size.width*0.4)
                            LoginTextFieldAreaView(width: geometry.size.width*0.5, TextFieldLeadingLabel: ["Username","Password","URL"], TextFieldTypeisSecure: [false,true,true], TextFieldtext: [$Usermodel.user.id,$Usermodel.user.password,$Usermodel.user.simulationurl], TextFieldkeyboardtype: [0,0,2])
                            HStack{
                                Button(action: Usermodel.clearlogintype) {
                                    Text("Clear")
                                        .foregroundColor(.white)
                                }.disabled(false)
                                    .padding()
                                    .background(Color.red)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                
                                Button(action: {
                                    if Usermodel.user.id == "2",Usermodel.user.password == "2"{
                                        Usermodel.appstatus=1
                                        Usermodel.signinbuttonable=true
                                    }else{
                                        Usermodel.loginconfirm()
                                    }
                                }) {
                                    Text("Log in")
                                        .foregroundColor(!Usermodel.signinbuttonable ? Color.secondary:Color.white)
                                }.disabled(!Usermodel.signinbuttonable || !Usermodel.Simulationurllegal())
                                    .padding()
                                    .background(!Usermodel.signinbuttonable || !Usermodel.Simulationurllegal() ? Color.secondary.opacity(0.7) : Color.accentColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                            NavigationLink(destination: ARappSignupView()) {
                                Text("Sign up")
                                    .padding()
                                    .background(Capsule().stroke())
                                    .foregroundColor(Color.accentColor)
                                    .padding(.top)
                                
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                    
                    
                }
                .alert(isPresented: $Usermodel.loginfailalert) {
                    Alert(title: Text("Failed to log in."), message: nil, dismissButton: .default(Text("OK")))
                }
                
            }
        } else {
            GeometryReader{geometry in
                HStack{
                    Spacer()
                    VStack{
                        Image("SEUlogo").resizable().aspectRatio(nil, contentMode: .fit)
                            .frame(width:geometry.size.width*0.4)
                        LoginTextFieldAreaView(width: geometry.size.width*0.5, TextFieldLeadingLabel: ["Username","Password","URL"], TextFieldTypeisSecure: [false,true,true], TextFieldtext: [$Usermodel.user.id,$Usermodel.user.password,$Usermodel.user.simulationurl], TextFieldkeyboardtype: [0,0,2])
                        HStack{
                            Button(action: Usermodel.clearlogintype) {
                                Text("Clear")
                                    .foregroundColor(.white)
                            }.disabled(false)
                                .padding()
                                .background(Color.red)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                            Button(action: {
                                if Usermodel.user.id == "2",Usermodel.user.password == "2"{
                                    Usermodel.appstatus=1
                                    Usermodel.signinbuttonable=true
                                }else{
                                    Usermodel.loginconfirm()
                                }
                            }) {
                                Text("Log in")
                                    .foregroundColor(!Usermodel.signinbuttonable ? Color.secondary:Color.white)
                            }.disabled(!Usermodel.signinbuttonable || !Usermodel.Simulationurllegal())
                                .padding()
                                .background(!Usermodel.signinbuttonable || !Usermodel.Simulationurllegal() ? Color.secondary.opacity(0.7) : Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        Button(action: {Usermodel.UserSignup.toggle()}) {
                            Text("Sign up")
                        }
                        .padding()
                        .background(Capsule().stroke())
                        .foregroundColor(Color.accentColor)
                        .padding(.top)
                        
                        
                        Spacer()
                    }
                    Spacer()
                }
                
                
            }
            .blurredSheet(.init(.ultraThinMaterial), show: $Usermodel.UserSignup){
                
            }content: {
                ARappSignupView()
            }
            
            .alert(isPresented: $Usermodel.loginfailalert) {
                Alert(title: Text("Failed to log in."), message: nil, dismissButton: .default(Text("OK")))
            }

        }
    }
}
