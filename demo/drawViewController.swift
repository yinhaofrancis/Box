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

    let canvas = try! Canvas(size:  CGSize(width: 375, height: 598));
    override func viewDidLoad() {
        super.viewDidLoad()
        let r = Rectangle(size: CGSize(width: 60, height: 44), radius: 8)
        r.texture = Texture(color: .red)
        let b = Rectangle(size: CGSize(width: 60, height: 44), radius: 8)
        let a = NSMutableParagraphStyle()
        a.alignment = .center
        b.texture = Texture(string: NSAttributedString(string: "kfkjhf", attributes: [
            NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16),
            NSAttributedStringKey.foregroundColor:UIColor.black,
            NSAttributedStringKey.paragraphStyle:a
            ]))
        b.flex.grow = 1
        let c = Rectangle(size: CGSize(width: 60, height: 44), radius: 8)
        c.texture = Texture(color: .green)
        
        let p = try! Pattern(draw: { (i, c) in
            c.fillEllipse(in: CGRect(x: 6, y: 6, width: 80, height: 80))
            c.strokeEllipse(in: CGRect(x: 2, y: 2, width: 160, height: 160))
        }, rect: CGRect(x: 0, y: 0, width: 200, height: 200))
        let back = Rectangle(size: CGSize(width: 375, height: 598))
        back.texture = Texture(pattern: p)
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

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }


}
