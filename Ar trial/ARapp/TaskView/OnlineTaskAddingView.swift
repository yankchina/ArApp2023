//
//  OnlineTaskAddingView.swift
//  Ar trial
//
//  Created by niudan on 2023/5/13.
//

import SwiftUI
//import RealityKit

/// View of adding online task
struct OnlineTaskAddingView: View {
    @EnvironmentObject var Usermodel:Appusermodel
    @ObservedObject var OnlineTaskmodel:OnlineTaskModel
    @State var Tasktitle:String="Title"
    @State var Taskdescription:String="Description"
    @State var TaskDate:Date=Date()
    @State var TaskAddingshowAlert:Bool=false
    @State var TaskAddingSuccessAlert:Bool=false
    @State var TaskAddingFailAlert:Bool=false
    @State var Taskadded:Bool=false
    @State var TaskAddingFail:Bool?
    let CurrentDate:Date=Date()
    let EndingDate:Date=Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()

    var body: some View {
        VStack{
            TextEditor(text: $Tasktitle).cornerRadius(3)
            TextEditor(text: $Taskdescription).cornerRadius(5)
            DatePicker(Usermodel.Language ? "选择截止日期" : "Select deadline date", selection: $TaskDate, in: CurrentDate...EndingDate, displayedComponents: [.date,.hourAndMinute])
                .accentColor(Color.red)
                .padding(.trailing,10)
            HStack{
                Spacer()
                Button{
                    TaskAddingshowAlert.toggle()
                }label:{
                    Text(Usermodel.Language ? "确认" : "Confirm")
                        .foregroundColor(OnlineTaskmodel.Taskadded ? Color.secondary:Color.white)
                }
                .disabled(OnlineTaskmodel.Taskadded)
                .padding()
                .background(OnlineTaskmodel.Taskadded ? Color.secondary.opacity(0.7) : Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                Spacer()
            }
            .overlay(alignment: .trailing){
                if OnlineTaskmodel.Taskadded{
                    HStack{
                        Text(Usermodel.Language ? "添加成功" : "Task add success")
                        Image(systemName: "checkmark.circle")
                    }.foregroundColor(.green)
                }else if let fail=OnlineTaskmodel.TaskAddingFail,fail{
                    HStack{
                        Text(Usermodel.Language ? "添加失败" : "Task add fail")
                        Image(systemName: "xmark.circle")
                    }.foregroundColor(.red)
                }
            }
            
        }
        .alert(isPresented: $TaskAddingshowAlert) {
            Alert(title: Text(Usermodel.Language ? "确认添加此项任务？" : "Are you sure to add this task？"),
                  primaryButton: .destructive(
                    Text(Usermodel.Language ? "取消" : "Cancel")
                        .foregroundColor(.red)
                  ) {},
                  secondaryButton: .default(
                    Text(Usermodel.Language ? "确认" : "OK")
                  ){
                TaskAddingFail=nil
                OnlineTaskmodel.Addtask(Url: Usermodel.user.simulationurl, id:Usermodel.user.id,title: Tasktitle, description: Taskdescription, DeadlineDate: TaskDate)
            }
            
            )
        }
        .onDisappear {
            OnlineTaskmodel.Taskadded=false
            OnlineTaskmodel.TaskAddingFail=nil
            OnlineTaskmodel.Gettasks(Url: Usermodel.user.simulationurl)
        }
//        .alert(isPresented: $TaskAddingSuccessAlert) {
//            Alert(title: Text("Task Add Success"), dismissButton: .default(Text("OK")){
//                Taskadded=true
//                OnlineTaskmodel.Gettasks(Url: Usermodel.user.simulationurl)
//            }
//            )
//        }
//        .alert(isPresented: $TaskAddingFailAlert) {
//            Alert(title: Text("Task Add Fail"), dismissButton: .default(Text("OK")){
//                OnlineTaskmodel.Gettasks(Url: Usermodel.user.simulationurl)
//            }
//            )
//        }
    }
}
