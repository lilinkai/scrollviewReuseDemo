//
//  UIViewExtension.swift
//  scrollviewReuseDemo
//
//  Created by 李林凯 on 16/8/3.
//  Copyright © 2016年 7k7k. All rights reserved.
//

import UIKit

extension UIView{
    
    var width:CGFloat {return frame.size.width}
    var height:CGFloat {return frame.size.height}
    
    func setWidth(_ width:CGFloat) {
        frame.size.width = width
    }
    
    func setHeight(_ height:CGFloat) {
        frame.size.height = height
    }
    
    var left:CGFloat {return frame.origin.x}
    var right:CGFloat {return frame.origin.x + frame.size.width}
    
    func setLeft(_ left:CGFloat) {
        frame.origin.x = left
    }
    
    func setRight(_ right:CGFloat) {
        frame.origin.x = right + frame.size.width
    }
    
    var top:CGFloat {return frame.origin.y}
    var bottom:CGFloat {return superview!.height - (frame.origin.y + frame.size.height)}
    
    func setTop(_ top:CGFloat) {
        frame.origin.y = top
    }
    
    func setBottom(_ bottom:CGFloat) {
        frame.origin.y = superview!.height - (bottom + frame.size.height)
    }
    
    
    
    
}
