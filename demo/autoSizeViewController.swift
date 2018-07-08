//
//  autoSizeViewController.swift
//  demo
//
//  Created by hao yin on 2018/7/8.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import UIKit
import Box
class autoSizeViewController: UIViewController {
    @IBAction func change(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            a.width = 60
            a.height = 60
            flex.layout.alignItem = .center
            a.grow = 0
            a.needFitSize = true
        }
        if sender.selectedSegmentIndex == 1{
            a.width = 60
            a.height = nil
            flex.layout.alignItem = .center
            a.grow = 0
            a.needFitSize = true
        }
        if sender.selectedSegmentIndex == 2{
            a.height = 60
            a.width = nil
            flex.layout.alignItem = .center
            a.grow = 0
            a.needFitSize = true
        }
        if sender.selectedSegmentIndex == 3{
            a.width = 60
            a.height = nil
            flex.layout.alignItem = .stretch
            a.grow = 0
            a.needFitSize = false
        }
        if sender.selectedSegmentIndex == 4{
            a.grow = 1
            a.height = 60
            a.width = nil
            flex.layout.alignItem = .center
            a.needFitSize = false
        }
        flex.layout.layout()
    }
    

    var a:FlexBox<UILabel>!
    @IBOutlet weak var flex: FlexBoxView!
    override func viewDidLoad() {
        super.viewDidLoad()

        flex.layout.justifyContent = .center
        flex.layout.alignItem = .center
        flex.layout.alignContent = .stretch
        make()
        self.a = maketext()
        make()
        // Do any additional setup after loading the view.
    }
    func make() {
        let a = flex.makeSubView(width: 60, height: 60, type: UIView.self)
        a.host?.backgroundColor = UIColor.red
    }
    func maketext() -> FlexBox<UILabel> {
        let a = flex.makeSubView(width: 60, height: 60, type: UILabel.self)
        a.host?.backgroundColor = UIColor.green
        a.host?.text = "水电费就好手机电话费三等奖三级大风";
        a.host?.numberOfLines = 0
        a.needFitSize = true
        return a
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
