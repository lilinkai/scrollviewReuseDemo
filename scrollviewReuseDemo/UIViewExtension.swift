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
    
    func setWidth(width:CGFloat) {
        frame.size.width = width
    }
    
    func setHeight(height:CGFloat) {
        frame.size.height = height
    }
    
    var left:CGFloat {return frame.origin.x}
    var right:CGFloat {return frame.origin.x + frame.size.width}
    
    func setLeft(left:CGFloat) {
        frame.origin.x = left
    }
    
    func setRight(right:CGFloat) {
        frame.origin.x = right + frame.size.width
    }
    
    
    
}
