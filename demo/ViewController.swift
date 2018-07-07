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

    var v: FlexBoxView!
    var v2: FlexBoxView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.v = FlexBoxView(frame: UIScreen.main.bounds)
        v.backgroundColor = UIColor.white
        v.layout.alignItem = .stretch
        self.view.addSubview(v)
        for i in 0 ..< 20 {
            let s = CGSize(width: 20 + i, height: 20 + i)
            let vv = FlexBoxView(frame: CGRect(origin: .zero, size: s))
            vv.backgroundColor = UIColor.blue
            vv.layout.height = nil
            self.v.addSubview(vv)

        }
        self.v2 = FlexBoxView(frame: CGRect(origin: .zero, size: CGSize(width: 60, height: UIScreen.main.bounds.height / 1.5)))
        self.v2.backgroundColor = UIColor.red
        self.v.addSubview(v2)
        self.v.layout.layout()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.v.layout.wrap = true
        self.v2.layout.grow = 1
//        self.v.layout.alignItem = .center
        self.v.layout.justifyContent = .evenly
        self.v.layout.alignContent = .stretch
        self.v.layout.layout()
    }
}

