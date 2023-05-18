//
//  ViewExtension.swift
//  Ar trial
//
//  Created by niudan on 2023/5/13.
//

import Foundation
import SwiftUI

extension View{
    func blurredSheet<Content:View>(_ style: AnyShapeStyle,show:Binding<Bool>,onDismiss: @escaping ()->(),@ViewBuilder content: @escaping ()->Content)->some View{
        self.sheet(isPresented: show, onDismiss: onDismiss) {
            content().background(Removebackgroundcolor())
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .background(
                    Rectangle()
                        .fill(style)
                        .ignoresSafeArea(.container,edges: .all)
                
                )
        }
    }
    
//    func scs
}


fileprivate struct Removebackgroundcolor:UIViewRepresentable{
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            uiView.superview?.superview?.backgroundColor = .clear
        }
    }
}
