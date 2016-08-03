//
//  ViewController.swift
//  scrollviewReuseDemo
//
//  Created by 李林凯 on 16/8/3.
//  Copyright © 2016年 7k7k. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var contentScrollView: UIScrollView!
    
    var imageArray = [UIImage]()    //资源照片
    
    var currentImageView:UIImageView? = nil    //当前显示imageview
    var nextImageView:UIImageView? = nil    //下一个显示的imageview
    
    var currentIndex:Int = 0    //当前选中的索引
    var nextIndex:Int = 1   //下一个将要显示
    
    enum scrollViewDirection {
        case scrollLeft
        case scrollRight
        case scrollNone
    }   //滚动方向
    
    var scrollDirection:scrollViewDirection = scrollViewDirection.scrollNone
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 1...5 {
            imageArray.append(UIImage.init(named: "\(index)")!)
        }
        
        contentScrollView.contentSize = CGSize.init(width:contentScrollView.width*CGFloat(imageArray.count), height: contentScrollView.height)
        contentScrollView.contentOffset = CGPoint.init(x: contentScrollView.width, y: 0)
        
        currentImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: contentScrollView.width, height: contentScrollView.height))
        currentImageView?.image = imageArray[currentIndex]
        currentImageView?.setLeft(contentScrollView.width)
        contentScrollView.addSubview(currentImageView!)
        
        nextImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: contentScrollView.width, height: contentScrollView.height))
        nextImageView?.image = imageArray[nextIndex]
        nextImageView?.setLeft(0)
        contentScrollView.addSubview(nextImageView!)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        //1.判断滚动方向
        let offSet = scrollView.contentOffset.x
        
        scrollDirection =  offSet < scrollView.width ? .scrollRight : offSet > scrollView.width ? .scrollLeft : .scrollNone
        
        /**
         *  向右滚动
         */
        if scrollDirection == .scrollRight {
            
            nextImageView?.setLeft(0)
            
            nextIndex = currentIndex - 1
            
            if nextIndex < 0 {
                nextIndex = imageArray.count - 1
            }
            nextImageView?.image = imageArray[nextIndex]
            
            if offSet <= 0 {
                changeNextPage()
            }
        }
        /**
         *  向左滚动
         */
        else if scrollDirection == .scrollLeft{
        
            nextImageView?.setLeft(self.contentScrollView.width*2)
            
            nextIndex = (currentIndex + 1)%(imageArray.count)
            
            nextImageView?.image = imageArray[nextIndex]
            
            if offSet >= scrollView.width*2 {
                changeNextPage()
            }
        }
        
    }
    
    func changeNextPage() {
        scrollDirection = .scrollNone
        currentImageView?.image = nextImageView?.image
        contentScrollView.contentOffset = CGPoint.init(x: contentScrollView.width, y: 0)
        currentIndex = nextIndex
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
