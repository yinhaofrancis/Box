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
        let a = NSMutableParagraphStyle()
        a.alignment = .center
        b.texture = Texture(string: NSAttributedString(string: "大声点啊活", attributes: [
            NSAttributedStringKey.font:UIFont.systemFont(ofSize: 10),
            NSAttributedStringKey.foregroundColor:UIColor.white,
            NSAttributedStringKey.paragraphStyle:a
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

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        canvas.context.clear(CGRect(x: 0, y: 0, width: 300, height: 300))
        let a = NSMutableParagraphStyle()
        a.alignment = .right
        a.lineSpacing = 50
        let trun = CTLineCreateWithAttributedString(NSAttributedString(string: "😄",attributes: [
            NSAttributedStringKey.font:UIFont.systemFont(ofSize: 25),
            NSAttributedStringKey.foregroundColor:UIColor.black]))
        
        let att = NSAttributedString(string: "A high speed phototypesetter in which a font is selectively illuminated by motor-driven scanning mirrors and scanning motion is cancelled in the reflected", attributes: [
            NSAttributedStringKey.font:UIFont.systemFont(ofSize: 25),
            NSAttributedStringKey.foregroundColor:UIColor.black,
//            NSAttributedStringKey.paragraphStyle:a
            ])
        
        let set = CTTypesetterCreateWithAttributedString(att as CFAttributedString)
        let indx = CTTypesetterSuggestLineBreak(set, 0, 300)
        let line = CTTypesetterCreateLine(set, CFRangeMake(0, indx));
        var asc:CGFloat = 0,led:CGFloat = 0,des:CGFloat = 0
        
        CTLineGetTypographicBounds(line, &asc, &des, &led)
        let rect = CTLineGetImageBounds(line, canvas.context)
        let tline = CTLineCreateTruncatedLine(line, 300, .middle, trun)
        canvas.context.textPosition = CGPoint(x: led, y: des)
        CTLineDraw(tline!, canvas.context)
       
        imgView.image = UIImage(cgImage: canvas.context.makeImage()!)
    }


}
