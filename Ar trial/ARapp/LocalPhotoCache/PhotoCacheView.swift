//
//  PhotoCacheView.swift
//  Ar trial
//
//  Created by niudan on 2023/6/2.
//

import SwiftUI

struct PhotoCacheView: View {
    @EnvironmentObject var Usermodel:Appusermodel
    var body: some View {
        GeometryReader{
            let size=$0.size
            List {
                ForEach(Usermodel.PhotoCachekeys) { element in
                    if let uiimage=Usermodel.manager.get(key: element.key){
                        NavigationLink(destination: PhotoCacheDetailView(size: size, uiimage: uiimage, key: element.key, mode: element.mode)) {
                            PhotoCacheRow(size: size, uiimage: uiimage, key: element.key, mode: element.mode)
                            }
                        }
                    }
            }
        }
        .navigationTitle(Usermodel.Language ? "仿真图像缓存" : "Photo Cache")
        .onAppear(perform: Usermodel.Clearcache)

    }
}

struct PhotoCacheRow: View {
    @EnvironmentObject var Usermodel:Appusermodel
    let size:CGSize
    let uiimage:UIImage
    var key:String
    let mode:scanmode
    init(size:CGSize,uiimage:UIImage,key:String,mode:scanmode){
        self.size=size
        self.uiimage=uiimage
        var transferkey:String=key.split(separator: "?").last.map{
            String($0)
        } ?? ""
        transferkey=transferkey.replacingOccurrences(of: "&", with: "\n")
        let lastnindex=transferkey.lastIndex(of: "\n")
        self.key=key
        if lastnindex != nil{
            let endindex=transferkey.endIndex
//            print(Int(endindex),transferkey.count)
            transferkey.removeSubrange(lastnindex!..<endindex)
            self.key=transferkey
        }
        self.mode=mode
    }
    var body: some View {
        HStack{
            Image(uiImage: uiimage)
                .resizable().scaledToFit()
                .padding(.leading, 5)
            Text(mode.RawValuebyLanguage(Language: Usermodel.Language)+"\n"+key)
            Spacer()
        }
            .frame(height:size.height*0.4)

    }
}

struct PhotoCacheDetailView:View{
    @EnvironmentObject var Usermodel:Appusermodel
    let size:CGSize
    let uiimage:UIImage
    var key:String
    let mode:scanmode
    init(size:CGSize,uiimage:UIImage,key:String,mode:scanmode){
        self.size=size
        self.uiimage=uiimage
        var transferkey:String=key.split(separator: "?").last.map{
            String($0)
        } ?? ""
        transferkey=transferkey.replacingOccurrences(of: "&", with: "\n")
        let lastnindex=transferkey.lastIndex(of: "\n")
        self.key=key
        if lastnindex != nil{
            let endindex=transferkey.endIndex
//            print(Int(endindex),transferkey.count)
            transferkey.removeSubrange(lastnindex!..<endindex)
            self.key=transferkey
        }
        self.mode=mode
    }
    var body: some View {
        HStack{
            Image(uiImage: uiimage)
                .resizable().scaledToFit()
                .padding(.leading, 5)
            Text(key)
            Spacer()
        }
        .navigationTitle(mode.RawValuebyLanguage(Language: Usermodel.Language))

    }
}
