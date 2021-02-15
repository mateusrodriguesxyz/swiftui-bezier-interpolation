//
//  AnimationView.swift
//  swiftui-bezier-interpolation
//
//  Created by Mateus Rodrigues on 14/02/21.
//

import SwiftUI

struct AnimationView: View {
    
    @Binding var x: CGFloat
    
    @State var t: CGFloat = 0
    @State var y: CGFloat = 0
    
    let animation: _Animation
    
    var body: some View {
        VStack {
            
            ZStack {
                CurveView(curve: animation.curve)
                    .stroke(Color.blue)
                    .scaleEffect(x: 1, y: -1)
                    .frame(minWidth: 300, minHeight: 300)
                    .clipped()
                LineView(p0: CGPoint(x: x, y: 1), p1: CGPoint(x: x, y: 1-y))
                    .stroke(lineWidth: 1.0)
                LineView(p0: CGPoint(x: 0, y: 1-y), p1: CGPoint(x: x, y: 1-y))
                    .stroke(lineWidth: 1.0)
                LineView(p0: CGPoint(x: t, y: 1), p1: CGPoint(x: t, y: 0))
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
            }
            .aspectRatio(1, contentMode: .fit)
            .background(Color.primary.colorInvert())
            .border(Color.primary)
            .padding()
            
            HStack {
                Text("t = \(t)")
                Divider()
                Text("x = \(x)")
                Divider()
                Text("y = \(y)")
            }
            .font(.system(.body, design: .monospaced))
            .frame(height: 20)
            
            Slider(value: $x, in: 0...1)
            
        }
        .padding()
        .onChange(of: x) {
            t = animation.curve.t(x: $0)
            y = animation.curve.point(t: t).y
        }
        .onAppear {
            t = animation.curve.t(x: x)
            y = animation.curve.point(t: t).y
        }
        
    }
}

struct AnimationView_Previews: PreviewProvider {
    
    static var previews: some View {
        AnimationView(x: .constant(0.25), animation: .easeOut)
    }
    
}
