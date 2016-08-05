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
    var descArray = [String]()    //资源照片
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlArray = ["http://scimg.jb51.net/allimg/160618/77-16061Q44U6444.jpg",
                        "http://pic25.nipic.com/20121112/5955207_224247025000_2.jpg",
                        "http://www.pptbz.com/pptpic/UploadFiles_6909/201204/2012041411433867.jpg",
                        "http://tx.haiqq.com/uploads/allimg/150327/2100245K1-8.jpg",
                        "http://img5.duitang.com/uploads/item/201508/25/20150825002604_PLTdw.thumb.224_0.png"]
        
        
        for index in 1...5 {
            imageArray.append(UIImage.init(named: "\(index)")!)
            descArray.append("这是第\(index)")
        }
        
        contentView.initDataSource(urlArray,descsValue: descArray)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
