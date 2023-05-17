//
//  CustomVideoPlayer.swift
//  Ar trial
//
//  Created by niudan on 2023/5/1.
//

import SwiftUI
import AVKit

struct CustomVideoPlayer:UIViewControllerRepresentable {
    var player:AVPlayer
    @Binding var update:Bool
    func makeUIViewController(context:Context) -> AVPlayerViewController {
        let controller=AVPlayerViewController()
        controller.player=player
        controller.showsPlaybackControls=false
        print("make")

        return controller
        
    }
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        if update{
            uiViewController.player=player
            uiViewController.showsPlaybackControls=false
            print("update")
            update=false
        }
    }
}
