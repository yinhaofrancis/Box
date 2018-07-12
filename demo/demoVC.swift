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
    var index:Int = 0
    @IBOutlet weak var container: FlexBoxView!
    var contentInfo:FlexBox<FlexBoxView>!
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
        contentInfo = self.container.makeSubView(width: nil, height: nil, type: FlexBoxView.self)
        contentInfo.host?.backgroundColor = UIColor.gray
        contentInfo.grow = 1;
        contentInfo.wrap = true
        contentInfo.justifyContent = .evenly
        contentInfo.alignItem = .center
        naviInfo.host?.backgroundColor = UIColor.white
        let btnInfo = naviInfo.host?.makeSubView(width: 44, height: 44, type: UIButton.self)
        btnInfo?.host?.setTitle("left", for: .normal)
        btnInfo?.relativePostion = .leftTop(left: 8, top: nil)
        btnInfo?.host?.setTitleColor(UIColor.red, for: .normal)
        btnInfo?.host?.addTarget(self, action: #selector(change), for: .touchUpInside)
        let lblInfo = naviInfo.host?.makeSubView(width: 44, height: 44, type: UILabel.self)
        lblInfo?.grow = 1
        lblInfo?.host?.textAlignment = .center
        let btn2Info = naviInfo.host?.makeSubView(width: 44, height: 44, type: UIButton.self)
        btn2Info?.host?.setTitleColor(UIColor.black, for: .normal)
        btn2Info?.host?.setTitle("right", for: .normal)
        btn2Info?.relativePostion = .bottonRight(bottom: nil, right: 8)
        lblInfo?.host?.text = "title";
        btn2Info?.host?.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        for i in (0..<6) {
            
            let a = contentInfo.host?.makeSubView(width: nil, height: nil, type: UIImageView.self)
            a?.needFitSize = true
            if i % 2 == 0{
                a?.host?.image = #imageLiteral(resourceName: "f")
            }else{
                a?.host?.image = #imageLiteral(resourceName: "k")
            }
            
            
            a?.host?.backgroundColor = UIColor.white
        }
//
        
        
    }
    @objc func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func change(){
        index = (index + 1) % 6
        let a:[Justify] = [.start,.center,.end,.between,.evenly,.around]
        contentInfo.justifyContent = a[index]
        UIView.animate(withDuration: 0.4) {
            self.container.layout.layout()
        }
        
    }
}
