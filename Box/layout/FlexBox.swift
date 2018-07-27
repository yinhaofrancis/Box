//
//  FlexBox.swift
//  Box
//
//  Created by hao yin on 2018/7/4.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import QuartzCore

public enum Align{
    case start
    case end
    case center
    case stretch
}
public enum Justify{
    case start
    case end
    case center
    case evenly
    case between
    case around
    case stretch
}
public enum FlexDirection{
    case row
    case column
}
public protocol FlexItem{
    var grow:Int {get}
    var shrink:Int {get}
    var alignSelf:Align? {get}
}
public protocol FlexLineItem{
    var justifyContent:Justify {get}
    var alignItem:Align {get}
    var direction :FlexDirection {get}
}
public protocol FlexBoxItem{
    var wrap:Bool {get}
    var alignContent:Justify {get}
}

public class FlexBox<T:UIView>: Box,FlexLineItem,FlexBoxItem,Container {
    public var relativePostion: Relative = .none
    
    public func storeRect(result: CGRect) {
        self.host?.applyResult(rect: result)
    }
    public var subBoxs: [Box] = []
    
    public func addSubBox(box: Box) {
        self.subBoxs.append(box)
    }
    public var host: T?
    
    public var direction: FlexDirection = .row
    
    public var width: CGFloat?{
        didSet{
            resultW = self.width ?? 0
        }
    }
    
    public var height: CGFloat?{
        didSet{
            resultH = self.height ?? 0
        }
    }
    
    public var resultX: CGFloat
    
    public var resultY: CGFloat
    
    public var resultW: CGFloat
    
    public var resultH: CGFloat
    
    public var grow: Int = 0
    
    public var shrink: Int = 0
    
    public var alignSelf: Align?
    
    public var justifyContent: Justify = .start
    
    public var alignItem: Align = .start
    
    public var wrap: Bool = false
    
    public var alignContent: Justify = .start
    
    private var lines:[FlexLine] = []
    
    var selfLine:FlexLine?
    
    public var needFitSize:Bool = false;
    
    public init(width:CGFloat?,height:CGFloat?){
        self.width = width;
        self.height = height;
        self.resultX = 0;
        self.resultY = 0;
        self.resultW = width ?? 0;
        self.resultH = height ?? 0;
    }
    public func layout(){
        self.subBoxs.forEach { (i) in
            i.fixSize()
        }
        if(wrap){
            switch(self.direction){
            case .row:
                lines = seperatedLines(subBox: self.subBoxs, sumKeyPath: \LayoutBox.resultW)
                selfLine = FlexLine(width: self.resultW, height: self.resultH, justifyContent: alignContent, alignItem: .stretch, subBoxs: lines, direction: .column)
                break;
            case .column:
                lines = seperatedLines(subBox: self.subBoxs, sumKeyPath: \LayoutBox.resultH)
                selfLine = FlexLine(width: self.resultW, height: self.resultH, justifyContent: alignContent, alignItem: .stretch, subBoxs: lines, direction: .row)
                break;
            }
            if(self.alignContent == .stretch){
                self.lines.forEach { (i) in
                    i.grow = 1
                }
            }else{
                self.lines.forEach { (i) in
                    i.grow = 0
                }
            }
            selfLine?.layout()
            self.lines.forEach { (i) in
                i.layout()
            }
            
        }else{
            self.lines = [FlexLine(width: resultW, height: resultH, justifyContent: self.justifyContent, alignItem: alignItem, subBoxs: self.subBoxs, direction: self.direction)]
            self.lines.forEach { (l) in
                l.layout()
            }
        }
        self.storeRect(result: self.resultRect)
        self.subBoxs.forEach { (i) in
            i.layout()
        }
    }
    func seperatedLines(subBox:[FlexSubBox],
                        sumKeyPath:KeyPath<LayoutBox,CGFloat>)->[FlexLine]{
        var sum:CGFloat = 0
        var lines:[FlexLine] = []
        var lastStart:Int = 0
        for i in (0..<subBox.count){
            if (sum + (subBox[i][keyPath:sumKeyPath])) > (self[keyPath:sumKeyPath]){
                if(i == lastStart){
                    
                    let f = FlexLine(width: self.resultW, height: self.resultH, justifyContent: self.justifyContent, alignItem: self.alignItem, subBoxs: [subBox[i]], direction: self.direction)
                    lines.append(f);
                    lastStart += 1
                    sum = 0
                }else{
                    let a = Array(subBox[lastStart..<i])
                    let f = FlexLine(width: self.resultW, height: self.resultH, justifyContent: self.justifyContent, alignItem: self.alignItem, subBoxs: a, direction: self.direction)
                    lines.append(f);
                    lastStart = i
                    sum = (subBox[i][keyPath:sumKeyPath])
                }
            }else{
                sum += (subBox[i][keyPath:sumKeyPath])
            }
        }
        if (lastStart < subBoxs.count){
            let a = Array(subBox[lastStart..<subBoxs.count])
            let f = FlexLine(width: self.resultW, height: self.resultH, justifyContent: self.justifyContent, alignItem: self.alignItem, subBoxs: a, direction: self.direction)
            lines.append(f)
            lastStart = subBoxs.count
        }
        return lines;
    }
    public func fixSize() {
        if let h = self.host,needFitSize{
            let size = CGSize(width: self.width ?? .infinity, height: self.height ?? .infinity)
            let fitsize = h.sizeThatFits(size)
            if self.width == nil{
                self.width = fitsize.width
            }
            if(self.height == nil){
                self.height = fitsize.height
            }
        }
    }
    
    
    // for block
}
class FlexLine: FlexSubBox{
    var relativePostion: Relative = .none
    
    func fixSize() {
        
    }
    func storeRect(result: CGRect) {
        
    }
    var needFitSize: Bool = false
    
    var host: UIView?
    
    var direction: FlexDirection
    
    var resultX: CGFloat = 0
    
    var resultY: CGFloat = 0
    
    var resultW: CGFloat
    
    var resultH: CGFloat
    
    var width: CGFloat?{
        didSet{
            print("ok")
        }
    }
    
    var height: CGFloat?{
        didSet{
            print("ok")
        }
    }
    
    var grow: Int = 1
    
    var shrink: Int = 0
    
    var alignSelf: Align?
    
    var justifyContent: Justify
    
    var alignItem: Align
    
    var subBoxs: [FlexSubBox]
    
    init(width:CGFloat?,
         height:CGFloat?,
         justifyContent: Justify,
         alignItem: Align,
         subBoxs: [FlexSubBox],
         direction:FlexDirection) {
        self.width = width
        self.height = height
        self.justifyContent = justifyContent
        self.alignItem = alignItem
        self.subBoxs = subBoxs
        self.resultW = width ?? 0
        self.resultH = height ?? 0
        self.direction = direction
        switch direction {
        case .column:
            self.width = self.calcBasic(itemKeyPath: \Rect.width)
            self.height = height
        case .row:
            self.height = self.calcBasic(itemKeyPath: \Rect.height)
            self.width = width
        }
    }
    func calcBasic(itemKeyPath:KeyPath<Rect,CGFloat?>) -> CGFloat {
        return self.subBoxs.reduce(0) { (r, c) -> CGFloat in
            return (c[keyPath:itemKeyPath] ?? 0) > r ? (c[keyPath:itemKeyPath] ?? 0) : r
        }
    }
    func calcItemSpace(itemSpaceKeyPath:ReferenceWritableKeyPath<LayoutBox,CGFloat>,
                   sourceKeyPath:KeyPath<Rect,CGFloat?>,
                   subBoxs:[FlexSubBox])->CGFloat{
        let sum = calcOriginUsage(subBoxs: subBoxs, keyPath: sourceKeyPath)
        let basic = self[keyPath:sourceKeyPath] ?? 0
        let unuse = basic - sum
        if unuse > 0{
            let w = weightSum(subBox: subBoxs, keyPath: \FlexItem.grow)
            if w != 0{
                subBoxs.forEach { (i) in
                    let p = CGFloat(i[keyPath:\FlexItem.grow]) / CGFloat(w)
                    let add = unuse * p
                    i[keyPath:itemSpaceKeyPath] = (i[keyPath:sourceKeyPath] ?? 0) + add
                }
                return 0
            }else{
                subBoxs.forEach { (i) in
                    i[keyPath:itemSpaceKeyPath] = (i[keyPath:sourceKeyPath] ?? 0)
                }
                return unuse
            }
            
        }else if unuse < 0{
            let w = weightSum(subBox: subBoxs, keyPath: \FlexItem.shrink)
            if w != 0{
                subBoxs.forEach { (i) in
                    let p = CGFloat(i[keyPath:\FlexItem.shrink]) / CGFloat(w)
                    let add = unuse * p
                    i[keyPath:itemSpaceKeyPath] = (i[keyPath:sourceKeyPath] ?? 0) + add
                }
                return 0
            }else{
                subBoxs.forEach { (i) in
                    i[keyPath:itemSpaceKeyPath] = (i[keyPath:sourceKeyPath] ?? 0)
                }
                return unuse
            }
        }
        return unuse
    }
    func calcJustContent(itenXKeyPath:ReferenceWritableKeyPath<LayoutBox,CGFloat>,
                         sourceWKeyPath:KeyPath<LayoutBox,CGFloat>,
                         justContent:Justify,
                         subBoxs:[FlexSubBox],
                         unuse:CGFloat){
        var i:CGFloat = 0
        var step:CGFloat = 0
        switch justContent {
        case .start,.stretch:
            i = 0
            step = 0
            break
        case .center:
            i = unuse / 2
            step = 0
            break
        case .end:
            i = unuse
            step = 0
        case .between:
            i = 0
            step = unuse / CGFloat(subBoxs.count - 1)
            break
        case .around:
            i = unuse / CGFloat(subBoxs.count * 2)
            step = unuse / CGFloat(subBoxs.count)
            break
        case .evenly:
            i = unuse / CGFloat(subBoxs.count + 1)
            step = i
            break
        }
        self.subBoxs.forEach { (item) in
            item[keyPath:itenXKeyPath] = i
            i = i + item[keyPath:sourceWKeyPath] + step
        }
    }
    func calcAlignItem(keyYKeyPath:ReferenceWritableKeyPath<LayoutBox,CGFloat>,
                       keyHKeyPath:ReferenceWritableKeyPath<LayoutBox,CGFloat>,
                       alignItem:Align,
                       sourceYKeyPath:KeyPath<LayoutBox,CGFloat>,
                       sourceHKeyPath:KeyPath<Rect,CGFloat?>,
                       subBox:[FlexSubBox]){
        
        let start = self[keyPath:sourceYKeyPath]
        subBox.forEach { (i) in
            switch (i.alignSelf ?? alignItem) {
            case .start:
                i[keyPath:keyYKeyPath] = start
                i[keyPath:keyHKeyPath] = i[keyPath:sourceHKeyPath] ?? 0
                break;
            case .center:
                let value = (self[keyPath:keyHKeyPath] - i[keyPath:keyHKeyPath]) / 2
                i[keyPath:keyYKeyPath] = start + value
                i[keyPath:keyHKeyPath] = i[keyPath:sourceHKeyPath] ?? 0
                break;
            case .end:
                let value = (self[keyPath:keyHKeyPath] - i[keyPath:keyHKeyPath])
                i[keyPath:keyYKeyPath] = start + value
                i[keyPath:keyHKeyPath] = i[keyPath:sourceHKeyPath] ?? 0
                break;
            case .stretch:
                i[keyPath:keyYKeyPath] = start
                if(i[keyPath:sourceHKeyPath] == nil){
                    i[keyPath:keyHKeyPath] = self[keyPath:keyHKeyPath]
                }else{
                    i[keyPath:keyHKeyPath] = i[keyPath:sourceHKeyPath]!
                }
                break;
            }
        }
    }
    func weightSum(subBox:[FlexItem],keyPath:KeyPath<FlexItem,Int>)->Int{
        return subBox.reduce(0) { (r, i) -> Int in
            return r + i[keyPath:keyPath]
        }
    }
    func calcOriginUsage(subBoxs:[FlexSubBox],
                   keyPath:KeyPath<Rect,CGFloat?>)->CGFloat{
        return subBoxs.reduce(0) { (r, c) -> CGFloat in
            return r + (c[keyPath:keyPath] ?? 0)
        }
    }
    func layout(){
        switch self.direction {
        case .row:
            let unuse = self.calcItemSpace(itemSpaceKeyPath: \LayoutBox.resultW, sourceKeyPath: \Rect.width, subBoxs: self.subBoxs)
            self.calcJustContent(itenXKeyPath: \LayoutBox.resultX, sourceWKeyPath: \LayoutBox.resultW, justContent: justifyContent, subBoxs: self.subBoxs, unuse: unuse)
            self.calcAlignItem(keyYKeyPath: \LayoutBox.resultY, keyHKeyPath: \LayoutBox.resultH, alignItem: self.alignItem, sourceYKeyPath: \LayoutBox.resultY, sourceHKeyPath: \Rect.height, subBox: self.subBoxs)
        case .column:
            let unuse = self.calcItemSpace(itemSpaceKeyPath: \LayoutBox.resultH, sourceKeyPath: \Rect.height, subBoxs: self.subBoxs)
            self.calcJustContent(itenXKeyPath: \LayoutBox.resultY, sourceWKeyPath: \LayoutBox.resultH, justContent: justifyContent, subBoxs: self.subBoxs, unuse: unuse)
            self.calcAlignItem(keyYKeyPath: \LayoutBox.resultX, keyHKeyPath: \LayoutBox.resultW, alignItem: self.alignItem, sourceYKeyPath: \LayoutBox.resultX, sourceHKeyPath: \Rect.width, subBox: self.subBoxs)
            break
        }
        self.subBoxs.forEach { (i) in
            i.storeRect(result: i.resultRect)
        }
    }
}
