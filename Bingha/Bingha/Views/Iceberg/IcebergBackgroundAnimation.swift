//
//  IcebergBackgroundAnimation.swift
//  Bingha
//
//  Created by HanGyeongjun on 2022/07/26.
//

import SwiftUI

struct IcebergBackgroundAnimation: View {
    
    let universalSize = UIScreen.main.bounds
    
    @State private var isAnimated = false
    @State var lv: String
    
    init(lv: String){
            self.lv = lv
    }
    
    var body: some View {
        
        ZStack {
            getWave(interval: universalSize.width, amplitude: 80, baseline: -50 + universalSize.height/2)
                .foregroundColor(Color.init(red: 0.0, green: 0.6, blue: 1).opacity(0.1))
                .offset(x: isAnimated ? -1*universalSize.width : 0)
                .animation(
                    Animation.linear(duration: 19.9)
                        .repeatForever(autoreverses: false),
                    value: isAnimated
                )
            getWave(interval: universalSize.width*1.5, amplitude: 70, baseline: -50 + universalSize.height/2)
                .foregroundColor(Color.init(red: 0.1, green: 0.6, blue: 1).opacity(0.1))
                .offset(x: isAnimated ? -1*(universalSize.width*1.5) : 0)
                .animation(
                    Animation.linear(duration: 11.7)
                        .repeatForever(autoreverses: false),
                    value: isAnimated
                )
            getWave(interval: universalSize.width*1.8, amplitude: 50, baseline: -50 + universalSize.height/2)
                .foregroundColor(Color.init(red: 0.4, green: 0.6, blue: 1).opacity(0.1))
                .offset(x: isAnimated ? -1*(universalSize.width*1.8) : 0)
                .animation(
                    Animation.linear(duration: 15.4)
                        .repeatForever(autoreverses: false),
                    value: isAnimated
                )
            binghaImage(lv: lv)
                
        }
        .onAppear(){
            self.isAnimated = true
        }
    }
    
    func getWave(interval:CGFloat, amplitude: CGFloat = 100 ,baseline:CGFloat = UIScreen.main.bounds.height/2) -> Path {
        Path{path in
            path.move(to: CGPoint(x: 0, y: baseline
                                 ))
            path.addCurve(
                to: CGPoint(x: 1*interval,y: baseline),
                control1: CGPoint(x: interval * (0.35),y: amplitude + baseline),
                control2: CGPoint(x: interval * (0.65),y: -amplitude + baseline)
            )
            path.addCurve(
                to: CGPoint(x: 2*interval,y: baseline),
                control1: CGPoint(x: interval * (1.35),y: amplitude + baseline),
                control2: CGPoint(x: interval * (1.65),y: -amplitude + baseline)
            )
            path.addLine(to: CGPoint(x: 2*interval, y: universalSize.height))
            path.addLine(to: CGPoint(x: 0, y: universalSize.height))
        }
    }
    
    @ViewBuilder
    func binghaImage(lv: String) -> some View {
        switch lv{
        case "1":
            Image("Bingha")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70)
                .offset(x: 0, y: -30)
        case "2":
            Image("Bingha")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 90)
                .offset(x: 0, y: -30)
        case "3":
            Image("Bingha")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 110)
                .offset(x: 0, y: -30)
        case "4":
            Image("Bingha")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 130)
                .offset(x: 0, y: -30)
        default:
            Image("Bingha")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
                .offset(x: 0, y: -30)
        }
    }
}

struct IcebergBackgroundAnimation_Previews: PreviewProvider {
    static var previews: some View {
        IcebergBackgroundAnimation(lv: "3")
    }
}
