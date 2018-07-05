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
        base.alignItem = .start
//        base.wrap = true
        let a = FlexBox(width: 150, height: 60);
        let b = FlexBox(width: 150, height: 70);
        b.shrink = 2
        a.shrink = 1
        let c = FlexBox(width: 150, height: 80);
        a.alignSelf = .end
        let d = FlexBox(width: 150, height: 90);
        base.subBoxs = [a,b,c]
        
        base.layout()
        base.subBoxs.forEach { (i) in
            let v = UIView(frame: i.resultRect)
            v.backgroundColor = UIColor.red;
            self.view.addSubview(v);
        }
    }
}

