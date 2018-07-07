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

    @IBOutlet weak var v: FlexBoxView!
    var flex:FlexBox<FlexBoxView>!
    override func viewDidLoad() {
        super.viewDidLoad()
        v.layout.justifyContent = .center
        v.layout.alignItem = .center
        
        
        flex = v.makeSubView(width: 320, height: 560, type: FlexBoxView.self)
        flex.justifyContent = .center;
        flex.host?.backgroundColor = UIColor.white;
        
        for _ in 0 ..< 2 {
            let c = flex.host?.makeSubView(width: 20, height: nil, type: UILabel.self)
            c?.host?.text = "asdasdasdasd"
            c?.host?.numberOfLines = 0
        }
        flex.layout()
        let c = flex.host?.makeSubView(width: 88, height: 50, type: UIImageView.self)
        c?.host?.image = #imageLiteral(resourceName: "f")
        c?.host?.contentMode = .scaleAspectFit
        c?.host?.clipsToBounds = true
        v.layout.layout()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
}

