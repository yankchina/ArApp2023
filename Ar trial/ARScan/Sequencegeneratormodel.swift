//
//  Sequencegeneratormodel.swift
//  Ar trial
//
//  Created by niudan on 2023/3/30.
//

import Foundation

/// Sequence generator model, stores 74161 status, 74151 selection, 74138 selection.
class Sequencegeneratormodel:ObservableObject{
    
    // MARK: parameters
    /// 3 booleans to represent 74161 status
    @Published var Status161:[Bool]
    /// 8 booleans to represent 74151 selections
    @Published var Select151:[Bool]
    /// 8 booleans to represent 74138 selections
    @Published var Select138:[Bool]
    @Published var simulating:Bool
    /// 1 boolean to represent 74151 output
    @Published var output151:Bool?
    let Status161identifier:[String]
    // MARK: initiate
    init() {
        Select151=Array(repeating: false, count: 8)
        Select138=Array(repeating: false, count: 8)
        Status161=Array(repeating: false, count: 3)
        simulating=false
        Status161identifier=["QAstatus","QBstatus","QCstatus"]
    }
    // MARK: functions
    /// Toggle 74151 selection when D0-D7 is tapped
    /// - Parameter index: 74151 tapped index
    /// Toggle 74151 selection when Y0-Y7 is tapped, set all eight booleans false and then set the tapped boolean true
    /// - Parameter index: 74138 tapped index
    func selector138(_ index:Int){
        Select138=Array(repeating: false, count: 8)
        Select138[index]=true
    }
    /// Toggle 74151 selection when D0-D7 is tapped
    /// - Parameter index: 74151 tapped index
    func selector151(_ index:Int){
        guard !simulating else { return }
        Select151[index].toggle()
    }
    /// 74161 status proceed when input clock
    func clockinput(){
        if !simulating || (Status161.binaryinteger == Select138.firstIndex(of: true)){
            Status161=Array(repeating: false, count: 3)
            output151=Select151[Status161.binaryinteger!]
        }else{
            Status161=Status161.boolarrayplus()
            output151=Select151[Status161.binaryinteger!]
        }
    }
    
    func clear(){
        Select151=Select151.map{ _ in false }
        Select138=Select138.map{ _ in false }
        Status161=Status161.map{ _ in false }
    }
}
