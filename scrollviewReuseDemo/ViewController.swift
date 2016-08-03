//
//  ViewController.swift
//  scrollviewReuseDemo
//
//  Created by 李林凯 on 16/8/3.
//  Copyright © 2016年 7k7k. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var contentView: ReuseScrollView!
    var imageArray = [UIImage]()    //资源照片
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 1...5 {
            imageArray.append(UIImage.init(named: "\(index)")!)
        }
        
        contentView.initDataSource(imageArray)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
