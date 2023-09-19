//
//  VideoView.swift
//  Ar trial
//
//  Created by niudan on 2023/5/1.
//

import SwiftUI
import AVFoundation
import AVKit

struct VideoView: View {
    @State var player:AVPlayer?
    = {
        if let bundle=Bundle.main.path(forResource: "ARtrial", ofType: "mp4"){
            return .init(url: URL(fileURLWithPath: bundle))
        }
        return nil
    }()
    @State var update:Bool=false
    @State var showPlayerControls:Bool = true
    @State var isplaying:Bool = false
    @State var timeout:DispatchWorkItem?
    @State var playfinished:Bool = false
    var timeoutduration:Double
    @State var VideoURL:URL?
    init(Resource:String,timeoutduration:Double) {
        self.timeoutduration = timeoutduration
        if let bundle=Bundle.main.path(forResource: Resource, ofType: "mp4"){
            player = .init(url: URL(fileURLWithPath: bundle))
            print("success")
            VideoURL=URL(fileURLWithPath: bundle)

        }
    }
    
//    @GestureState var isdragging:Bool=false
    @State var isdragging:Bool=false
    @State var progress:CGFloat=0
    @State var lastdragprogress:CGFloat=0

    var body: some View {
        GeometryReader{geometry in
            ZStack{
                VStack{
                    VideoPlayer(player: player)
                        .onAppear {
                        }
                    
                    Spacer()
//                    if let player=player{
//                        CustomVideoPlayer(player: player, update: $update)
//                            .overlay{
//                                Rectangle().fill(Color.black.opacity(0.4))
//                                    .opacity(showPlayerControls || isdragging ? 1 : 0)
//                                    .animation(.spring(), value: isdragging)
//                                    .overlay{
//                                        Playbackcontrols()
//                                    }
//                            }
//                            .onTapGesture {
//                                withAnimation(.spring()) {
//                                    showPlayerControls.toggle()
//                                }
//                                if isplaying{
//                                    timeoutoperation()
//                                }
//                            }
//                            .overlay(alignment: .bottom){
//                                Slider(value: $progress, in: 0...1, step: 0.01) {
//                                    Text("Video Progress")
//                                } onEditingChanged: { editing in
//                                    isdragging=editing
//                                }.tint(.red)
//
//    //                            VideoSeekerView(geometry.size)
//                            }
//                            .frame(width: geometry.size.width)
//                    }
                }.onChange(of: progress){ _ in
                    if isdragging {
                        if timeout != nil{
                            timeout?.cancel()
                        }
                    }
                    
                }
                .onChange(of: isdragging) { value in
                    if !value{
                        let draggedprogress=progress
                        if let currentPlayerItem=player?.currentItem{
                            let totalDuration=currentPlayerItem.duration.seconds
                            player?.seek(to: .init(seconds: totalDuration*draggedprogress, preferredTimescale: 1))
                        }
                        if isplaying{
                            timeoutoperation()
                        }
                    }
                }
                .onAppear {
                    player?.addPeriodicTimeObserver(forInterval: .init(seconds: 1, preferredTimescale: 1), queue: .main){ time in
                        if let currentPlayerItem=player?.currentItem{
                            guard let currentDuration=player?.currentTime().seconds else{return}
                            let totalDuration=currentPlayerItem.duration.seconds
                            if !isdragging{
                                progress=currentDuration/totalDuration
                            }
                            if currentDuration == totalDuration{
                                playfinished=true
                                isplaying=false
                                showPlayerControls=true
                            }
                        }
                    }
                }
//                VStack{
//                    Text(playfinished.description)
//                    Text(isplaying.description)
//                    Text(isdragging.description)
//                    Text(showPlayerControls.description)
//                }
            }
            
        }
    }
    
    @ViewBuilder
    func VideoSeekerView(_ videosize:CGSize)->some View{
        ZStack(alignment: .leading){
            Rectangle().fill(.gray)
            Rectangle().fill(.red)
                .frame(width: videosize.width*progress)

        }.frame(height:2)
            .overlay(alignment: .leading) {
                Circle().fill(.red)
            }
    }
    
    @ViewBuilder
    func Playbackcontrols()->some View{
        Button {
            if playfinished {
                playfinished=false
                player?.seek(to: .zero)
                progress = .zero
            }
            withAnimation(.spring()) {
                isplaying.toggle()
            }
            if isplaying{
                player?.play()
                timeoutoperation()
            }else{
                player?.pause()
                if timeout != nil{
                    timeout?.cancel()
                }
            }
        } label: {
            Image(systemName: playfinished ? "arrow.clockwise" : (isplaying ? "pause.fill":"play.fill"))
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background{
                    Circle().fill(.black.opacity(0.3))
                }
        }.opacity(showPlayerControls && !isdragging ? 1:0)
            .animation(.spring(), value: showPlayerControls && !isdragging)

    }
    
    func timeoutoperation(){
        if timeout != nil{
            timeout?.cancel()
        }
        timeout = .init{
            withAnimation(.spring()) {
                showPlayerControls = false
            }
        }
        if timeout != nil{
            DispatchQueue.main.asyncAfter(deadline: .now()+timeoutduration, execute: timeout!)
            
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
