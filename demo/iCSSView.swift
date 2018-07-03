//
//  iCSSView.swift
//  demo
//
//  Created by hao yin on 2018/7/3.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import UIKit
import iCSS
public class iCSSView<T:ItemProperty>: UIView,LayoutFrame {
    public override init(frame: CGRect) {
        layout = T(size: frame.size)
        
        super.init(frame: frame)
        layout.setHost(host: self)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public let layout:T
    
    public var resultX: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            self.frame.origin.x = newValue
        }
    }
    public var resultY: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            self.frame.origin.y = newValue
        }
    }
    public var resultWidth: CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            self.frame.size.width = newValue
        }
    }
    public var resultHeight: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            self.frame.size.height = newValue
        }
    }
    public func addSubLayoutItem(tool:iCSSView){
        self.addSubview(tool)
        self.layout.addSubTool(tool: tool.layout)
    }
}
