//
//  ARappSignupView.swift
//  Ar trial
//
//  Created by niudan on 2023/5/15.
//

import SwiftUI

struct ARappSignupView: View {
    @EnvironmentObject var Usermodel:Appusermodel
    @State var username:String=""
    @State var password:String=""
    @State var url:String=""
    var body: some View {
        VStack{
            if Usermodel.Signingup{
                if Usermodel.Signupsuccess == nil {
                    ProgressView()
                }else{
                    Text(Usermodel.Signupsuccess! ? "Sign up success" : "Sign up fail")
                        .font(.title)
                        .foregroundColor(Usermodel.Signupsuccess! ? .green : .red)
                }
            }else{
                Text("Registration").font(.largeTitle).bold()
                Spacer()
                Image(systemName: "person.crop.circle")
                    .resizable().scaledToFit()
                    .frame(width: 100)
                    .foregroundColor(.accentColor)
                LoginTextFieldAreaView(width: nil, TextFieldLeadingLabel: ["Username","Password","URL"], TextFieldTypeisSecure: [false,true,true], TextFieldtext: [$username,$password,$url], TextFieldkeyboardtype: [0,0,2])
                Button{
                    Usermodel.Signup(username: username, password: password, signupurl: url)
                }label: {
                    Text("Confirm")
                        .foregroundColor(.white)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.accentColor))
                Spacer()
                
            }
        }
    }
}

struct ARappSignupView_Previews: PreviewProvider {
    static var previews: some View {
        ARappSignupView()
    }
}
