//
//  TaskDetailView.swift
//  Ar trial
//
//  Created by niudan on 2023/5/14.
//

import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var OnlineTaskmodel:OnlineTaskModel
    @EnvironmentObject var Usermodel:Appusermodel
    let Taskindex:Int
    @State var showdeletefailalert:Bool=false
    var body: some View {
        let task=OnlineTaskmodel.Tasks[Taskindex]
        let taskremaining=OnlineTaskmodel.Remaining[Taskindex]
        VStack(alignment: .leading){
            if Usermodel.user.authority > 0{
                HStack{
                    Spacer()
                    Button{
                        OnlineTaskmodel.Deletetask(Url: Usermodel.user.simulationurl, taskindex: Taskindex)
                    }label:{
                        Text("Delete task")
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 3))
                    .accentColor(Color.red)
                }
            }
            Text(task.title).font(.title).foregroundColor(.accentColor)
            Text("\(taskremaining.0)d:\(taskremaining.1):\(taskremaining.2):\(taskremaining.3)").font(.title2)
            Text(task.description).font(.title3)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .onDisappear{
            OnlineTaskmodel.Gettasks(Url: Usermodel.user.simulationurl)
        }
        .alert(isPresented: $OnlineTaskmodel.TaskDeletingResponseReceive) {
            Alert(title: OnlineTaskmodel.TaskDeletingSuccess == nil ? Text("") :  OnlineTaskmodel.TaskDeletingSuccess! ? Text("Task delete success") : Text("Task delete fail"), dismissButton: .default(Text("OK")){
                if let TaskDeletingSuccess=OnlineTaskmodel.TaskDeletingSuccess{
                    if TaskDeletingSuccess{
                        OnlineTaskmodel.TaskDetaildisplay[Taskindex].toggle()
                    }
                }
                OnlineTaskmodel.TaskDeletingSuccess=nil
            })
        }
    }
}

