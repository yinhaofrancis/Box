//
//  ViewController.swift
//  demo
//
//  Created by hao yin on 2018/7/3.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import UIKit
import iCSS
class ViewController: UIViewController {

    override func loadView() {
        self.view = iCSSView<FlexBox>.init(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.white
    }
    var flexView:iCSSView<FlexBox>{
        return self.view as! iCSSView<FlexBox>
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.flexView.layout.justContent = .evenly
        self.flexView.layout.direction = .vertical
        for i in (0...5) {
            let v = iCSSView<FlexBox>.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            self.flexView .addSubLayoutItem(tool: v)
            v.backgroundColor = UIColor.black
        }
        self.flexView.layout.layout()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

