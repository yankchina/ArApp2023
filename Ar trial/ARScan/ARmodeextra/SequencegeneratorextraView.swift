//
//  SequencegeneratorextraView.swift
//  Ar trial
//
//  Created by niudan on 2023/3/30.
//

import SwiftUI

struct SequencegeneratorextraView: View {
    @ObservedObject var appmodel:ARappARpartmodel
    @ObservedObject var Sequencemodel:Sequencegeneratormodel
    @State var display:Bool=false
    @State var Imagemagnifyamount:CGFloat=0
    @State var Imagemagnifylastamount:CGFloat=0
    var body: some View {
        GeometryReader{geometry in
            ZStack{
                ZStack{
                    VStack{
                        Button {// button to start and stop simulation
                            //simulation status toggle
                            Sequencemodel.simulating.toggle()
                            //reset 161stastus to 000
                            Sequencemodel.Status161=Array(repeating: false, count: 3)
                            appmodel.SequencegeneratorAnchor.notifications.qAstatus0.post()
                            appmodel.SequencegeneratorAnchor.notifications.qBstatus0.post()
                            appmodel.SequencegeneratorAnchor.notifications.qCstatus0.post()
                            //adjust 74151 output according to 74151 selection
                            if Sequencemodel.Select151[0]{
                                Sequencemodel.output151=true
                                appmodel.SequencegeneratorAnchor.notifications.output1.post()
                            }else{
                                Sequencemodel.output151=false
                                appmodel.SequencegeneratorAnchor.notifications.output0.post()
                            }
                        } label: {
                            Image(systemName: Sequencemodel.simulating ? "pause.circle":"play.circle")
                                .foregroundColor(Color.accentColor)
                                .font(.title)
                        }
                        if Sequencemodel.simulating{
                            Button {// button to manually input clock signal
                                //74151 status proceed, change 74151 output
                                Sequencemodel.clockinput()
                                if Sequencemodel.output151!{
                                    appmodel.SequencegeneratorAnchor.notifications.output1.post()
                                }else{
                                    appmodel.SequencegeneratorAnchor.notifications.output0.post()
                                }
                                //use notifications to change QA~QC
                                for index1 in Sequencemodel.Status161.indices {
                                    for index2 in appmodel.SequencegeneratorAnchor.notifications.allNotifications.indices {
                                        if appmodel.SequencegeneratorAnchor.notifications.allNotifications[index2].identifier == Sequencemodel.Status161identifier[index1].appending(String(Sequencemodel.Status161[index1].relatedinteger)){
                                            appmodel.SequencegeneratorAnchor.notifications.allNotifications[index2].post()
                                        }
                                        
                                    }
                                }
                            } label: {
                                HStack(spacing:.zero){
                                    Text("CLK").foregroundColor(Color.accentColor)
                                        .font(.title2)
                                    Image(systemName: "arrow.forward.circle")
                                        .foregroundColor(Color.accentColor)
                                        .font(.title)
                                }
                                
                            }
                        }
                        
                    }
                    
                }.frame( maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                //ExtraimageView(display: $display, geometry: geometry, Imagemagnifyamount: $Imagemagnifyamount, Imagemagnifylastamount: $Imagemagnifylastamount, extraimage: Image("sequence"))
            }.frame( maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        
        
    }
}

//struct SequencegeneratorextraView_Previews: PreviewProvider {
//    static var previews: some View {
//        SequencegeneratorextraView()
//    }
//}
