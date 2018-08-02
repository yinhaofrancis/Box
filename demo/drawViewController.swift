//
//  drawViewController.swift
//  demo
//
//  Created by Francis on 2018/8/2.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import UIKit
import Box
class drawViewController: UIViewController {

    let canvas = try! Canvas(size:  CGSize(width: 300, height: 300), scale: 3, colorFormat: Canvas.ColorFomat.rgb8, clearColor: UIColor.red.cgColor);
    override func viewDidLoad() {
        super.viewDidLoad()
        let r = Rectangle(size: CGSize(width: 30, height: 30), radius: 8)
        r.texture = Texture(color: .red)
        let b = Rectangle(size: CGSize(width: 30, height: 30), radius: 8)
        b.texture = Texture(string: NSAttributedString(string: "大声点啊活动空间就啊好风景啊的风景啊好地方啦的回复速度发货 就的回复啊啥的回复了三顿饭都是 灵魂撒地方", attributes: [
            NSAttributedStringKey.font:UIFont.systemFont(ofSize: 10),
            NSAttributedStringKey.foregroundColor:UIColor.white
            ]))
        b.flex.grow = 1
        let c = Rectangle(size: CGSize(width: 30, height: 30), radius: 8)
        c.texture = Texture(color: .green)
        
        let back = Rectangle(size: CGSize(width: 300, height: 300))
        back.texture = Texture(image: #imageLiteral(resourceName: "f").cgImage!, mode: .scaleToFill)
        back.flex.justifyContent = .start
        back.flex.alignItem = .end
        back.addRect(view: r)
        back.addRect(view: b)
        back.addRect(view: c)
        back.flex.layout()
        if let i = canvas.draw(drawable: back){
            imgView.image = UIImage(cgImage: i)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var imgView:UIImageView!



}
