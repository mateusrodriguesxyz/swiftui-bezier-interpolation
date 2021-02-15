//
//  CurveView.swift
//  swiftui-bezier-interpolation
//
//  Created by Mateus Rodrigues on 12/02/21.
//

import SwiftUI

extension CGPoint {
    init(_ animatableData: AnimatableData) {
        self.init(x: animatableData.first, y: animatableData.second)
    }
}

struct CurveView: Shape {
    
    public typealias AnimatableData = AnimatablePair<AnimatablePair<CGPoint.AnimatableData, CGPoint.AnimatableData>, AnimatablePair<CGPoint.AnimatableData, CGPoint.AnimatableData>>
    
    var p0: CGPoint
    var p1: CGPoint
    var p2: CGPoint
    var p3: CGPoint
    
    var animatableData: AnimatableData {
        get {
            AnimatablePair(AnimatablePair(p0.animatableData, p1.animatableData), AnimatablePair(p2.animatableData, p3.animatableData))
        }
        set {
            p0 = CGPoint(newValue.first.first)
            p1 = CGPoint(newValue.first.second)
            p2 = CGPoint(newValue.second.first)
            p3 = CGPoint(newValue.second.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { p in
            let curve = BezierCurve(p0: p0, p1: p1, p2: p2, p3: p3)
            p.move(to: curve.p0)
            for t in stride(from: 0, through: 1, by: 0.01) {
                p.addLine(to: curve.point(t: CGFloat(t)))
            }
        }
        .applying(.init(scaleX: rect.width, y: rect.height))
    }
    
}

extension CurveView {
    init(curve: BezierCurve) {
        self.init(p0: curve.p0, p1: curve.p1, p2: curve.p2, p3: curve.p3)
    }
}

struct CurveView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CurveView(curve: .linear).stroke()
            CurveView(curve: .easeIn).stroke()
            CurveView(curve: .easeOut).stroke()
            CurveView(curve: .easeInOut).stroke()
        }
        .frame(width: 100, height: 100)
    }
}
