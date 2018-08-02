//
//  Type.swift
//  Box
//
//  Created by hao yin on 2018/7/6.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import QuartzCore

public protocol Rect{
    var width:CGFloat? {get set}
    var height:CGFloat? {get set}
    func layout()
    func storeRect(result:CGRect)
    var needFitSize:Bool {get}
    func fixSize()
}
public protocol UIExtension:class{
    associatedtype T:UIView
    var host:T? {get set}
}

public struct Margin{
    public var left:CGFloat
    public var right:CGFloat
    public var top:CGFloat
    public var bottom:CGFloat
    public init(left:CGFloat,right:CGFloat,top:CGFloat,bottom:CGFloat){
        self.left = left
        self.right = right
        self.top = top
        self.bottom = bottom
    }
    public static var none:Margin{
        return Margin(left: 0, right: 0, top: 0, bottom: 0)
    }
}



public struct Relative{
    public var left:CGFloat?
    public var top:CGFloat?
    
    public var right:CGFloat?
    public var bottom:CGFloat?
    
    static public var none:Relative{
        return Relative(left: nil, top: nil, right: nil, bottom: nil)
    }
    static public func leftTop(left: CGFloat?, top: CGFloat?)->Relative{
        return Relative(left: left, top: top, right: nil, bottom: nil)
    }
    static public func bottonRight(bottom: CGFloat?, right: CGFloat?)->Relative{
        return Relative(left: nil, top: nil, right: right, bottom: bottom)
    }
}

public protocol LayoutBox:class{
    var resultX:CGFloat {get set}
    var resultY:CGFloat {get set}
    var resultW:CGFloat {get set}
    var resultH:CGFloat {get set}
    var resultRect:CGRect {get}
    var relativePostion:Relative {get}
}

public protocol Container{
    var subBoxs:[Box] {get}
    func addSubBox(box:Box)
}

extension LayoutBox{
    public var resultRect:CGRect{
        var xValue:CGFloat?
        var yValue:CGFloat?
        if let l = self.relativePostion.left{
            xValue = l
        }
    
        if let t = self.relativePostion.top{
            yValue = t
        }
        
        if let r = self.relativePostion.right,xValue == nil{
            xValue = -r
        }
        if let b = self.relativePostion.bottom ,yValue == nil{
            yValue = -b
        }
        return CGRect(x: resultX + (xValue ?? 0), y: resultY + (yValue ?? 0), width: resultW, height: resultH)
    }
}

public struct DrawError:Error {
    public var code:Int
    public var desc:String
    public var line:Int
    public var filename:String
    public typealias ErrorClosure = (Int,String)->DrawError
    public static var createContextFail:ErrorClosure{
        return makeErrorClosure(code: 1, desc: "创建Context失败")
    }
    public static var createLayerFail:ErrorClosure{
        return makeErrorClosure(code: 2, desc: "创建Layer失败")
    }
    public static var createCGFunctionFail:ErrorClosure{
        return makeErrorClosure(code: 3, desc: "创建CGFunction失败")
    }
    public static var createCGShadingFail:ErrorClosure{
        return makeErrorClosure(code: 4, desc: "创建CGShading失败")
    }
    public static var createCGGradientFail:ErrorClosure{
        return makeErrorClosure(code: 5, desc: "创建CGGradient失败")
    }
    public static var createCGPatternFail:ErrorClosure{
        return makeErrorClosure(code: 5, desc: "创建CGPattern失败")
    }
    public static var addBezeirPointToMuchFail:ErrorClosure{
        return makeErrorClosure(code: 6, desc: "贝塞尔曲线控制点过多")
    }
    public static func makeErrorClosure(code:Int,desc:String)->ErrorClosure{
        return {(line,file) in
            return DrawError(code: code, desc: desc, line: line, filename: file)
        }
    }
    
    public var localizedDescription: String{
        return "\(Date()):[Error] code\(self.code) \(self.desc) in \(self.filename)line:\(self.line)"
    }
}
extension CGColor{
    public static var red:CGColor{
        return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1,0,0,1])!
    }
    public static var blue:CGColor{
        return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0,0,1,1])!
    }
    public static var green:CGColor{
        return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0,1,0,1])!
    }
    public static var black:CGColor{
        return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0,0,0,1])!
    }
    public static var white:CGColor{
        return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1,1,1,1])!
    }
    public static var clear:CGColor{
        return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0,0,0,0])!
    }
    public static func rgb(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat = 1)->CGColor {
        return self.init(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [r,g,b,a])!
    }
    public static var rand:CGColor{
        return CGColor.rgb(r: CGFloat(arc4random()) / CGFloat(RAND_MAX), g: CGFloat(arc4random()) / CGFloat(RAND_MAX), b: CGFloat(arc4random()) / CGFloat(RAND_MAX))
    }
    static public func initWithString(storeText: String)->CGColor {
        let start = storeText.index(after: storeText.startIndex)
        let end = storeText.endIndex
        let s = Array(storeText.lowercased()[start..<end])
        var rea = Array<String>()
        for i in (0..<s.count){
            if i % 2 == 1{
                rea.append("\(s[i - 1])\(s[i])")
            }
        }
        let arry = rea.map {strtoul(String($0), nil, 16)}.map{CGFloat($0) / 255.0}
        
        if let color = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: arry){
            return color
        }else{
            return CGColor.black
        }
    }
    public var colorText: String {
        get{
            let r = Int((self.components?[0] ?? 0) * 255)
            let g = Int((self.components?[1] ?? 0) * 255)
            let b = Int((self.components?[2] ?? 0) * 255)
            let a = Int(self.alpha * 255)
            return String(format: "#%x%x%x%x", r,g,b,a)
        }
    }
}
extension CGSize{
    static public func * (size:CGSize,v:CGFloat)->CGSize{
        return CGSize(width: size.width * v, height: size.height * v)
    }
    static public func + (size:CGSize,v:CGFloat)->CGSize{
        return CGSize(width: size.width + v, height: size.height + v)
    }
    static public func - (size:CGSize,v:CGFloat)->CGSize{
        return size + (-v)
    }
    static public func / (size:CGSize,v:CGFloat)->CGSize{
        return size * (1 / v)
    }
}

public typealias FlexSubBox = FlexItem & LayoutBox & Rect

public typealias Box = FlexSubBox
