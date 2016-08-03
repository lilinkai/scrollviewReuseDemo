//
//  ReuseScrollView.swift
//  scrollviewReuseDemo
//
//  Created by 李林凯 on 16/8/3.
//  Copyright © 2016年 7k7k. All rights reserved.
//

import UIKit

class ReuseScrollView: UIView, UIScrollViewDelegate {
    
    private var contentScrollView:UIScrollView! = nil //滚动容器
    private var imagesArray:[AnyObject]! = nil
    private var currentImageView:UIImageView! = nil //当前显示imageview
    private var nextImageView:UIImageView! = nil    //下一个显示的imageview
    
    private var currentIndex:Int = 0    //当前显示索引
    private var nextIndex:Int = 1       //下一个索引
    
    override func awakeFromNib() {
        print("加载xib")
        initSubView()
    }
    
    internal func initDataSource(imagesValue:[AnyObject]){
        imagesArray = imagesValue
        
        contentScrollView.contentSize = CGSize.init(width: width*CGFloat(imagesArray.count), height: height)
        contentScrollView.contentOffset = CGPoint.init(x: width, y: 0)
        
        currentImageView.setLeft(width)
        nextImageView.setLeft(0)
        
        currentImageView.image = imagesArray[currentIndex] as? UIImage
        nextImageView.image = imagesArray[nextIndex] as? UIImage
    }
    
    /**
     加载需要的控件
     */
    private func initSubView() {
        initContentScrollView()
        initCurrentImageView()
        initNextImageView()
    }
    
    /**
     初始化scrollview
     */
    private func initContentScrollView() {
        contentScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        contentScrollView.clipsToBounds = true
        contentScrollView.pagingEnabled = true
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.delegate = self
        contentScrollView.backgroundColor = UIColor.redColor()
        self.addSubview(contentScrollView)
    }
    
    /**
     初始化始终显示的imageview
     */
    private func initCurrentImageView() {
        currentImageView = UIImageView.init(frame: contentScrollView.frame)
        currentImageView.backgroundColor = UIColor.blueColor()
        contentScrollView.addSubview(currentImageView!)
    }
    
    /**
     初始化下一个显示的imageview
     */
    private func initNextImageView() {
        nextImageView = UIImageView.init(frame: contentScrollView.frame)
        nextImageView.backgroundColor = UIColor.blackColor()
        contentScrollView.addSubview(nextImageView!)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        
        let offSet = scrollView.contentOffset.x
        
        /**
         *  判断滚动方向
         */
        //向右滚动了
        if offSet < width {
            //移动nextimageview位置
            nextImageView.setLeft(0)
            //确定下一个索引
            nextIndex = currentIndex - 1
            if nextIndex < 0 {
                nextIndex = imagesArray.count - 1
            }
            nextImageView.image = imagesArray[nextIndex] as? UIImage
            
            if offSet <= 0 {
                changeNextImageView()
            }
        }
        //向左滚动了
        else if offSet > width{
            nextImageView.setLeft(width*2)
            nextIndex = (currentIndex + 1)%imagesArray.count
            nextImageView.image = imagesArray[nextIndex] as? UIImage
            
            if offSet >= width*2 {
                changeNextImageView()
            }
        }
    }
    
    /**
     最终交换显示与下一个显示图片，并复位到scrollView初始值
     */
    func changeNextImageView() {
        currentImageView.image = nextImageView.image
        contentScrollView.contentOffset = CGPoint.init(x: width, y: 0)
        currentIndex = nextIndex
    }

}
