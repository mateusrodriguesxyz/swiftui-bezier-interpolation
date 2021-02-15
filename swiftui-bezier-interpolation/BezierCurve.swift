//
//  BezierCurve.swift
//  swiftui-bezier-interpolation
//
//  Created by Mateus Rodrigues on 11/02/21.
//

import SwiftUI

struct BezierCurve {

    let p0: CGPoint
    let p1: CGPoint
    let p2: CGPoint
    let p3: CGPoint
    
    var a: CGPoint = .zero
        
    var b: CGPoint = .zero
    
    var c: CGPoint = .zero
    
    internal init(p0: CGPoint, p1: CGPoint, p2: CGPoint, p3: CGPoint) {
        self.p0 = p0
        self.p1 = p1
        self.p2 = p2
        self.p3 = p3
        let (ax, bx, cx) = coefficients(p0: p0.x, p1: p1.x, p2: p2.x, p3: p3.x)
        let (ay, by, cy) = coefficients(p0: p0.y, p1: p1.y, p2: p2.y, p3: p3.y)
        self.a = CGPoint(x: ax, y: ay)
        self.b = CGPoint(x: bx, y: by)
        self.c = CGPoint(x: cx, y: cy)
        
    }
        
    func coefficients(p0: CGFloat, p1: CGFloat, p2: CGFloat, p3: CGFloat) -> (a: CGFloat, b: CGFloat, c: CGFloat) {
        let a = (p3 - 3*p2 + 3*p1 - p0)
        let b = 3 * (p2 - 2*p1 + p0)
        let c = 3 * (p1 - p0)
        return (a, b, c)
    }
    
    func point(t: CGFloat) -> CGPoint {
        let x = value(a: a.x, b: b.x, c: c.x, t: t)
        let y = value(a: a.y, b: b.y, c: c.y, t: t)
        return CGPoint(x: x, y: y)
    }
    
    func value(a: CGFloat, b: CGFloat, c: CGFloat, t: CGFloat) -> CGFloat {
        let t3 = pow(t, 3) * a
        let t2 = pow(t, 2) * b
        let t1 = t * c
        return t3 + t2 + t1
    }
    
    func t(x: CGFloat) -> CGFloat {
        let roots = solve(a: a.x, b: b.x, c: c.x, d: -x)
        let t = roots.first(where: { $0.isReal && (0...1).contains($0.real) })?.real ?? 0
        return CGFloat(t)
    }
    
}

extension BezierCurve {
    
    func interpolate(from initialValue: CGFloat, to finalValue: CGFloat, dx: CGFloat) -> AnyIterator<(CGFloat, CGFloat)> {
        AnyIterator(iterator: stride(from: dx, through: 1, by: dx).makeIterator()) { x in
            let t = self.t(x: x)
            let y = self.point(t: t).y
            let value = initialValue + y*(finalValue-initialValue)
            return (x, value)
        }
    }
    
}

extension AnyIterator {
    
    init<T: IteratorProtocol>(iterator: T, transform: @escaping (T.Element) -> Element) {
        var _iterator = iterator
        self.init {
            if let element = _iterator.next() {
                return transform(element)
            } else {
                return nil
            }
        }
    }
    
}

extension BezierCurve {
    static var linear: Self = .init(p0: .zero, p1: .zero, p2: CGPoint(x: 1, y: 1), p3: CGPoint(x: 1, y: 1))
    static var easeIn: Self = .init(p0: .zero, p1: CGPoint(x: 0.42, y: 0), p2: CGPoint(x: 1, y: 1), p3: CGPoint(x: 1, y: 1))
    static var easeOut: Self = .init(p0: .zero, p1: .zero, p2: CGPoint(x: 0.58, y: 1), p3: CGPoint(x: 1, y: 1))
    static var easeInOut: Self = .init(p0: .zero, p1: CGPoint(x: 0.42, y: 0), p2: CGPoint(x: 0.58, y: 1), p3: CGPoint(x: 1, y: 1))
}
