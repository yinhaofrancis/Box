//
//  FlexBoxView.swift
//  Box
//
//  Created by hao yin on 2018/7/7.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import UIKit
extension UIView{
    func applyResult(rect:CGRect){
        if let s = self as? FlexBoxView{
            if !s.autoLayout{
                self.frame = rect
            }
        }else{
            self.frame = rect
        }
        
    }
}

@IBDesignable
public class FlexBoxView: UIView {
    
    public var autoLayout:Bool
    public var layout:FlexBox<FlexBoxView>
    public override init(frame: CGRect) {
        layout = FlexBox(width: frame.width < 0 ? nil : frame.width, height: frame.height < 0 ? nil : frame.height)
        autoLayout = true
        super.init(frame: frame)
        layout.host = self
    }
    
    init(frame: CGRect,root:Bool) {
        layout = FlexBox(width: frame.width < 0 ? nil : frame.width, height: frame.height < 0 ? nil : frame.height)
        autoLayout = root;
        super.init(frame: frame)
        layout.host = self
    }
    required public init?(coder aDecoder: NSCoder) {
        layout = FlexBox(width:0 , height: 0)
        autoLayout = true
        super.init(coder: aDecoder)
        layout.host = self
        
    }
    public override func addSubview(_ view: UIView) {
        if let v = view as? FlexBoxView{
            self.layout.addSubBox(box: v.layout)
        }
        super.addSubview(view)
    }
    public override func layoutSubviews() {
        if self.autoLayout{
            self.layout.width = self.frame.width
            self.layout.height = self.frame.height
            self.layout.layout()
            
        }
    }
    public func makeSubView<T:UIView>(width:CGFloat?,height:CGFloat?,type:T.Type)->FlexBox<T>{
        let f = FlexBox<T>(width: width, height: height);
        let v = T(frame: CGRect(x: 0, y: 0, width: width ?? 0, height: height ?? 0));
        if let container = v as? FlexBoxView{
            container.autoLayout = false
        }
        self.layout.addSubBox(box: f)
        self.addSubview(v)
        f.host = v
        return f
    }
}
