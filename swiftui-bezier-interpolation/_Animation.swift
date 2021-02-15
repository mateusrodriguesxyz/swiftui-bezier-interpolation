//
//  _Animation.swift
//  swiftui-bezier-interpolation
//
//  Created by Mateus Rodrigues on 12/02/21.
//

import Foundation
import SwiftUI

struct _Animation {

    let curve: BezierCurve
    let duration: Double
    
    func interpolate(from initialValue: CGFloat, to finalValue: CGFloat, update: @escaping (CGFloat, CGFloat) -> Void) {
        let iterator = curve.interpolate(from: initialValue, to: finalValue, dx: CGFloat(1.0/(duration*60)))
        Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { (timer) in
            if let (x, value) = iterator.next() {
                update(CGFloat(x), value)
            } else {
                timer.invalidate()
            }
        }
    }
    
}

extension _Animation {

    public static func easeInOut(duration: Double) -> _Animation {
        _Animation(curve: .easeInOut, duration: duration)
    }

    public static var easeInOut = _Animation(curve: .easeInOut, duration: 0.35)

    public static func easeIn(duration: Double) -> _Animation {
        _Animation(curve: .easeIn, duration: duration)
    }

    public static var easeIn = _Animation(curve: .easeIn, duration: 0.35)

    public static func easeOut(duration: Double) -> _Animation {
        _Animation(curve: .easeOut, duration: duration)
    }

    public static var easeOut = _Animation(curve: .easeOut, duration: 0.35)

    public static func linear(duration: Double) -> _Animation {
        _Animation(curve: .linear, duration: duration)
    }

    public static var linear = _Animation(curve: .linear, duration: 0.35)

    public static func timingCurve(_ c0x: Double, _ c0y: Double, _ c1x: Double, _ c1y: Double, duration: Double = 0.35) -> _Animation {
        _Animation(curve: .init(p0: .zero, p1: .init(x: c0x, y: c0y), p2: .init(x: c1x, y: c1y), p3: .init(x: 1, y: 1)), duration: duration)
    }
    
}

