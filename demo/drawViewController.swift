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
        let r = Rectangle(size: CGSize(width: 60, height: 40), radius: 8)
        r.texture = Texture(color: .red)
        let b = Rectangle(size: CGSize(width: 60, height: 40), radius: 8)
        let a = NSMutableParagraphStyle()
        a.alignment = .center
        b.texture = Texture(string: NSAttributedString(string: "kfkjhf", attributes: [
            NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16),
            NSAttributedStringKey.foregroundColor:UIColor.white,
            NSAttributedStringKey.paragraphStyle:a
            ]))
        b.flex.grow = 1
        let c = Rectangle(size: CGSize(width: 60, height: 40), radius: 8)
        c.texture = Texture(color: .green)
        
        let back = Rectangle(size: CGSize(width: 375, height: 598))
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

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }


}
