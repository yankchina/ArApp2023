//
//  Usermodel.swift
//  Ar trial
//
//  Created by niudan on 2023/5/5.
//

import Foundation
import SwiftUI
import RealityKit
import Combine

struct ArappUser:Identifiable,Codable {
    var id:String=""
    var password:String=""
    var authority:Int = -1
    var simulationurl:String=""
    var status:Bool=false
}

struct SignupResponse:Codable{
    var Signupsuccess:Bool
}

//MARK: Appusermodel
class Appusermodel:ObservableObject{
    //variables
    @Published var user: ArappUser
    @Published var appstatus:Int
    var cancellables:Set<AnyCancellable>
    @Published var signinbuttonable: Bool
    @Published var loginfailalert:Bool
    let Timereveryonesecond:Publishers.Autoconnect<Timer.TimerPublisher>
    let Timerevery15second:Publishers.Autoconnect<Timer.TimerPublisher>
    @Published var SimulationimageRefreshDisable:Bool
    @Published var refreshcount:Int
    @Published var Simulationurlsecure:Bool
    @Published var Passwordsecure:Bool
    @Published var UserSignup:Bool
    @Published var Signingup:Bool
    @Published var Signupsuccess:Bool?
    @Published var Actiondate:Date
    @Published var Receivedate:Date
    
    init(){
        user=ArappUser()
        appstatus=1
        cancellables=Set<AnyCancellable>()
        signinbuttonable=true
        loginfailalert=false
        Timereveryonesecond = Timer.publish(every: 1, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
        Timerevery15second=Timer.publish(every: 15, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
        SimulationimageRefreshDisable=false
        refreshcount=3
        Simulationurlsecure=true
        Passwordsecure=true
        UserSignup=false
        Signingup=false
        Signupsuccess=nil
        Actiondate=Date()
        Receivedate=Date()
    }
    //MARK: Functions
    func Simulationurllegal()->Bool{
        var Urllinks:[String]=user.simulationurl.Droplastblankspaces.split(separator: ".").map { String($0)}
        guard Urllinks.count == 4 else{return false}
        let Urllinkslastsplit=Urllinks.last!.split(separator: ":").map { String($0)}
        Urllinks.removeLast()
        Urllinks.append(contentsOf: Urllinkslastsplit)
        guard Urllinks.count == 5 else{return false}
        for string in Urllinks {
            if Int(string) == nil {
                return false
            }
        }
        return true
    }
    
    func clearlogintype() -> Void {
        user=ArappUser()
    }
    func loginconfirm() -> Void {
        signinbuttonable=false
        user.simulationurl.Removelastblankspaces()
        user.password.Removelastblankspaces()
        user.id.Removelastblankspaces()
        let urlstring:String="http://"+user.simulationurl+"/AR/Online/Confirm?username="+user.id+"&password="+user.password+"&url="+user.simulationurl
        guard let url = URL(string: urlstring) else {
            signinbuttonable=true
            user.authority = -1
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            //.subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(Appusermodel.handleOutput)
            .decode(type: ArappUser.self, decoder: JSONDecoder())
            .replaceError(with: user)
            .sink{ [weak self] (returnedPosts) in
                self?.signinbuttonable=true
                self?.user = returnedPosts
                if returnedPosts.authority >= 0{
                    self?.appstatus=1
                }
                else{
                    self?.loginfailalert=true
                }
            }
            .store(in: &cancellables)
    }
    
    func logout()->Void{
        let username=user.id
        user=ArappUser(id:username)
        appstatus=0
        cancellables=Set<AnyCancellable>()
        signinbuttonable=true
        loginfailalert=false
        SimulationimageRefreshDisable=false
        refreshcount=3
        Simulationurlsecure=true
        Passwordsecure=true
    }
    
    func Signup(username:String,password:String,signupurl:String)->Void{
        Signingup=true
        let urlstring:String="http://"+signupurl+"/AR/Online/Signup?username="+username+"&password="+password+"&url="+signupurl
        guard let url = URL(string: urlstring) else {
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            //.subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(Appusermodel.handleOutput)
            .decode(type: SignupResponse.self, decoder: JSONDecoder())
            .replaceError(with: SignupResponse(Signupsuccess: false))
            .sink{ [weak self] Signupresponse in
                self?.Signupsuccess=Signupresponse.Signupsuccess
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    self?.UserSignup=false
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+2.3) {
                    self?.Signingup=false
                }

            }
            .store(in: &cancellables)
    }
    func SimulationImagedisplay() -> Void {
        SimulationimageRefreshDisable=true
        refreshcount=4
    }
    
    func SimulationImageRefreshCountdown(Date:Date)->Void{
        if SimulationimageRefreshDisable{
            if refreshcount > 0{
                refreshcount -= 1
            }else{
                SimulationimageRefreshDisable=false
                refreshcount=3
            }
        }
    }
    
    static func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }

    

}
