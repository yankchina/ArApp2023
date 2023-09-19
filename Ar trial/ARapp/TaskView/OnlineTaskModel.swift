//
//  OnlineTaskModel.swift
//  Ar trial
//
//  Created by niudan on 2023/5/13.
//

import Foundation
import SwiftUI
import Combine

/// Online task struct
struct OnlineTask:Identifiable,Codable{
    /// task id
    var id:String=""
    /// task title
    var title:String
    /// task desccription
    var description:String
    /// task deadline year
    var year:Int=Calendar.current.dateComponents([.year], from: Date()).year ?? 2023
    /// task deadline month
    var month:Int=Calendar.current.dateComponents([.month], from: Date()).month ?? 1
    /// task deadline day
    var day:Int=Calendar.current.dateComponents([.day], from: Date()).day ?? 1
    /// task deadline hour
    var hour:Int=Calendar.current.dateComponents([.hour], from: Date()).hour ?? 12
    /// task deadline minute
    var minute:Int=Calendar.current.dateComponents([.minute], from: Date()).minute ?? 0
    
    /// Form task date from year/month/day/hour/minute
    /// - Returns: Task date
    func date()->Date{
        let dateformatter=DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateformatter.date(from: "\(year)-\(month)-\(day)T\(hour):\(minute):00+08:00") ?? Date()
    }
    /// Form Date string
    /// - Returns: String of task date
    func datestring()->String{
        return "\(year)-\(month)-\(day)T\(hour):\(minute):00-00:00"
    }
}




/// Model of online task part
class OnlineTaskModel:ObservableObject{
    /// Array of all tasks
    @Published var Tasks:[OnlineTask]
    /// Array of the remaining day/hour/minute/second of all tasks
    @Published var Remaining:[(Int,Int,Int,Int,Bool)]
    /// Display details of each task
    @Published var TaskDetaildisplay:[Bool]
    /// Displaying task adding View
    @Published var TaskAddingdisplay:Bool
    /// Whether a task have been successfully added
    @Published var Taskadded:Bool
    /// Task adding failure
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
    
    /// Get online tasks from server
    /// - Parameter Url: Server address
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
    
    /// Try to add task
    /// - Parameters:
    ///   - Url: Server address
    ///   - id: user id
    ///   - title: task title
    ///   - description: task description
    ///   - DeadlineDate: task DeadlineDate
    func Addtask(Url:String,id:String="",title:String,description:String,DeadlineDate:Date)->Void{
        // get date components from deadline
        let TaskDate=Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: DeadlineDate)
        guard let year=TaskDate.year,let month=TaskDate.month,let day=TaskDate.day,let hour=TaskDate.hour,let minute=TaskDate.minute else{
            return
        }
        let titlestring:String=title.converttohexcode()
        let descriptionstring:String=description.converttohexcode()
        // generate dates tring
        let datestring=Date().DatetoString("YYYY-MMM-dd-hh:mm:ss")
        let urlstring:String="http://"+Url+"/AR/Online/Tasks/Addtask?datestring="+datestring+"&id=\(id)&title=\(titlestring)&description=\(descriptionstring)&year=\(year)&month=\(month)&day=\(day)&hour=\(hour)&minute=\(minute)"
        print(urlstring)
        guard let url = URL(string: urlstring) else {
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .map{Bool(String(data:$0.data,encoding: .ascii) ?? "false")}
            .receive(on: DispatchQueue.main)
            .sink{[weak self]_ in}receiveValue:{[weak self] returnvalue in
                guard let unwrappedreturnvalue = returnvalue else{
//                    print("fail")
                    return
                }
                self?.Taskadded = unwrappedreturnvalue
                if !unwrappedreturnvalue{
                    self?.TaskAddingFail=true
                }
            }
            .store(in: &cancellables)
    }
    
    /// Try to delete task
    /// - Parameters:
    ///   - Url: Server address
    ///   - taskindex: Index of the task
    func Deletetask(Url:String,taskindex:Int)->Void{
        // get task id
        let taskid=Tasks[taskindex].id
        let urlstring:String="http://"+Url+"/AR/Online/Tasks/Deletetask?id="+taskid
        print(urlstring)
        guard let url = URL(string: urlstring) else {
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .map{Bool(String(data:$0.data,encoding: .ascii) ?? "false")}
            .receive(on: DispatchQueue.main)
            .sink{[weak self]_ in}receiveValue:{[weak self] returnvalue in
                guard let unwrappedreturnvalue = returnvalue else{
//                    print("fail")
                    return
                }
                self?.TaskDeletingSuccess=unwrappedreturnvalue
                self?.TaskDeletingResponseReceive=true
            }
            .store(in: &cancellables)
    }

    
    
    /// Update remaining time of all tasks
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
