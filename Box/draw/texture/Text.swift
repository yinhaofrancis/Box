//
//  Text.swift
//  rxs
//
//  Created by Francis on 2018/6/7.
//  Copyright © 2018年 Francis. All rights reserved.
//

import Foundation
import QuartzCore
import CoreText

extension NSAttributedString:Textureable{

    public func drawTexture(canvas: Context, shape: Shape, texture: Texture) {
        canvas.context.saveGState()
        canvas.context.beginTransparencyLayer(auxiliaryInfo: nil)
        canvas.context.concatenate(shape.transform)
        self.clipPath(canvas: canvas, shape: shape, texture: texture, useOrigin: true)
        let frameset = CTFramesetterCreateWithAttributedString(self)
        switch shape.drawMode{
        case .eoFill,.eoFillStroke:
            let frame = CTFramesetterCreateFrame(frameset, CFRange(location: 0, length: self.length), shape.originPath, [kCTFramePathFillRuleAttributeName:CTFramePathFillRule.evenOdd.rawValue] as CFDictionary)
            CTFrameDraw(frame, canvas.context)
        case .fill,.stroke,.fillStroke:
            let frame = CTFramesetterCreateFrame(frameset, CFRange(location: 0, length: self.length), shape.originPath,[kCTFramePathFillRuleAttributeName:CTFramePathFillRule.windingNumber.rawValue] as CFDictionary)
            CTFrameDraw(frame, canvas.context)
        }
        canvas.context.endTransparencyLayer()
        canvas.context.restoreGState()
    }
}
