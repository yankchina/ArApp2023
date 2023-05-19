//
//  ARMaterialView.swift
//  Ar trial
//
//  Created by niudan on 2023/3/20.
//

import SwiftUI
import RealityKit

//MARK: Material view definition
struct ARappMaterialview: View{
    
    
    //MARK: parameters
//    @Environment(\.presentationMode) var presentationMode
    //var imageset:[String]=["SEUlogo","SEUlogo_dark"]
    //@Binding var imagestemporalstorage:[Int]
    let chapter:Int
    let scrollwidthratio:CGFloat = 1/6
    @ObservedObject var appmodel:ARappMaterialpartmodel
    @State var scrolltoindex:Int = 0
    @State var scrollpresent:Bool=true
    @State var scrolloffsetx:CGFloat=0
    @State var StaticWidth:CGFloat=0
    @State var StaticHeight:CGFloat=0
    @State var LocalSizeApply:Bool=false
    //MARK: body
    var body: some View{
        GeometryReader{geometry in
            ZStack{
                HStack(spacing:.zero){
                    //MARK: Scrollview part
                    if scrollpresent{
                        ScrollView(.vertical, showsIndicators: false){
                            ScrollViewReader { proxy in
                                LazyVStack(spacing:.zero){
                                    ForEach(appmodel.Material[chapter].indices,id:\.self) { index in
                                        HStack {
                                            Text(String(index))
                                                .font(.headline)
                                            appmodel.Material[chapter][index].0[0]
                                                .resizable().scaledToFit()
                                        }.id(index)
                                            .background(appmodel.imageprogress[chapter] == index ? Color.secondary.opacity(0.5):nil)
                                            .onTapGesture {
                                                appmodel.imageprogress[chapter]=index
                                            }
                                        Rectangle().fill(Color.secondary.opacity(0.5))
                                            .frame(height:1)
                                    }
                                }
                                .onChange(of: scrolltoindex){ value in
                                    appmodel.scrolltoindex(proxy: proxy, chapter: chapter, value: value)
                                }
                                .onAppear{
                                    appmodel.appearscrolltoindex(proxy: proxy, chapter: chapter)
                                    scrolltoindex=appmodel.imageprogress[chapter]
                                }
                            }
                        }
                        .overlay{
                            VStack{
                                Button {
                                    scrolltoindex=0
                                } label: {
                                    Image(systemName: "chevron.up")
                                        .foregroundColor(Color.accentColor.opacity(0.9))
                                }
                                Spacer()
                                Button {
                                    scrolltoindex=appmodel.Material[chapter].count-1
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(Color.accentColor.opacity(0.9))
                                }
                            }
                        }
                        .frame(width:geometry.size.width*scrollwidthratio)
                        .offset(x: scrolloffsetx<0 ? scrolloffsetx:0)
                        .gesture(
                            DragGesture()
                            //拖拽过程操作定义
                                .onChanged { value in
                                    withAnimation(.spring()) {
                                        //视图水平移动被拖拽的距离
                                        scrolloffsetx=value.translation.width
                                    }
                                }
                            //拖拽结束操作定义
                                .onEnded { value in
                                    //利用动画保证流畅视觉效果
                                    withAnimation(.spring()) {
                                        //判断拖拽距离是否达到阈值
                                        if scrolloffsetx < -geometry.size.width*scrollwidthratio/3 {
                                            //隐藏ScrollView
                                            scrollpresent=false
                                        }
                                        //ScrollView回到原位置
                                        scrolloffsetx=0
                                    }
                                }
                        )
                    }
                   Divider().offset(x: scrolloffsetx<0 ? scrolloffsetx:0)
                   
                        
                    //MARK: Image part
                    VStack{
                        appmodel.Material[chapter][appmodel.imageprogress[chapter]].0[appmodel.Material[chapter][appmodel.imageprogress[chapter]].1]
                            .resizable().aspectRatio(nil, contentMode: .fit)
                            .onTapGesture {appmodel.chapterforward(chapter: chapter)}
                        Spacer()
                    }
                    .overlay(alignment: .bottomLeading){
                        informlabel
                    }
                    .frame(width:getimagewidth(geometry),height:LocalSizeApply ? StaticHeight : geometry.size.height)
    //                        .ignoresSafeArea(.all,edges: .top)
                    .offset(x: scrolloffsetx<0 ? scrolloffsetx:0)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                guard abs(value.translation.width)>60 else {return}
                                withAnimation(.spring()) {
                                    //判断拖拽距离是否达到阈值
                                    if value.translation.width>0{
                                        appmodel.chapterbackward(chapter: chapter)
                                    }else{
                                        appmodel.chapterforward(chapter: chapter)
                                    }
                                }
                            }
                    )

                        
                    
                }
                .frame(width:geometry.size.width,height:LocalSizeApply ? StaticHeight : geometry.size.height)
                .overlay(alignment: .leading){
                    
                }
                .overlay(alignment: .bottomTrailing){
                    forandbackwardbuttons
                }
                .overlay(alignment: .top){
                    Rectangle().fill(Color.secondary.opacity(0.5)).frame(height:1)
                }
                .onAppear{appmodel.chaptertapped(index:chapter)}
                
                if !scrollpresent{
                    PresentButton{
                        scrollpresent=true
                    }
                }
                
                
            }.frame(maxWidth: .infinity,maxHeight: .infinity)
                .overlay(alignment: .topLeading){
                    
                }
//                .onChange(of: geometry.size.width) { _ in
//                    print("geometry change")
//                }

        }
        .onChange(of: appmodel.imageprogress[chapter]){ value in
            UserDefaults.standard.set(value, forKey: "chapterprogress\(chapter)")
            scrolltoindex=value
        }
//        .navigationBarItems(leading:
//                                Button{
//            presentationMode.wrappedValue.dismiss()
//
//        }label:{
//            Image(systemName:"arrow.left.circle")
//                .font(.title)
//                .foregroundColor(Color.accentColor.opacity(0.9))
//        }
//
//        )
//        .navigationBarBackButtonHidden(true)
        

    }
}




//MARK: Extension on Material view
extension ARappMaterialview{
    
    
    //MARK: Extension functions
    private func getimagewidth(_ geometry:GeometryProxy)->CGFloat{
        switch (scrollpresent,scrolloffsetx<=0){
        case(false,_):return geometry.size.width
        case(true,true): return geometry.size.width*(1-scrollwidthratio)-scrolloffsetx
        case(true,false):return geometry.size.width*(1-scrollwidthratio)
        }
    }
    private func getinformlabeloffsetx(_ geometry:GeometryProxy)->CGFloat{
        switch (scrollpresent,scrolloffsetx<=0){
        case(false,_):return 5
        case(true,true): return geometry.size.width*scrollwidthratio+scrolloffsetx+5
        case(true,false):return geometry.size.width*scrollwidthratio+5
        }
    }
    //MARK: Extension views
    /// Scroll to top
    private var topbutton:some View{
        VStack {
            Button {
                scrolltoindex=0
            } label: {
                Image(systemName: "chevron.up")
                    .foregroundColor(Color.accentColor.opacity(0.9))
            }
            Spacer()
        }
    }
    /// Scroll to bottom
    private var bottombutton:some View{
        VStack {
            Spacer()
            Button {
                scrolltoindex=0
            } label: {
                Image(systemName: "chevron.down")
                    .foregroundColor(Color.accentColor.opacity(0.9))
            }
        }
    }
    /// Hide the scrollview part
    private var hidebutton:some View{
        HStack {
            Spacer()
            Button {
                scrollpresent.toggle()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.accentColor.opacity(0.9))
                    .font(.title)
            }
        }
    }
    /// Present the scrollview part
    private var presentbutton:some View{
        Image(systemName: "chevron.right.circle")
            .foregroundColor(Color.accentColor.opacity(0.9))
            .font(.title)
            .padding(5)
            .onTapGesture {
                            scrollpresent=true
            }
                        
//        Button {
//            print("present")
//            scrollpresent=true
//        } label: {
//            Image(systemName: "chevron.right.circle")
//                .foregroundColor(Color.accentColor.opacity(0.9))
//                .font(.title)
//        }.padding(5)
    }
    /// Image go forward/backward
    private var forandbackwardbuttons:some View{
        HStack {
            Button {
                appmodel.chapterbackward(chapter: chapter)
            } label: {
                Image(systemName: "arrow.backward")
                    .foregroundColor(Color.accentColor.opacity(0.9))
                    .font(.title)
            }
            .buttonStyle(.bordered)
            Button {
                appmodel.chapterforward(chapter: chapter)
            } label: {
                Image(systemName: "arrow.forward")
                    .foregroundColor(Color.accentColor.opacity(0.9))
                    .font(.title)
            }.buttonStyle(.bordered)
        }
    }
    /// Presents chapter index, image progress, image part
    private var informlabel:some View{
        VStack(alignment:.leading,spacing:.zero){
            Text("Ch\(chapter)")
            Text("page:\(appmodel.imageprogress[chapter])")
            if appmodel.Material[chapter][appmodel.imageprogress[chapter]].0.count <= 3{
                HStack{
                    ForEach(appmodel.Material[chapter][appmodel.imageprogress[chapter]].0.indices,id:\.self) { index in
                        Capsule().fill(appmodel.Material[chapter][appmodel.imageprogress[chapter]].1 == index ? Color.accentColor:Color.secondary)
                            .frame(width: 15, height: 5)
                    }
                }
            }else{
                Text("part:\(appmodel.Material[chapter][appmodel.imageprogress[chapter]].1)/\(appmodel.Material[chapter][appmodel.imageprogress[chapter]].0.count)")
            }
            
        }.padding(5)
    }
}

struct PresentButton:View{
    let action: ()->Void
    @State var LongPressing:Bool=false
    var body:some View{
        ZStack{
            Image(systemName: "chevron.right.circle")
                .foregroundColor(Color.accentColor  )
                .font(.title)
                .padding(5)
                .onLongPressGesture(minimumDuration: .infinity, perform: {}){ value in
                    if !value{
                        action()
                    }
                }
                .onTapGesture(perform: action)
        }.frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .leading)
        
    }
    
    
    
}
//struct ARMaterialView_Previews: PreviewProvider {
//    static var previews: some View {
//        ARMaterialView()
//    }
//}
