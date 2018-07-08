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
    @IBOutlet weak var wrap: UISwitch!
    @IBOutlet weak var base:FlexBoxView!
    @IBOutlet weak var just: UISegmentedControl!
    @IBOutlet weak var alignItem: UISegmentedControl!
    @IBOutlet weak var alignC: UISegmentedControl!
    
    @IBOutlet weak var countS: UISlider!    
    @IBOutlet weak var iy: UISlider!
    @IBOutlet weak var ix: UISlider!
    @IBOutlet weak var direct: UISegmentedControl!
    
    let ju:[Justify] = [.start,.center,.end,.around,.evenly,.between,.stretch]
    let al:[Align] = [.start,.center,.end,.stretch]
    override func viewDidLoad() {
        super.viewDidLoad()
        change()
    }
    @IBAction func change() {
        self.makeView(v: base, just: ju[self.just.selectedSegmentIndex], alignItem: al[self.alignItem.selectedSegmentIndex], alignContent: ju[self.alignC.selectedSegmentIndex], wrap: self.wrap.isOn, count: Int(countS.value), width: ix.value < 30 ? nil :CGFloat(ix.value), height: iy.value < 30 ? nil :CGFloat(iy.value))
        self.base.layout.layout()
    }
    
    func makeView(v:FlexBoxView,just:Justify,alignItem:Align,alignContent:Justify,wrap:Bool,count:Int,width:CGFloat?,height:CGFloat?){
        v.layout.justifyContent = just
        v.layout.alignItem = alignItem
        v.layout.alignContent = alignContent
        v.layout.wrap = wrap
        v.clipsToBounds = true
        
        v.layout.direction =  self.direct.selectedSegmentIndex  > 0 ? .column : .row
        v.layout.subBoxs.removeAll()
        v.subviews.forEach { (i) in
            i.removeFromSuperview()
        }
        for i in (0..<count) {
            let a = v.makeSubView(width: width, height: height, type: UIView.self)
            
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

