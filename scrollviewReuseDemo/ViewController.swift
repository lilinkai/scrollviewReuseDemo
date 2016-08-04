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
        
        //ttp://scimg.jb51.net/allimg/160618/77-16061Q44U6444.jpg
        //ttp://img5.imgtn.bdimg.com/it/u=3574049832,481066373&fm=21&gp=0.jpg
        //ttp://www.pptbz.com/pptpic/UploadFiles_6909/201204/2012041411433867.jpg
        
        let urlArray = ["http://scimg.jb51.net/allimg/160618/77-16061Q44U6444.jpg",
                        "http://pic25.nipic.com/20121112/5955207_224247025000_2.jpg",
                        "http://www.pptbz.com/pptpic/UploadFiles_6909/201204/2012041411433867.jpg"]
        
        let queue = NSOperationQueue()
        
        let operation = NSBlockOperation()  //只单独用是同步线程，需要放到队列中
        
        for i in 0..<urlArray.count {
            
            operation.addExecutionBlock { () -> Void in
             
                let imageData = NSData(contentsOfURL: NSURL(string: urlArray[i])!)
                if (imageData == nil){
                    return
                }
                
                //获取image
                let image = UIImage(data: imageData!)
                
                dispatch_async(dispatch_get_main_queue(), {
                    let uiimageview = self.view.viewWithTag(i+10) as! UIImageView
                    uiimageview.image = image
                })
            }
        }

        queue.addOperation(operation)
        
        for index in 1...5 {
            imageArray.append(UIImage.init(named: "\(index)")!)
            descArray.append("这是第\(index)")
        }
        
        contentView.initDataSource(imageArray,descsValue: descArray)
        
    }
    
    func updateImageView(image:UIImage) {
        print("image ======= \(image)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
