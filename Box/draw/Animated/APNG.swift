//
//  APNG.swift
//  rxs
//
//  Created by Francis on 2018/6/12.
//  Copyright © 2018年 Francis. All rights reserved.
//

import Foundation
import ImageIO

public class APNG{
    public var images:[CGImage] = []
    public var time:Double = 0
    public required init(data:Data){
        if let source = CGImageSourceCreateWithData(data as CFData, nil){
            for i in 0 ..< CGImageSourceGetCount(source){
                if let cimg = CGImageSourceCreateImageAtIndex(source, i, nil){
                    self.images.append(cimg)
                    let dic = (CGImageSourceCopyPropertiesAtIndex(source, i, nil) as! Dictionary<String,Any>)["{PNG}"] as! Dictionary<String,Any>
                    if let unclamped = dic["UnclampedDelayTime"]{
                        if (unclamped as! Double) < 0.001{
                            if let dt = dic["DelayTime"]{
                                time += dt as! Double
                            }
                        }else{
                            time += unclamped as! Double
                            print(time)
                        }
                    }else{
                        if let dt = dic["DelayTime"]{
                            time += dt as! Double
                        }
                    }
                }
            }
        }
    }
    public convenience init(url:URL) throws{
        let data = try Data(contentsOf: url)
        self.init(data: data)
    }
}
