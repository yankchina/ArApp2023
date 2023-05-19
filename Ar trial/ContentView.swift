//
//  ContentView.swift
//  Ar trial
//
//  Created by niudan on 2023/3/8.
//
import SwiftUI
import RealityKit
import Combine

struct ContentView : View {
    @StateObject var Usermodel:Appusermodel=Appusermodel()
    var body: some View {
        NavigationView{
            ZStack{
                switch Usermodel.appstatus {
                case 0:ArappLoginView()
                case 1:ARappmenuView()

                default: ZStack{}

                }
            }

        }
        .environmentObject(Usermodel)

        //OnlineTaskView()
//        VideoView(Resource:"ARtrial",timeoutduration:2)
//        CustomURLTypingView(Initialtext: "URL", text: $Usermodel.user.simulationurl)
        
       //DownloadJsonsquarewaveView()
        //DownloadJsonsquarewaveDRView()
//        SquarewaveextraView()
//        SquarewaveDRextraView()
//        SecondorderfilterextraView()
    }
}

//struct ARViewContainer1: UIViewRepresentable {
//
//    /// The AR mode when AR view starts
//    let startmode:scanmode?
//    @EnvironmentObject var appmodel:ARappARpartmodel
//    @EnvironmentObject var Sequencemodel:Sequencegeneratormodel
//    /// Temporal variable for updating AR mode
//    @Binding var updatemode:scanmode?
//    /// Temporal variable for updating AR mode
//    @Binding var extraviewmode:scanmode
//    func makeUIView(context: Context) -> ARView {
//        //初始化ARView
//        let arView = ARView(frame: .zero)
//        //判断电路模式是否为正常值
//        guard let scanmode=startmode else {return arView}
//        //向场景中添加环境光
//        appmodel.addlight()
//        //添加虚拟模型手势交互功能
//        appmodel.enablegesture(arView: arView, mode: scanmode)
//        //定义虚拟模型触发器行为
//        appmodel.definetriggeractions(Sequencemodel: Sequencemodel)
//        //将场景添加到ARView锚点集中
//        appmodel.addanchor(ARview: arView,mode: scanmode)
//        return arView
//    }
//    func updateUIView(_ uiView: ARView, context: Context) {
//        //利用条件绑定实时更新电路
//        if let mode=updatemode{
//            //清空ARView锚点集
//            uiView.scene.anchors.removeAll()
//            //将新的场景添加到ARView锚点集中
//            appmodel.addanchor(ARview: uiView,mode: mode)
//            //clear Sequencemodel, change extraviewmode, clear updatemode to nil
//            updatemode=nil
//            DispatchQueue.main.async {
//                Sequencemodel.clear()
//                extraviewmode=updatemode!
//                updatemode=nil
//            }
//        }
//    }
//    
//}

//func enablegesture(arView:ARView,mode:scanmode) -> Void {
//    //读取虚拟模型
//    let model=SecondorderfilterAnchor.filter!
//    //生成碰撞外形
//    model.generateCollisionShapes(recursive: true)
//    //安装手势
//    arView.installGestures([.all], for: filter as! (Entity & HasCollision))
//}

//struct ARscanView_Previews: PreviewProvider {
//    static var previews: some View {


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
