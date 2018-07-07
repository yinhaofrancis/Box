//
//  ViewController.swift
//  demo
//
//  Created by hao yin on 2018/7/4.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import UIKit
import Box
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let base = FlexBox(width: self.view.frame.width, height: self.view.frame.height);
        base.justifyContent = .end
        base.alignContent = .between
        base.alignItem = .stretch
//        base.wrap = true
        let a = FlexBox(width: 100, height: nil);
        let b = FlexBox(width: 100, height: nil);
        let c = FlexBox(width: 100, height: nil);
        let d = FlexBox(width: 150, height: nil);
        base.subBoxs = [a,b,c]
        base.layout()
        base.subBoxs.forEach { (i) in
            let v = UIView(frame: i.resultRect)
            v.backgroundColor = UIColor.red;
            self.view.addSubview(v);
        }
    }
}

