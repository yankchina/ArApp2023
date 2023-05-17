//
//  OnlineTaskModel.swift
//  Ar trial
//
//  Created by niudan on 2023/5/13.
//

import Foundation
import SwiftUI
import RealityKit
import Combine

struct OnlineTask:Identifiable,Codable{
    var id:String=""
    var title:String
    var description:String
    var year:Int=Calendar.current.dateComponents([.year], from: Date()).year ?? 2023
    var month:Int=Calendar.current.dateComponents([.month], from: Date()).month ?? 1
    var day:Int=Calendar.current.dateComponents([.day], from: Date()).day ?? 1
    var hour:Int=Calendar.current.dateComponents([.hour], from: Date()).hour ?? 12
    var minute:Int=Calendar.current.dateComponents([.minute], from: Date()).minute ?? 0
    
    func date()->Date{
        let dateformatter=DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateformatter.date(from: "\(year)-\(month)-\(day)T\(hour):\(minute):00+08:00") ?? Date()
    }
    func datestring()->String{
        return "\(year)-\(month)-\(day)T\(hour):\(minute):00-00:00"
    }
}

struct TaskAddingResponse:Codable{
    var TaskAddingsuccess:Bool
}
struct TaskDeletingResponse:Codable{
    var TaskDeletingsuccess:Bool
}



class OnlineTaskModel:ObservableObject{
    @Published var Tasks:[OnlineTask]
    @Published var Remaining:[(Int,Int,Int,Int,Bool)]
    @Published var TaskDetaildisplay:[Bool]
    @Published var TaskAddingdisplay:Bool
    @Published var Taskadded:Bool
    @Published var TaskAddingFail:Bool?
    @Published var TaskDeletingResponseReceive:Bool
    @Published var TaskDeletingSuccess:Bool?
    let dateformatter:DateFormatter
    var cancellables:Set<AnyCancellable>
    //OnlineTask(title: "Initial title", description: "", year: 2023, month: 10, day: 2, hour: 5, minute: 3)
    init(){
        Tasks=[]
        Remaining=[(0,0,0,0,false)]
        TaskDetaildisplay=[false]
        TaskAddingdisplay=false
        Taskadded=false
        TaskAddingFail=nil
        TaskDeletingResponseReceive=false
        TaskDeletingSuccess=nil
        dateformatter=DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        cancellables=Set<AnyCancellable>()
    }
    
    func Gettasks(Url:String)->Void{
        let urlstring:String="http://"+Url+"/AR/Online/Tasks/Gettasks"
        guard let url = URL(string: urlstring) else {
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            //.subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(Appusermodel.handleOutput)
            .decode(type: [OnlineTask].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .sink{ [weak self] (returnedTasks) in
                self?.Tasks = returnedTasks
                self?.Tasks.sort {$0.date() <= $1.date()}
                self?.UpdateTasksremaining()
            }
            .store(in: &cancellables)
    }
    
    func Addtask(Url:String,id:String="",title:String,description:String,DeadlineDate:Date)->Void{
        let TaskDate=Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: DeadlineDate)
        guard let year=TaskDate.year,let month=TaskDate.month,let day=TaskDate.day,let hour=TaskDate.hour,let minute=TaskDate.minute else{
            return
        }
        let datestring=Date().DatetoString("YYYY-MMM-dd-hh:mm:ss")
        let urlstring:String="http://"+Url+"/AR/Online/Tasks/Addtask?datestring="+datestring+"&id=\(id)&title=\(title)&description=\(description)&year=\(year)&month=\(month)&day=\(day)&hour=\(hour)&minute=\(minute)"
        guard let url = URL(string: urlstring) else {
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            //.subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(Appusermodel.handleOutput)
            .decode(type: TaskAddingResponse.self, decoder: JSONDecoder())
            .replaceError(with: TaskAddingResponse(TaskAddingsuccess: false))
            .sink{[weak self] returnValue in
                print(returnValue.TaskAddingsuccess)
                self?.Taskadded = returnValue.TaskAddingsuccess
                if !returnValue.TaskAddingsuccess{
                    self?.TaskAddingFail=true
                }
            }
            .store(in: &cancellables)
    }
    
    func Deletetask(Url:String,taskindex:Int)->Void{
        let taskid=Tasks[taskindex].id
        let urlstring:String="http://"+Url+"/AR/Online/Tasks/Deletetask?id="+taskid
        print(urlstring)
        guard let url = URL(string: urlstring) else {
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            //.subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(Appusermodel.handleOutput)
            .decode(type: TaskDeletingResponse.self, decoder: JSONDecoder())
            .replaceError(with: TaskDeletingResponse(TaskDeletingsuccess: false))
            .sink{[weak self] returnValue in
                self?.TaskDeletingSuccess=returnValue.TaskDeletingsuccess
                self?.TaskDeletingResponseReceive=true
            }
            .store(in: &cancellables)
    }

    
    
    func UpdateTasksremaining()->Void{
        let currentdate=Date()
        Remaining=Array(repeating: (0,0,0,0,false), count: Tasks.count)
        if TaskDetaildisplay.count != Tasks.count{
            TaskDetaildisplay=Array(repeating: false, count: Tasks.count)
        }
        for index in Tasks.indices {
            let taskremaining=Calendar.current.dateComponents([.day,.hour,.minute,.second], from: currentdate,to:Tasks[index].date())
            if Tasks[index].date() <= currentdate {
                Remaining[index] = (0,0,0,0,false)
            }else if let remainingday=taskremaining.day,let remaininghour=taskremaining.hour,let remainingminute=taskremaining.minute,let remainingsecond=taskremaining.second{
                Remaining[index] = (remainingday,remaininghour,remainingminute,remainingsecond,true)
            }
        }
    }
    
    
}
