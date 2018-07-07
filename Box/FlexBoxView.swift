//
//  FlexBoxView.swift
//  Box
//
//  Created by hao yin on 2018/7/7.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import UIKit
@IBDesignable
public class FlexBoxView: UIView {
    
    public var layout:FlexBox
    public override init(frame: CGRect) {
        layout = FlexBox(width: frame.width < 0 ? nil : frame.width, height: frame.height < 0 ? nil : frame.height)
        super.init(frame: frame)
        layout.host = self
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func addSubview(_ view: UIView) {
        if let v = view as? FlexBoxView{
            self.layout.addSubBox(box: v.layout)
        }
        super.addSubview(view)
    }
}
