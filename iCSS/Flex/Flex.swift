//
//  Flex.swift
//  Bush
//
//  Created by hao yin on 2018/7/1.
//  Copyright © 2018年 Francis. All rights reserved.
//

import Foundation
import QuartzCore

public enum Align{
    case start
    case center
    case end
    case stretch
}
public enum JustContent{
    case start
    case center
    case end
    case between
    case around
    case evenly
}
public protocol FlexLineSupport{
    var alignItem:Align{get}
    var justContent:JustContent {get}
    var direction:FlexDirection {get}
}
public protocol FlexFrameSupport{
    var alignContent:Align{get}
    var wrap:Bool {get}
}
public class FlexBox:FlexItemSupport,FlexLineSupport,FlexFrameSupport,layoutTool,LayoutFrame{
    public func assigeSuper(sup:ItemProperty) {
        self.superBox = sup
    }
    public func addSubTool(tool:ItemProperty) {
        self.subBoxes .append(tool)
        tool.assigeSuper(sup:self)
    }
    public var superBox: layoutTool?
    
    public weak var host: LayoutFrame?
    
    public var width: Dimension = .accuracy(0)
    public var height: Dimension = .accuracy(0)
    public var grow: Int = 0
    public var shrink: Int = 0
    public var alignItem: Align = .stretch
    public var alignSelf: Align?
    public var alignContent: Align = .stretch
    public var justContent: JustContent = .start
    public var direction: FlexDirection = .horizental
    public var wrap: Bool = false

    public func setHost(host: LayoutFrame) {
        self.host = host
    }
    public var subBoxes:[ItemProperty] = []
    public func layout(){
        if wrap{
            switch self.direction {
            case .horizental:
                self.lines = self.wrapSeperatedLine(keyPath: \ItemProperty.width, basic: self.realW, alignContent: self.alignContent)
                self.calcLineSpace(lines: self.lines, alignContent: self.alignContent, parentKeyPath: \ItemProperty.height, container: self, relate: self.realH)
                self.lines.forEach{$0.layout()}
            case .vertical:
                self.lines = self.wrapSeperatedLine(keyPath: \ItemProperty.height, basic: self.realH, alignContent: self.alignContent)
                self.calcLineSpace(lines: self.lines, alignContent: self.alignContent, parentKeyPath: \ItemProperty.width, container: self, relate: self.realW)
                self.lines.forEach{$0.layout()}
            }
        }else{
            switch self.direction {
            case .horizental:
                self.lines = [FlexLine(basic: self.realW, alignItem: self.alignItem, justContent: self.justContent, direction: direction, subBox: self.subBoxes)]
                self.calcLineSpace(lines: self.lines, alignContent: self.alignContent, parentKeyPath: \ItemProperty.height, container: self, relate: self.realH)
                self.lines.forEach{$0.layout()}
            case .vertical:
                self.lines = [FlexLine(basic: self.realH, alignItem: self.alignItem, justContent: self.justContent, direction: direction, subBox: self.subBoxes)]
                self.calcLineSpace(lines: self.lines, alignContent: self.alignContent, parentKeyPath: \ItemProperty.width, container: self, relate: self.realW)
                self.lines.forEach{$0.layout()}
            }
        }
    }
    var lines:[FlexLine] = []
    public var resultX:CGFloat{
        get{
            return self.host?.resultX ?? 0
        }
        set{
            self.host?.resultX = newValue
        }
    }
    public var resultY:CGFloat{
        get{
            return self.host?.resultY ?? 0
        }
        set{
            self.host?.resultY = newValue
        }
    }
    public var resultWidth:CGFloat{
        get{
            return self.host?.resultWidth ?? 0
        }
        set{
            self.host?.resultWidth = newValue
        }
    }
    public var resultHeight:CGFloat{
        get{
            return self.host?.resultHeight ?? 0
        }
        set{
            self.host?.resultHeight = newValue
        }
    }
    public var rect:CGRect{
        return CGRect(x: resultX, y: resultY, width: resultWidth, height: resultHeight)
    }
    private func genLine(current:Int,lastIndex:Int,basic:CGFloat)->FlexLine{
        let c = lastIndex ... current - 1
        let line = FlexLine(basic: basic, alignItem: self.alignItem, justContent: self.justContent, direction: self.direction, subBox: Array(self.subBoxes[c]))
        return line
    }
    public func wrapSeperatedLine(keyPath:KeyPath<ItemProperty,Dimension>,
                                  basic:CGFloat,
                                  alignContent:Align)->[FlexLine]{
        var sum:CGFloat = 0
        var lastIndex:Int = 0
        var lines:[FlexLine] = []
        for i in (0..<subBoxes.count) {
            let temp = sum + subBoxes[i][keyPath:keyPath].calc(relate: basic);
            if (temp > basic && i > lastIndex){
                lines.append(self.genLine(current:i,lastIndex: lastIndex, basic: basic))
                lastIndex = i
                sum = subBoxes[i][keyPath:keyPath].calc(relate: basic);
            }else if(temp > basic && i == lastIndex){
                lines.append(self.genLine(current:i + 1,lastIndex: lastIndex, basic: basic))
                lastIndex = i + 1
                sum = 0
            }else{
                sum = temp;
            }
            
        }
        if lastIndex < self.subBoxes.count{
            let c = lastIndex ... self.subBoxes.count - 1
            let line = FlexLine(basic: basic, alignItem: self.alignItem, justContent: self.justContent, direction: self.direction, subBox: Array(self.subBoxes[c]))
            lines.append(line)
        }
        return lines
    }
    private func calcLineSpace(lines:[FlexLine],
                               alignContent:Align,
                               parentKeyPath:KeyPath<ItemProperty,Dimension>,
                               container:FlexBox,relate:CGFloat){
        let max = container[keyPath:parentKeyPath].calc(relate: relate)
        let sumBasic = lines.reduce(0) { (r, c) -> CGFloat in
            return r + c.verticalBasic
        }
        let unused = (max - sumBasic) / CGFloat(lines.count)
        if unused > 0{
            switch alignContent {
            case .stretch:
                for i in (0..<lines.count) {
                    let line = lines[i]
                    line.verticalSpace = line.verticalBasic + unused
                }
            default:
                for i in (0..<lines.count) {
                    let line = lines[i]
                    line.verticalSpace = line.verticalBasic
                }
            }
            
        }
        switch self.direction {
        case .vertical:
            calcAlignItemStartValue(lines: lines, space: \ItemProperty.realW, alignContent: self.alignContent)
        case .horizental:
            calcAlignItemStartValue(lines: lines, space: \ItemProperty.realH, alignContent: self.alignContent)
        }
        
    }
    private func calcAlignItemStartValue(lines:[FlexLine],space:KeyPath<ItemProperty,CGFloat>,alignContent:Align){
        let u = lines.reduce(0) { (r, c) -> CGFloat in
            return r + c.verticalBasic
        }
        let unuse = self[keyPath:space] - u
        var start:CGFloat = 0
        switch alignContent {
        case .center:
            start = unuse / 2
        case .start:
            start = 0
        case .end:
            start = unuse
        case .stretch:
            start = 0;
        }
        for i in (0..<lines.count){
            let line = lines[i];
            line.verticalOffset = start
            start += line.verticalSpace
        }
    }
    public required init(size:CGSize){
        self.width = .accuracy(size.width)
        self.height = .accuracy(size.height)
        self.resultX = 0
        self.resultY = 0
        self.resultWidth = size.width
        self.resultHeight = size.height
    }
    
}
public class FlexLine:FlexLineSupport{
    public var alignItem: Align = .stretch
    public var justContent: JustContent = .start
    public var direction: FlexDirection
    public var basic:CGFloat
    public var verticalBasic:CGFloat
    public var verticalOffset:CGFloat = 0
    public var verticalSpace: CGFloat = 0
    public var subBoxes:[layoutTool & ItemProperty]
    public init(basic: CGFloat,
                alignItem: Align,
                justContent: JustContent,
                direction: FlexDirection,
                subBox:[layoutTool & ItemProperty]) {
        self.basic = basic
        self.alignItem = alignItem
        self.justContent = justContent
        self.subBoxes = subBox
        self.direction = direction
        switch direction {
        case .vertical:
            verticalBasic = self.subBoxes.reduce(0) { (i, current) -> CGFloat in
                if current.width.calc(relate: basic) > i{
                    return current.width.calc(relate: basic)
                }
                return i
            }
        case .horizental:
            verticalBasic = self.subBoxes.reduce(0) { (i, current) -> CGFloat in
                if current.height.calc(relate: basic) > i{
                    return current.height.calc(relate: basic)
                }
                return i
            }
        }
    }
    public func layout(){
        switch direction {
        case .horizental:
            self.verifySpace(sourcekeyPath: \ItemProperty.width, resultKeyPath: \ItemProperty.resultWidth, box: self.subBoxes, basic: self.basic)
            self.verifyJustContent(spacekeyPath: \ItemProperty.resultWidth, resultKeyPath: \ItemProperty.resultX, justContent: self.justContent, boxes: self.subBoxes, basic: self.basic)
            self.calcAlignItem(alignItem: self.alignItem, subox: self.subBoxes, offset: self.verticalOffset, vSpace: self.verticalSpace, relate: self.basic, sourceKeyPath: \ItemProperty.height, resultKeyPath: \ItemProperty.resultY, stretchKeyPath: \ItemProperty.resultHeight)
        case .vertical:
            self.verifySpace(sourcekeyPath: \ItemProperty.height, resultKeyPath: \ItemProperty.resultHeight, box: self.subBoxes, basic: self.basic)
            self.verifyJustContent(spacekeyPath: \ItemProperty.resultHeight, resultKeyPath: \ItemProperty.resultY, justContent: self.justContent, boxes: self.subBoxes, basic: self.basic)
            self.calcAlignItem(alignItem: self.alignItem, subox: self.subBoxes, offset: self.verticalOffset, vSpace: self.verticalSpace, relate: self.basic, sourceKeyPath: \ItemProperty.width, resultKeyPath: \ItemProperty.resultX, stretchKeyPath: \ItemProperty.resultWidth)
        }
    }
    public func extraSpaceCalc(sizeKey:KeyPath<ItemProperty,Dimension>,boxes:[layoutTool & ItemProperty],basic:CGFloat)->CGFloat{
        return basic - boxes.reduce(0) { (r, current) -> CGFloat in
            return r + current[keyPath:sizeKey].calc(relate: basic)
        }
    }
    public func verifySpace(sourcekeyPath:KeyPath<ItemProperty,Dimension>,
                            resultKeyPath:WritableKeyPath<ItemProperty,CGFloat>,
                            box:[layoutTool & ItemProperty],basic:CGFloat){
        let extraSpace = self .extraSpaceCalc(sizeKey: sourcekeyPath, boxes: box, basic: basic)
        let sumW = box.reduce(0) { (r, c) -> Int in
            if extraSpace > 0{
                return r + c.grow
            }else if extraSpace < 0{
                return r + c.shrink
            }else{
                return 0
            }
        }
        for i in (0 ..< box.count) {
            var current = box[i]
            let p = extraSpace > 0 ? current.grow : extraSpace < 0 ? current.shrink : 0
            current[keyPath:resultKeyPath] = current[keyPath:sourcekeyPath].calc(relate: basic) + (sumW != 0 ? (CGFloat(p) / CGFloat(sumW)) * extraSpace : 0)
        }
    }
    public func verifyJustContent(spacekeyPath:KeyPath<ItemProperty,CGFloat>,
                                  resultKeyPath:WritableKeyPath<ItemProperty,CGFloat>,
                                  justContent:JustContent,
                                  boxes:[layoutTool & ItemProperty],
                                  basic:CGFloat){
        let unfillSpace = basic - self.calcCannotFillSpace(spacekeyPath: spacekeyPath, boxes: boxes)
        var start =  self .calcjustContentStartValue(justContent: justContent, unfill: unfillSpace, itemCount: boxes.count)
        for i in (0..<boxes.count) {
            var item = boxes[i]
            item[keyPath:resultKeyPath] = start
            switch justContent {
            case .start,.end,.center:
                start = start + item[keyPath:spacekeyPath]
                break;
            case .evenly:
                start = start + item[keyPath:spacekeyPath] + unfillSpace / CGFloat(boxes.count + 1)
                break;
            case .around:
                start = start + item[keyPath:spacekeyPath] + unfillSpace / CGFloat(boxes.count)
                break;
            case .between:
                start = start + item[keyPath:spacekeyPath] + unfillSpace / CGFloat(boxes.count - 1)
                break;
            }
        }
    }
    private func calcjustContentStartValue(justContent:JustContent,unfill:CGFloat,itemCount:Int)->CGFloat{
        switch justContent {
        case .start:
            return 0
        case .center:
            return unfill / 2
        case .end:
            return unfill;
        case .evenly:
            return unfill / CGFloat(itemCount + 1)
        case .around:
            return unfill / CGFloat(itemCount) / 2
        case .between:
            return 0
        }
    }
    private func calcCannotFillSpace(spacekeyPath:KeyPath<ItemProperty,CGFloat>,
                                     boxes:[layoutTool & ItemProperty])->CGFloat{
        return boxes.reduce(0) { (r, c) -> CGFloat in
            return r + c[keyPath:spacekeyPath]
        }
    }
    
    private func calcAlignItem(alignItem:Align,
                               subox:[layoutTool & ItemProperty],
                               offset:CGFloat,
                               vSpace:CGFloat,
                               relate:CGFloat,
                               sourceKeyPath:KeyPath<ItemProperty,Dimension>,
                               resultKeyPath:WritableKeyPath<ItemProperty,CGFloat>,
                               stretchKeyPath:WritableKeyPath<ItemProperty,CGFloat>){
        subox.forEach { (i) in
            var box = i
            switch i.alignSelf ?? alignItem {
            case .start:
                box[keyPath:resultKeyPath] = offset
                box[keyPath:stretchKeyPath] = box[keyPath:sourceKeyPath].calc(relate: relate)
                break;
            case .center:
                box[keyPath:resultKeyPath] = offset + (vSpace - box[keyPath:sourceKeyPath].calc(relate: relate)) / 2
                box[keyPath:stretchKeyPath] = box[keyPath:sourceKeyPath].calc(relate: relate)
            case .end:
                box[keyPath:resultKeyPath] = offset + vSpace - box[keyPath:sourceKeyPath].calc(relate: relate)
                box[keyPath:stretchKeyPath] = box[keyPath:sourceKeyPath].calc(relate: relate)
            case .stretch:
                box[keyPath:resultKeyPath] = offset
                box[keyPath:stretchKeyPath] = vSpace
            }
        }
    }
}
