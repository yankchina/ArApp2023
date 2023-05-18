//
//  ARappmodel.swift
//  Ar trial
//
//  Created by niudan on 2023/3/21.
//

import SwiftUI
import RealityKit
import CoreData
import Combine

/// The modes of AR
enum scanmode:String{
    case free="Free Scanning"
    case Squarewavegenerator="Squarewave generator"
    case SquarewaveDRgenerator="Duty ratio adjustable squarewave generator"
    case Secondorder="Second order filter"
    case Sequence="Sequence generator"
}
extension scanmode{
    
}


//MARK: ARappARpartmodel
/// The model that stores data of the ARscan part
class ARappARpartmodel:ObservableObject{
    
    
    
    //MARK: parameters
    //coredata
    let container: NSPersistentContainer
    @Published var ARapptipEntity: [Tip]
    @Published var Tipconfirmed:Bool
    let Tipnumber:Int
    //AR part variables
    let scaaningmodes:[scanmode]
    let scanmodeindex:[scanmode:Int]
    @Published var SquarewaveGeneratorAnchor:Squarewave.Box
    @Published var SquarewaveDRGeneratorAnchor:SquarewaveDR.Box
    @Published var SecondorderfilterAnchor:Secondorderfilter.Box
    @Published var SequencegeneratorAnchor:Sequencegenerator.Box
    
    //MARK: initiate
    init() {
        scaaningmodes=[scanmode.free,.Squarewavegenerator,.Secondorder,.Sequence]
        scanmodeindex=[.Squarewavegenerator:0,.SquarewaveDRgenerator:1,.Secondorder:2,.Sequence:3]
        SquarewaveGeneratorAnchor=try! Squarewave.loadBox()
        SquarewaveDRGeneratorAnchor=try! SquarewaveDR.loadBox()
        SecondorderfilterAnchor=try! Secondorderfilter.loadBox()
        SequencegeneratorAnchor=try! Sequencegenerator.loadBox()
        container = NSPersistentContainer(name: "ARAppdata")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            }
        }
        Tipconfirmed=true
        ARapptipEntity=[]
        Tipnumber=4
        fetchtipviewed()
        Updatetipstatus()
        print("init")
    }
    deinit {
        print("deinit")
    }
    
    //MARK: functions
    /// Fetch coredata
    func fetchtipviewed() {
        let request = NSFetchRequest<Tip>(entityName: "Tip")
        
        do {
            ARapptipEntity = try container.viewContext.fetch(request)
            if ARapptipEntity.count == 0{
                let tip1=Tip(context: container.viewContext)
                tip1.tipviewed=false
                let tip2=Tip(context: container.viewContext)
                tip2.tipviewed=false
                let tip3=Tip(context: container.viewContext)
                tip3.tipviewed=false
                let tip4=Tip(context: container.viewContext)
                tip4.tipviewed=false
                do {
                    try container.viewContext.save()
                    let request1 = NSFetchRequest<Tip>(entityName: "Tip")
                    ARapptipEntity = try container.viewContext.fetch(request1)
                } catch let error {
                    print("Error saving. \(error)")
                }
            }
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    /// Save coredata
    func SaveTipData() {
        do {
            try container.viewContext.save()
            fetchtipviewed()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    func Updatetipstatus()->Void{
        for index in 0..<Tipnumber {
            if !ARapptipEntity[index].tipviewed {
                Tipconfirmed=false
                return 
            }
        }
        Tipconfirmed=true
    }
    /// Add lights to AR anchors
    func addlight()->Void{
        func generatedirectionallight()->DirectionalLight{
            let returnlight:DirectionalLight=DirectionalLight()
            returnlight.look(at: [0,-1000,0], from: [0,1000,0], relativeTo: nil)
            return returnlight
        }
        SquarewaveGeneratorAnchor.addChild(generatedirectionallight())
        SquarewaveDRGeneratorAnchor.addChild(generatedirectionallight())
        SecondorderfilterAnchor.addChild(generatedirectionallight())
        SequencegeneratorAnchor.addChild(generatedirectionallight())
    }
    
    /// Add anchors to AR scene
    func addanchor(ARview:ARView,mode:scanmode)->Void{
        let Anchors:[HasAnchoring]=[SquarewaveGeneratorAnchor,SquarewaveDRGeneratorAnchor,SecondorderfilterAnchor,SequencegeneratorAnchor]
        switch mode {
        case .free:
            ARview.scene.anchors.append(contentsOf: Anchors)
        default:ARview.scene.anchors.append(Anchors[scanmodeindex[mode]!])
        }
    }
    
    //MARK: Updatetext
    //proportional update resistance text
//    func proportionalupdatetext(ratext:String,rftext:String,plusresistancetext:[String],minusresistancetext:[String])->Void{
//        var material=SimpleMaterial()
//        material.color = .init(tint:.yellow)
//        // update ra
//        var textentity:Entity=SecondorderfilterAnchor.circuit!.findEntity(named: "ra")!.children[0].children[0]
//        var textmodelcomponent:ModelComponent=(textentity.components[ModelComponent.self])!
//        textmodelcomponent.materials[0]=material
//        textmodelcomponent.mesh = .generateText(ratext.appending("𝛀"), extrusionDepth: 0.001, font: .systemFont(ofSize: 0.02))
//        textentity.position=[-0.01,-0.01,0]
//        textentity.components.set(textmodelcomponent)
//        //update rf
//        textentity=SecondorderfilterAnchor.circuit!.findEntity(named: "rf")!.children[0].children[0]
//        textmodelcomponent=(textentity.components[ModelComponent.self])!
//        textmodelcomponent.materials[0]=material
//        textmodelcomponent.mesh = .generateText(rftext.appending("𝛀"), extrusionDepth: 0.001, font: .systemFont(ofSize: 0.02))
//        textentity.position=[0,-0.01,0]
//        textentity.components.set(textmodelcomponent)
//        //update plusinput resistance
//        for index in plusresistancetext.indices {
//            textentity=SecondorderfilterAnchor.circuit!.findEntity(named: "rp\(index)")!.children[0].children[0]
//            textmodelcomponent=(textentity.components[ModelComponent.self])!
//            textmodelcomponent.materials[0]=material
//            textmodelcomponent.mesh = .generateText(plusresistancetext[index].appending("𝛀"), extrusionDepth: 0.001, font: .systemFont(ofSize: 0.02))
//            textentity.position=[0.01,0,0.01]
//            textentity.components.set(textmodelcomponent)
//        }
//        //update minusinput resistance
//        for index in minusresistancetext.indices {
//            textentity=SecondorderfilterAnchor.circuit!.findEntity(named: "rm\(index)")!.children[0].children[0]
//            textmodelcomponent=(textentity.components[ModelComponent.self])!
//            textmodelcomponent.materials[0]=material
//            textmodelcomponent.mesh = .generateText(minusresistancetext[index].appending("𝛀"), extrusionDepth: 0.001, font: .systemFont(ofSize: 0.02))
//            textentity.position=[0.01,0,0.01]
//            textentity.components.set(textmodelcomponent)
//        }
//        
//    }
    
    //MARK: Enable gesture
    /// Enable gestures on anchors that temporarily contain no tapping behaviour
    func enablegesture(arView:ARView,mode:scanmode) -> Void {
        switch mode {
        case .Squarewavegenerator:
            let model=SquarewaveGeneratorAnchor.generatorboard!
            model.generateCollisionShapes(recursive: true)
            arView.installGestures([.all], for: model as! (Entity & HasCollision))
        case .SquarewaveDRgenerator:
            let model=SquarewaveDRGeneratorAnchor.generator!
            model.generateCollisionShapes(recursive: true)
            arView.installGestures([.all], for: model as! (Entity & HasCollision))
        case .Secondorder:
            let filter=SecondorderfilterAnchor.filter!
            filter.generateCollisionShapes(recursive: true)
            arView.installGestures([.all], for: filter as! (Entity & HasCollision))
        default:break        
        }
    }
    
    
    
    /// Define trigger actions in AR models
    /// - Parameter Sequencemodel: Environment object Sequencemodel
    func definetriggeractions(Sequencemodel:Sequencegeneratormodel)->Void{
        //define 74138 selected notification
        for index1 in SequencegeneratorAnchor.actions.allActions.indices {
            for index2 in Sequencemodel.Select138.indices {
                if SequencegeneratorAnchor.actions.allActions[index1].identifier == "selectY\(index2)" {
                    SequencegeneratorAnchor.actions.allActions[index1].onAction={ [weak self]_  in
                        guard !Sequencemodel.simulating else { return }
                        Sequencemodel.selector138(index2)
                        for index3 in self!.SequencegeneratorAnchor.notifications.allNotifications.indices {
                            if self!.SequencegeneratorAnchor.notifications.allNotifications[index3].identifier == "respondY\(index2)"{
                                self!.SequencegeneratorAnchor.notifications.allNotifications[index3].post()
                            }
                        }
                    }
                }
            }
            for index2 in Sequencemodel.Select151.indices {
                //define 74151 D0~D7 selected(set to 0)
                if SequencegeneratorAnchor.actions.allActions[index1].identifier == "selectD\(index2)0" {
                    SequencegeneratorAnchor.actions.allActions[index1].onAction={ [weak self]_ in
                        guard !Sequencemodel.simulating else { return }
                        Sequencemodel.selector151(index2)
                        for index3 in self!.SequencegeneratorAnchor.notifications.allNotifications.indices {
                            if self!.SequencegeneratorAnchor.notifications.allNotifications[index3].identifier == "respondD\(index2)0"{
                                self!.SequencegeneratorAnchor.notifications.allNotifications[index3].post()
                            }
                        }
                    }
                }
                //define 74151 D0~D7 selected(set to 1)
                if SequencegeneratorAnchor.actions.allActions[index1].identifier == "selectD\(index2)1" {
                    SequencegeneratorAnchor.actions.allActions[index1].onAction={ [weak self]_ in
                        guard !Sequencemodel.simulating else { return }
                        Sequencemodel.selector151(index2)
                        for index3 in self!.SequencegeneratorAnchor.notifications.allNotifications.indices {
                            if self!.SequencegeneratorAnchor.notifications.allNotifications[index3].identifier == "respondD\(index2)1"{
                                self!.SequencegeneratorAnchor.notifications.allNotifications[index3].post()
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: static functions
    public static func generetemodel()->ModelEntity{
        let mesh:MeshResource = .generatePlane(width: 0.3, depth: 0.3)

        var material=SimpleMaterial()
        material.metallic = .float(1)
        material.roughness = .float(1)
        material.color = .init(tint: .white.withAlphaComponent(0.99), texture: .init(try! .load(named:"SEUlogo")))
        return ModelEntity(mesh: mesh)
        
        
    }
    
    //MARK: mode information requires editing and changing
    /// Generates mode alert when the toptrailing questionmark.circle button is pressed
    /// - Parameter mode: current scanning mode
    /// - Returns: Alert that includes related text and message
    static func generatemodeinform(mode:scanmode)->Alert{
        var text:Text=Text("")
        var message:Text?=nil
        switch mode {
        case .Secondorder:
            text=Text("")
        case .Sequence:
            text=Text("This is a sequence generator. Tap on 74138 Y0-Y7 and 74151 D0-D7 to set parameters of the generator. Tap the button on the left to see the details of the generator design.")
        default:break
        }
        return Alert(title: text, message: message, dismissButton: .default(Text("OK")))
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

//MARK: ARappMaterialpartmodel



/// The model that stores data of the ARscan part
class ARappMaterialpartmodel:ObservableObject{
    //MARK: parameters
    //coredata
    let container: NSPersistentContainer
    @Published var ARappchapterEntity: [Chapter]
    //Material part data
    @Published var imageprogress:[Int]
    @Published var chapterviewed:[Bool]
    @Published var Material:[[([Image],Int)]]
    
    //MARK: initiate
    init() {
        
        imageprogress=[0,0]
        chapterviewed=[false,false]
        Material=[]
        let chapterlength:[Int]=[47,0]
        var Materialimages:[[([Image],Int)]]=[]
        for index1 in chapterlength.indices {
            var chapterimages:[([Image],Int)] = []
            for index2 in 0..<chapterlength[index1] {
                chapterimages.append(([Image("幻灯片"+String(index2+1))],0))
            }
            Materialimages.append(chapterimages)
        }
        Material=Materialimages
        
//        Material=[[([Image("SEUlogo_dark")],0),([Image("SEUlogo"),Image("SEUlogo_dark")],0)],[([Image("SEUlogo_dark"),Image("SEUlogo")],0),([Image("SEUlogo"),Image("SEUlogo_dark")],0)]]
        container = NSPersistentContainer(name: "ARAppdata")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            }
        }
        ARappchapterEntity=[]
        fetchchapterviewed()
    }
    
    /// Fetch coredata
    func fetchchapterviewed() {
        let request = NSFetchRequest<Chapter>(entityName: "Chapter")
        
        do {
            ARappchapterEntity = try container.viewContext.fetch(request)
            if ARappchapterEntity.count == 0{
                let chapter1=Chapter(context: container.viewContext)
                chapter1.chapterviewed=false
                let chapter2=Chapter(context: container.viewContext)
                chapter2.chapterviewed=false
                do {
                    try container.viewContext.save()
                    let request1 = NSFetchRequest<Chapter>(entityName: "Chapter")
                    ARappchapterEntity = try container.viewContext.fetch(request1)
                } catch let error {
                    print("Error saving. \(error)")
                }
            }
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    /// Save coredata
    func SaveMaterialData() {
        do {
            try container.viewContext.save()
            fetchchapterviewed()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    /// Toggle chapter viewed boolean, save tap record to coredata
    /// - Parameter index: Material chapter index
    func chaptertapped(index:Int)->Void{
        chapterviewed[index]=true
        ARappchapterEntity[index].chapterviewed=true
        SaveMaterialData()
    }
    
    ///  Material go forward
    /// - Parameter chapter: Material chapter index
    func chapterforward(chapter:Int)->Void{
        if Material[chapter][imageprogress[chapter]].1 < Material[chapter][imageprogress[chapter]].0.count-1  {
            Material[chapter][imageprogress[chapter]].1 += 1
        }else if imageprogress[chapter] != Material[chapter].count-1{
            imageprogress[chapter] += 1
        }
    }
    
    ///  Material go backward
    /// - Parameter chapter: Material chapter index
    func chapterbackward(chapter:Int)->Void{
        switch (Material[chapter][imageprogress[chapter]].1 == 0,imageprogress[chapter] == 0) {
        case (true,false):
            imageprogress[chapter] -= 1
        case (false,_):Material[chapter][imageprogress[chapter]].1 -= 1
        case (true,true):break
        }
    }
    
    /// Scroll to top/bottom/image
    /// - Parameters:
    ///   - proxy: scrollview proxy
    ///   - chapter: Material chapter index
    ///   - value: scroll to position
    func scrolltoindex(proxy:ScrollViewProxy,chapter:Int,value:Int)->Void{
        withAnimation(.spring()) {
            if value==0 {
                proxy.scrollTo(value, anchor: .top)
            }else if value==Material[chapter].count-1{
                proxy.scrollTo(value, anchor: .bottom)
            }else{
                proxy.scrollTo(value, anchor: .center)
            }
        }
    }
    
    /// Scroll to top/bottom/image when the view appears
    /// - Parameters:
    ///   - proxy: scrollview proxy
    ///   - chapter: Material chapter index
    func appearscrolltoindex(proxy:ScrollViewProxy,chapter:Int)->Void{
        withAnimation(.spring()) {
            if imageprogress[chapter]==0 {
                proxy.scrollTo(0, anchor: .top)
            }else if imageprogress[chapter]==Material[chapter].count-1{
                proxy.scrollTo(Material[chapter].count-1, anchor: .bottom)
            }else{
                proxy.scrollTo(imageprogress[chapter], anchor: .center)
            }
        }
    }
    
}

