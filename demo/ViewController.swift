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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.v = FlexBoxView(frame: UIScreen.main.bounds)
        v.backgroundColor = UIColor.white
        v.layout.justifyContent = .start
        v.layout.alignItem = .end
        self.view.addSubview(v)
        for i in 0 ..< 2 {
            let c = v.makeSubView(width: nil, height: nil, type: UILabel.self)
            c.host?.text = "asdasdasdasd"
            c.host?.numberOfLines = 1
            c.needFitSize = true
        }
        
        let c = v.makeSubView(width: 88, height: 50, type: UIImageView.self)
        c.host?.image = #imageLiteral(resourceName: "f")
        c.host?.contentMode = .scaleAspectFit
        c.host?.clipsToBounds = true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.v.layout.wrap = true
        self.v.layout.justifyContent = .evenly
        self.v.layout.alignContent = .stretch
        UIView.animate(withDuration: 0.5) {
            self.v.layout.layout()
        }
    }
}

