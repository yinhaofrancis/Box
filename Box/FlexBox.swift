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
    var subBoxs:[Box] {get}
    var direction :FlexDirection {get}
}
public protocol FlexBoxItem{
    var wrap:Bool {get}
    var alignContent:Justify {get}
}

public typealias Box = FlexItem & LayoutBox & Rect

public class FlexBox: LayoutBox,FlexItem,FlexLineItem,FlexBoxItem,Rect {
    public var direction: FlexDirection = .row
    
    public var subBoxs: [Box] = []
    
    public var width: CGFloat
    
    public var height: CGFloat
    
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
    
    public init(width:CGFloat,height:CGFloat){
        self.width = width;
        self.height = height;
        self.resultX = 0;
        self.resultY = 0;
        self.resultW = width;
        self.resultH = height;
    }
    public func layout(){
        if(wrap){
            switch(self.direction){
            case .row:
                lines = seperatedLines(subBox: self.subBoxs, sumKeyPath: \Rect.width)
                selfLine = FlexLine(width: width, height: height, justifyContent: alignContent, alignItem: .stretch, subBoxs: lines, direction: .column)
                break;
            case .column:
                lines = seperatedLines(subBox: self.subBoxs, sumKeyPath: \Rect.height)
                selfLine = FlexLine(width: width, height: height, justifyContent: alignContent, alignItem: .stretch, subBoxs: lines, direction: .row)
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
            self.lines = [FlexLine(width: self.width, height: self.height, justifyContent: self.justifyContent, alignItem: alignItem, subBoxs: self.subBoxs, direction: self.direction)]
            self.lines.forEach { (l) in
                l.layout()
            }
        }
    }
    func seperatedLines(subBox:[Box],
                    sumKeyPath:KeyPath<Rect,CGFloat>)->[FlexLine]{
        var sum:CGFloat = 0
        var lines:[FlexLine] = []
        var lastStart:Int = 0
        for i in (0..<subBox.count){
            if (sum + subBox[i][keyPath:sumKeyPath]) > self[keyPath:sumKeyPath]{
                if(i == lastStart){
                    let f = FlexLine(width: self.width, height: self.height, justifyContent: self.justifyContent, alignItem: self.alignItem, subBoxs: [subBox[i]], direction: self.direction)
                    lines.append(f);
                    lastStart += 1
                    sum = 0
                }else{
                    let a = Array(subBox[lastStart..<i])
                    let f = FlexLine(width: self.width, height: self.height, justifyContent: self.justifyContent, alignItem: self.alignItem, subBoxs: a, direction: self.direction)
                    lines.append(f);
                    lastStart = i
                    sum = subBox[i][keyPath:sumKeyPath]
                }
            }else{
                sum += subBox[i][keyPath:sumKeyPath]
            }
        }
        if (lastStart < subBoxs.count){
            let a = Array(subBox[lastStart..<subBoxs.count])
            let f = FlexLine(width: self.width, height: self.height, justifyContent: self.justifyContent, alignItem: self.alignItem, subBoxs: a, direction: self.direction)
            lines.append(f)
            lastStart = subBoxs.count
        }
        return lines;
    }
}
class FlexLine: Rect ,FlexItem,FlexLineItem,LayoutBox{
    var direction: FlexDirection
    
    var resultX: CGFloat = 0
    
    var resultY: CGFloat = 0
    
    var resultW: CGFloat
    
    var resultH: CGFloat
    
    var width: CGFloat
    
    var height: CGFloat
    
    var grow: Int = 1
    
    var shrink: Int = 0
    
    var alignSelf: Align?
    
    var justifyContent: Justify
    
    var alignItem: Align
    
    var subBoxs: [Box]
    
    init(width:CGFloat,
         height:CGFloat,
         justifyContent: Justify,
         alignItem: Align,
         subBoxs: [Box],
         direction:FlexDirection) {
        self.width = width
        self.height = height
        self.justifyContent = justifyContent
        self.alignItem = alignItem
        self.subBoxs = subBoxs
        self.resultW = width
        self.resultH = height
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
    func calcBasic(itemKeyPath:KeyPath<Rect,CGFloat>) -> CGFloat {
        return self.subBoxs.reduce(0) { (r, c) -> CGFloat in
            return c[keyPath:itemKeyPath] > r ? c[keyPath:itemKeyPath] : r
        }
    }
    func calcItemSpace(itemSpaceKeyPath:ReferenceWritableKeyPath<LayoutBox,CGFloat>,
                   sourceKeyPath:KeyPath<Rect,CGFloat>,
                   subBoxs:[Box])->CGFloat{
        let sum = calcOriginUsage(subBoxs: subBoxs, keyPath: sourceKeyPath)
        let basic = self[keyPath:sourceKeyPath]
        let unuse = basic - sum
        if unuse > 0{
            let w = weightSum(subBox: subBoxs, keyPath: \FlexItem.grow)
            if w != 0{
                subBoxs.forEach { (i) in
                    let p = CGFloat(i[keyPath:\FlexItem.grow]) / CGFloat(w)
                    let add = unuse * p
                    i[keyPath:itemSpaceKeyPath] = i[keyPath:sourceKeyPath] + add
                }
                return 0
            }else{
                subBoxs.forEach { (i) in
                    i[keyPath:itemSpaceKeyPath] = i[keyPath:sourceKeyPath]
                }
                return unuse
            }
            
        }else if unuse < 0{
            let w = weightSum(subBox: subBoxs, keyPath: \FlexItem.shrink)
            if w != 0{
                subBoxs.forEach { (i) in
                    let p = CGFloat(i[keyPath:\FlexItem.shrink]) / CGFloat(w)
                    let add = unuse * p
                    i[keyPath:itemSpaceKeyPath] = i[keyPath:sourceKeyPath] + add
                }
                return 0
            }else{
                subBoxs.forEach { (i) in
                    i[keyPath:itemSpaceKeyPath] = i[keyPath:sourceKeyPath]
                }
                return unuse
            }
        }
        return unuse
    }
    func calcJustContent(itenXKeyPath:ReferenceWritableKeyPath<LayoutBox,CGFloat>,
                         sourceWKeyPath:KeyPath<LayoutBox,CGFloat>,
                         justContent:Justify,
                         subBoxs:[Box],
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
                       sourceHKeyPath:KeyPath<Rect,CGFloat>,
                       subBox:[Box]){
        
        let start = self[keyPath:sourceYKeyPath]
        subBox.forEach { (i) in
            switch (i.alignSelf ?? alignItem) {
            case .start:
                i[keyPath:keyYKeyPath] = start
                i[keyPath:keyHKeyPath] = i[keyPath:sourceHKeyPath]
                break;
            case .center:
                let value = (self[keyPath:keyHKeyPath] - i[keyPath:keyHKeyPath]) / 2
                i[keyPath:keyYKeyPath] = start + value
                i[keyPath:keyHKeyPath] = i[keyPath:sourceHKeyPath]
                break;
            case .end:
                let value = (self[keyPath:keyHKeyPath] - i[keyPath:keyHKeyPath])
                i[keyPath:keyYKeyPath] = start + value
                i[keyPath:keyHKeyPath] = i[keyPath:sourceHKeyPath]
                break;
            case .stretch:
                i[keyPath:keyYKeyPath] = start
                i[keyPath:keyHKeyPath] = self[keyPath:keyHKeyPath]
                break;
            }
        }
    }
    func weightSum(subBox:[FlexItem],keyPath:KeyPath<FlexItem,Int>)->Int{
        return subBox.reduce(0) { (r, i) -> Int in
            return r + i[keyPath:keyPath]
        }
    }
    func calcOriginUsage(subBoxs:[Box],
                   keyPath:KeyPath<Rect,CGFloat>)->CGFloat{
        return subBoxs.reduce(0) { (r, c) -> CGFloat in
            return r + c[keyPath:keyPath]
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
        
    }
}
