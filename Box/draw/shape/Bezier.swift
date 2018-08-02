//
//  Bezier.swift
//  rxs
//
//  Created by Francis on 2018/6/13.
//  Copyright © 2018年 Francis. All rights reserved.
//

import Foundation
import QuartzCore

extension CGPath{
    static public func bezeir(points:[CGPoint],precision:UInt,close:Bool = false)->CGPath{
        let path = CGMutablePath.init()
        let create  = bezeirFunction(points: points)
        let allPoint = UInt(points.count) * precision
        for i in 0 ... allPoint{
            if i == 0{
                let point = create(0)
                path.move(to: point)
            }else{
                let point = create(CGFloat(i) / CGFloat(allPoint))
                path.addLine(to: point)
            }
        }
        if close{
            path.closeSubpath()
        }
        return path
    }
    static func bezeirFunction(points:[CGPoint])->(CGFloat)->CGPoint{
        if points.count < 1{
            return { _ in
                return .zero
            }
        }else{
            let n = points.count - 1
            
            let param = binomialParam(count: UInt64(n))
            
            return { (t) in
                var p:CGPoint = .zero
                for i in (0..<param.count){
                    p = p + points[i] * CGFloat(combination(all: UInt64(n), select: UInt64(i))) * pow(1 - t, CGFloat(n - i)) * pow(t, CGFloat(i))
                }
                return p
            }
        }
    }
}
extension CGMutablePath{
    public func addBezier(points:[CGPoint],precision:UInt,line:Int = #line,file:String = #file) throws{
        if (points.count > 20){
            throw DrawError.addBezeirPointToMuchFail(line,file)
        }else{
            let create  = CGPath.bezeirFunction(points: points)
            let allPoint = UInt(points.count) * precision
            for i in 0 ... allPoint{
                let point = create(CGFloat(i) / CGFloat(allPoint))
                self.addLine(to: point)
            }
        }
    }
}

public func factorial(v:UInt64)->UInt64{
    if v == 0{
        return 1
    }else{
        return v * factorial(v: v - 1)
    }
}
public func permutation(all:UInt64,select:UInt64)->UInt64{
    if select == 0{
        return 1
    }
    if all == (all - select + 1){
        return all - select + 1
    }else{
        return all * permutation(all: all - 1, select: select - 1)
    }
}
public func combination(all:UInt64,select:UInt64)->UInt64{
    return permutation(all: all, select: select) / factorial(v: select)
}
public func binomialParam(count:UInt64)->[UInt64]{
    return (0...count).map{combination(all: UInt64(count), select: UInt64($0))}
}
func * (lv:CGPoint,r:CGFloat)->CGPoint{
    return CGPoint(x: lv.x * r, y: lv.y * r)
}
func + (lv:CGPoint,rv:CGPoint)->CGPoint{
    return CGPoint(x: lv.x + rv.x, y: lv.y + rv.y)
}
