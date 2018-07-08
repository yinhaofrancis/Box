//
//  detailViewController.swift
//  demo
//
//  Created by hao yin on 2018/7/8.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import UIKit
import Box
class detailViewController: UIViewController {

    
    @IBOutlet weak var wrap: UISwitch!
    @IBOutlet weak var base:FlexBoxView!
    @IBOutlet weak var just: UISegmentedControl!
    @IBOutlet weak var alignItem: UISegmentedControl!
    @IBOutlet weak var alignC: UISegmentedControl!
    
    @IBOutlet weak var countS: UISlider!
    let ju:[Justify] = [.start,.center,.end,.around,.evenly,.between,.stretch]
    let al:[Align] = [.start,.center,.end,.stretch]
    override func viewDidLoad() {
        super.viewDidLoad()
        change()
    }
    @IBAction func change() {
        self.makeView(v: base, just: ju[self.just.selectedSegmentIndex], alignItem: al[self.alignItem.selectedSegmentIndex], alignContent: ju[self.alignC.selectedSegmentIndex], wrap: self.wrap.isOn, count: Int(countS.value))
        self.base.layout.layout()
    }
    
    func makeView(v:FlexBoxView,just:Justify,alignItem:Align,alignContent:Justify,wrap:Bool,count:Int){
        v.layout.justifyContent = just
        v.layout.alignItem = alignItem
        v.layout.alignContent = alignContent
        v.layout.wrap = wrap
        v.clipsToBounds = true
        v.layout.subBoxs.removeAll()
        v.subviews.forEach { (i) in
            i.removeFromSuperview()
        }
        for i in (1...count) {
            let a = v.makeSubView(width: CGFloat(30 * i), height: CGFloat(30 * i), type: UIView.self)
            a.host?.layer.borderColor = UIColor.black.cgColor
            a.host?.layer.borderWidth = 1
            if i % 3 == 0{
                a.host?.backgroundColor = UIColor.red
            }
            if i % 3 == 1{
                a.host?.backgroundColor = UIColor.green
            }
            if i % 3 == 2{
                a.host?.backgroundColor = UIColor.blue
            }
        }
        
    }
    
}
