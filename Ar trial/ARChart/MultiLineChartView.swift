//
//  File.swift
//  
//
//  Created by Samu András on 2020. 02. 19..
//

import SwiftUI
import RealityKit

public struct MultiLineChartView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var data:[MultiLineChartData]
    public var title: String
    public var legend: String?
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle
    public var formSize: CGSize
    public var dropShadow: Bool
    public var valueSpecifier:String
    public var informlabel:([String],[Color])
    //public var Legendrange:[Double]
    @Binding var ispresent:Bool
    @State private var touchLocation:CGPoint = .zero
    @State private var showIndicatorDot: Bool = false
    @State private var currentValue: Double = 2 {
        didSet{
            if (oldValue != self.currentValue && showIndicatorDot) {
                HapticFeedback.playSelection()
            }
            
        }
    }
    
    var globalMin:Double {
        if let min = data.flatMap({$0.onlyPoints()}).min() {
            return min
        }
        return 0
    }
    
    var globalMax:Double {
        if let max = data.flatMap({$0.onlyPoints()}).max() {
            return max
        }
        return 0
    }
    
    var frame = CGSize(width: 180, height: 120)
    private var rateValue: Int?
    
    public init(data: [([Double], GradientColor)],
                title: String,
                legend: String? = nil,
                style: ChartStyle = Styles.lineChartStyleOne,
                form: CGSize = ChartForm.medium,
                rateValue: Int? = nil,
                dropShadow: Bool = true,
                valueSpecifier: String = "%.1f",
                chartwidth:CGFloat=UIScreen.main.bounds.width/3,
                chartheight:CGFloat=UIScreen.main.bounds.height/4,
                informlabel:([String],[Color])=([],[]),
                isPresent:Binding<Bool>
    )
    {
        self.data = data.map({ MultiLineChartData(points: $0.0, gradient: $0.1)})
        self.title = title
        self.legend = legend
        self.style = style
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
        self.formSize = form
        frame = CGSize(width: chartwidth, height: chartheight)
        self.rateValue = rateValue
        self.dropShadow = dropShadow
        self.valueSpecifier = valueSpecifier
        self.informlabel=informlabel
        self._ispresent=isPresent
    }
    
    public var body: some View {
        ZStack(alignment: .center){
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color.accentColor.opacity(0.7),lineWidth: 2)
                //.fill(self.colorScheme == .dark ? self.darkModeStyle.backgroundColor : self.style.backgroundColor)
                .frame(width: frame.width, height: frame.height+10, alignment: .center)
                //.shadow(radius: self.dropShadow ? 8 : 0)
                
            VStack(alignment: .leading,spacing:.zero){
                if(!self.showIndicatorDot){
                    withAnimation(.easeIn(duration: 0.1)) {
                        VStack(alignment: .leading, spacing: .zero){
                            HStack {
                                Text(self.title)
                                    .font(.title3)
                                    //.bold()
                                .foregroundColor(.primary)
                                Spacer()
                                Button {
                                    ispresent.toggle()
                                } label: {
                                    Image(systemName: "xmark").resizable().scaledToFit()
                                        .foregroundColor(.primary)
                                        .frame(width: frame.width/8)
                                }.padding(.trailing,5)

                            }
                        }
                        .transition(.opacity)
                        //.animation()
                        .padding(.leading,5)
                    }
                    
                }else{
                    HStack{
                        Spacer()
                        Text("\(self.currentValue, specifier: self.valueSpecifier)")
                            .font(.system(size: 41, weight: .bold, design: .default))
                            .offset(x: 0, y: 30)
                        Spacer()
                    }
                    .transition(.scale)
                }
                Spacer()
                if informlabel != ([],[]) {
                    VStack(alignment:.leading,spacing:.zero){
                        ForEach(0..<informlabel.0.count,id:\.self) { index in
                            HStack(spacing:.zero){
                                Rectangle()
                                    .fill(informlabel.1[index].opacity(0.8))
                                    .frame(width: frame.width/4, height: 2)
                                    
                                
                                Text(informlabel.0[index])
                                    .font(.caption)
                                    .foregroundColor(.primary.opacity(0.9))
                            }
                        }
                    }.padding(.leading, 5)
                }
                
                GeometryReader{ geometry in
                    ZStack{
                        ForEach(0..<self.data.count) { i in
                            Line(data: self.data[i],
                                 frame: .constant(geometry.frame(in: .local)),
                                 touchLocation: self.$touchLocation,
                                 showIndicator: self.$showIndicatorDot,
                                 minDataValue: .constant(self.globalMin),
                                 maxDataValue: .constant(self.globalMax),
                                 showBackground: false,
                                 gradient: self.data[i].getGradient(),
                                 index: i)
                        }
                    }
                    //.padding(.bottom, 5)
                }
                
                .frame(width: frame.width, height: frame.height*0.6)
                //.clipShape(RoundedRectangle(cornerRadius: 20))
                .offset(x: 0, y: 0)
            }.frame(width: frame.width, height: frame.height)
        }
        .gesture(DragGesture()
        .onChanged({ value in
//            self.touchLocation = value.location
//            self.showIndicatorDot = true
//            self.getClosestDataPoint(toPoint: value.location, width:self.frame.width, height: self.frame.height)
        })
            .onEnded({ value in
                self.showIndicatorDot = false
            })
        )
    }
    
//    @discardableResult func getClosestDataPoint(toPoint: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
//        let points = self.data.onlyPoints()
//        let stepWidth: CGFloat = width / CGFloat(points.count-1)
//        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
//
//        let index:Int = Int(round((toPoint.x)/stepWidth))
//        if (index >= 0 && index < points.count){
//            self.currentValue = points[index]
//            return CGPoint(x: CGFloat(index)*stepWidth, y: CGFloat(points[index])*stepHeight)
//        }
//        return .zero
//    }
    
   
}


public struct MultiLineChartRCView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var data:[MultiLineChartData]
    public var title: String
    public var legend: String?
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle
    public var formSize: CGSize
    public var dropShadow: Bool
    public var valueSpecifier:String
    public var informlabel:([String],[Color])
    //public var Legendrange:[Double]
    @Binding var ispresent:Bool
    @State var resistant:Double=1
    @Binding var zooming:Bool
    @State private var touchLocation:CGPoint = .zero
    @State private var showIndicatorDot: Bool = false
    @State private var currentValue: Double = 2 {
        didSet{
            if (oldValue != self.currentValue && showIndicatorDot) {
                HapticFeedback.playSelection()
            }
            
        }
    }
    
    var globalMin:Double {
        if let min = data.flatMap({$0.onlyPoints()}).min() {
            return min
        }
        return 0
    }
    
    var globalMax:Double {
        if let max = data.flatMap({$0.onlyPoints()}).max() {
            return max
        }
        return 0
    }
    
    var frame = CGSize(width: 180, height: 120)
    private var rateValue: Int?
    
    public init(data: [([Double], GradientColor)],
                title: String,
                legend: String? = nil,
                style: ChartStyle = Styles.lineChartStyleOne,
                form: CGSize = ChartForm.medium,
                rateValue: Int? = nil,
                dropShadow: Bool = true,
                valueSpecifier: String = "%.1f",
                chartwidth:CGFloat=UIScreen.main.bounds.width/3,
                chartheight:CGFloat=UIScreen.main.bounds.height/4,
                informlabel:([String],[Color])=([],[]),
                isPresent:Binding<Bool>,
                zooming:Binding<Bool>
                //resistant:Binding<Double>
    )
    {
        self.data = data.map({ MultiLineChartData(points: $0.0, gradient: $0.1)})
        self.title = title
        self.legend = legend
        self.style = style
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
        self.formSize = form
        frame = CGSize(width: chartwidth, height: chartheight)
        self.rateValue = rateValue
        self.dropShadow = dropShadow
        self.valueSpecifier = valueSpecifier
        self.informlabel=informlabel
        self._ispresent=isPresent
        self._zooming=zooming
    }
    
    public var body: some View {
        ZStack(alignment: .center){
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.white.opacity(0.7))
                .frame(width: frame.width, height:frame.height*1.1, alignment: .center)
                .offset(y: frame.height*0)
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.accentColor.opacity(0.7),lineWidth: 2)
                .frame(width: frame.width, height:frame.height*1.1, alignment: .center)
                .offset(y: frame.height*0)
            
            VStack(alignment: .leading,spacing:.zero){
                if(!self.showIndicatorDot){
                    HStack {
                        Text(self.title)
                            .font(.title3).frame(alignment:.top)
                            //.bold()
                        .foregroundColor(.primary)
                        Spacer()
                        Button{
                            zooming.toggle()
                        }label:{
                            Image(systemName:zooming ? "arrow.down.right.and.arrow.up.left":"arrow.up.left.and.arrow.down.right")
                                .font(.title3)
                        }
                        .padding(.trailing,5)
                        Button{
                            ispresent=false
                        }label: {
                            Image(systemName: "chevron.down")
                                .font(.title3)
                        }
                        .padding(.trailing,5)

                    }
                    .transition(.opacity)
                    //.animation()
                    .padding(.leading,5)
                    
                }else{
                    HStack{
                        Spacer()
                        Text("\(self.currentValue, specifier: self.valueSpecifier)")
                            .font(.system(size: 41, weight: .bold, design: .default))
                            .offset(x: 0, y: 30)
                        Spacer()
                    }
                    .transition(.scale)
                }
                Spacer()
                if informlabel != ([],[]) {
//                    VStack(alignment:.leading,spacing:.zero){
//                        ForEach(0..<informlabel.0.count) { index in
//                            HStack(spacing:.zero){
//                                Rectangle()
//                                    .fill(informlabel.1[index].opacity(0.8))
//                                    .frame(width: frame.width/4, height: 2)
//
//
//                                Text(informlabel.0[index])
//                                    .font(.caption)
//                                    .foregroundColor(.primary.opacity(0.9))
//                            }
//                        }
//                    }.padding(.leading, 5)
                    HStack(spacing:.zero){
                        ForEach(0..<informlabel.0.count,id:\.self) { index in
                            HStack(spacing:.zero){
                                Rectangle()
                                    .fill(informlabel.1[index].opacity(0.8))
                                    .frame(width: frame.width/CGFloat(informlabel.0.count)/2, height: 2)
                                    
                                
                                Text(informlabel.0[index])
                                    .font(.caption)
                                    .foregroundColor(.primary.opacity(0.9))
                            }
                        }
                    }.padding(.leading, 5)
                }
                //Slider(value: $resistant, in: 1...100)
                
                GeometryReader{ geometry in
                    ZStack{
                        ForEach(0..<self.data.count) { i in
                            Line(data: self.data[i],
                                 frame: .constant(geometry.frame(in: .local)),
                                 touchLocation: self.$touchLocation,
                                 showIndicator: self.$showIndicatorDot,
                                 minDataValue: .constant(self.globalMin),
                                 maxDataValue: .constant(self.globalMax),
                                 showBackground: false,
                                 gradient: self.data[i].getGradient(),
                                 index: i)
                        }
                    }
                    //.padding(.bottom, 5)
                }
                
                .frame(width: frame.width, height: frame.height*0.6)
                //.clipShape(RoundedRectangle(cornerRadius: 20))
                .offset(x: 0, y: 0)
            }.frame(width: frame.width, height: frame.height)
        }
        .gesture(DragGesture()
        .onChanged({ value in
//            self.touchLocation = value.location
//            self.showIndicatorDot = true
//            self.getClosestDataPoint(toPoint: value.location, width:self.frame.width, height: self.frame.height)
        })
            .onEnded({ value in
                self.showIndicatorDot = false
            })
        )
    }
    

    
   
}



struct MultiWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            MultiLineChartRCView(data: [([8,23,54,32,12,37,7,23,43], GradientColors.orange)], title: "Line chart", legend: "Basic",informlabel: (["pulse","sine"],[Color(hexString: "FEFB00"),Color(hexString: "FEFB00")]),isPresent: .constant(true),zooming: .constant(false))
            //MultiLineChartRCView(data: [([8,23,54,35,12,37,7,23,43], GradientColors.orange)], title: "Line chart", legend: "Basic",isPresent: .constant(true),resistant:.constant(1))
        }
    }
}
