//
//  demoVC.swift
//  demo
//
//  Created by hao yin on 2018/7/10.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import UIKit
import Box
class demoVC: UIViewController {

    @IBOutlet weak var container: FlexBoxView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeNav()
    }
}

extension demoVC{
    func makeNav(){
        self.container.layout.direction = .column
        self.container.layout.alignContent = .stretch
        self.container.layout.alignItem = .stretch
        let naviInfo = self.container.makeSubView(width: nil, height: 44, type: FlexBoxView.self)
        
        let contentInfo = self.container.makeSubView(width: nil, height: 10, type: FlexBoxView.self)
        contentInfo.host?.backgroundColor = UIColor.black
        contentInfo.grow = 1;
//        naviInfo.justifyContent = .between
        naviInfo.host?.backgroundColor = UIColor.gray
        let btnInfo = naviInfo.host?.makeSubView(width: nil, height: 44, type: UIButton.self)
        btnInfo?.host?.setTitle("left", for: .normal)
        btnInfo?.needFitSize = true
        btnInfo?.relativePostion = .leftTop(left: 8, top: nil)
        btnInfo?.host?.setTitleColor(UIColor.red, for: .normal)
        let lblInfo = naviInfo.host?.makeSubView(width: 44, height: 44, type: UILabel.self)
        lblInfo?.grow = 1
        lblInfo?.host?.textAlignment = .center
        let btn2Info = naviInfo.host?.makeSubView(width: nil, height: 44, type: UIButton.self)
        btn2Info?.needFitSize = true
        btn2Info?.host?.setTitleColor(UIColor.black, for: .normal)
        btn2Info?.host?.setTitle("right", for: .normal)
        btn2Info?.relativePostion = .bottonRight(bottom: nil, right: 8)
        lblInfo?.host?.text = "title";
    }
}
