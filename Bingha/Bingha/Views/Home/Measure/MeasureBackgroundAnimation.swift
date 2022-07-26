//
//  MeasureBackgroundAnimation.swift
//  Bingha
//
//  Created by HanGyeongjun on 2022/07/26.
//

import SwiftUI

struct MeasureBackgroundAnimation: View {
    
    let universalSize = UIScreen.main.bounds
    
    @State private var isAnimated = false
    var body: some View {
        
        ZStack {
            getWave(interval: universalSize.width, amplitude: 125, baseline: -60 + universalSize.height/2)
                .foregroundColor(Color.init(red: 0.0, green: 0.6, blue: 1).opacity(0.1))
                .offset(x: isAnimated ? -1*universalSize.width : 0)
                .animation(
                    Animation.linear(duration: 15.9)
                    .repeatForever(autoreverses: false),
                    value: isAnimated
                )
            getWave(interval: universalSize.width*1.2, amplitude: 70, baseline: -35 + universalSize.height/2)
                .foregroundColor(Color.init(red: 0.1, green: 0.6, blue: 1).opacity(0.1))
                .offset(x: isAnimated ? -1*(universalSize.width*1.2) : 0)
                .animation(
                    Animation.linear(duration: 8.7)
                    .repeatForever(autoreverses: false),
                    value: isAnimated
                )
            getWave(interval: universalSize.width*1.5, amplitude: 50, baseline: -20 + universalSize.height/2)
                .foregroundColor(Color.init(red: 0.4, green: 0.6, blue: 1).opacity(0.1))
                .offset(x: isAnimated ? -1*(universalSize.width*1.5) : 0)
                .animation(
                    Animation.linear(duration: 10.4)
                    .repeatForever(autoreverses: false),
                    value: isAnimated
                )
            //흰색 레이어
            getWave(interval: universalSize.width*1, amplitude: 100, baseline: 45 + universalSize.height/2)
                .foregroundColor(Color.init(red: 1, green: 1, blue: 1).opacity(0.5))
                .offset(x: isAnimated ? -1*(universalSize.width*1) : 0)
                .animation(
                    Animation.linear(duration: 6.5)
                    .repeatForever(autoreverses: false),
                    value: isAnimated
                )
            //흰색 레이어
            getWave(interval: universalSize.width*1.7, amplitude: 86, baseline: 70 + universalSize.height/2)
                .foregroundColor(Color.init(red: 1, green: 1, blue: 1).opacity(0.5))
                .offset(x: isAnimated ? -1*(universalSize.width*1.7) : 0)
                .animation(
                    Animation.linear(duration: 11.8)
                    .repeatForever(autoreverses: false),
                    value: isAnimated
                )
            getWave(interval: universalSize.width*1.2, amplitude: 70, baseline: -200 + universalSize.height/2)
                .foregroundColor(Color.init(red: 0.1, green: 0.6, blue: 1).opacity(0.1))
                .offset(x: isAnimated ? -1*(universalSize.width*1.2) : 0)
                .animation(
                    Animation.linear(duration: 8.7)
                    .repeatForever(autoreverses: false),
                    value: isAnimated
                )
            getWave(interval: universalSize.width*1.6, amplitude: 150, baseline: -240 + universalSize.height/2)
                .foregroundColor(Color.init(red: 0.1, green: 0.6, blue: 1).opacity(0.1))
                .offset(x: isAnimated ? -1*(universalSize.width*1.6) : 0)
                .animation(
                    Animation.linear(duration: 15.7)
                    .repeatForever(autoreverses: false),
                    value: isAnimated
                )
            //흰색 레이어
            getWave(interval: universalSize.width*1.2, amplitude: 200, baseline: 150 + universalSize.height/2)
                .foregroundColor(Color.init(red: 1, green: 1, blue: 1).opacity(0.3))
                .offset(x: isAnimated ? -1*(universalSize.width*1.2) : 0)
                .animation(
                    Animation.linear(duration: 8.7)
                    .repeatForever(autoreverses: false),
                    value: isAnimated
                )
            getWave(interval: universalSize.width*1.5, amplitude: 120, baseline: 200 + universalSize.height/2)
                .foregroundColor(Color.init(red: 0.1, green: 0.6, blue: 1).opacity(0.1))
                .offset(x: isAnimated ? -1*(universalSize.width*1.5) : 0)
                .animation(
                    Animation.linear(duration: 18.4)
                    .repeatForever(autoreverses: false),
                    value: isAnimated
                )
        }
        .onAppear(){
            self.isAnimated = true
        }
        .blur(radius: 12)
    }
    
    func getWave(interval:CGFloat, amplitude: CGFloat = 100 ,baseline:CGFloat = UIScreen.main.bounds.height/2) -> Path {
        Path{path in
            path.move(to: CGPoint(x: 0, y: baseline))
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
}
struct MeasureBackgroundAnimation_Previews: PreviewProvider {
    static var previews: some View {
        MeasureBackgroundAnimation()
    }
}
