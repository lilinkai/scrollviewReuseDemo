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
    private var descsArray:[String]! = nil
    
    private var currentImageView:UIImageView! = nil //当前显示imageview
    private var nextImageView:UIImageView! = nil    //下一个显示的imageview
    
    private var descContentLabel:UILabel! = nil //描述的控件
    
    private var pageControl:UIPageControl! = nil    //页码控件
    
    private var currentIndex:Int = 0    //当前显示索引
    private var nextIndex:Int = 1       //下一个索引
    
    override func awakeFromNib() {
        print("加载xib")
        initSubView()
    }
    
    struct styleConfig {
        
        
    }
    
    internal func initDataSource(imagesValue:[AnyObject], descsValue:[String]){
        imagesArray = imagesValue
        descsArray = descsValue
        
        if imagesArray.count != descsArray.count {
            print("图片数量与描述数量不匹配!")
            return
        }
        
        contentScrollView.contentSize = CGSize.init(width: width*CGFloat(imagesArray.count), height: height)
        contentScrollView.contentOffset = CGPoint.init(x: width, y: 0)
        
        currentImageView.setLeft(width)
        nextImageView.setLeft(0)
        
        currentImageView.image = imagesArray[currentIndex] as? UIImage
        nextImageView.image = imagesArray[nextIndex] as? UIImage
        
        descContentLabel.text = descsArray[currentIndex]
        
        pageControl.numberOfPages = imagesArray.count
    }
    
    /**
     加载需要的控件
     */
    private func initSubView() {
        initContentScrollView()
        initCurrentImageView()
        initNextImageView()
        initPageControl()
        initDescribeLabel()
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
        self.addSubview(contentScrollView)
    }
    
    /**
     初始化始终显示的imageview
     */
    private func initCurrentImageView() {
        currentImageView = UIImageView.init(frame: contentScrollView.frame)
        contentScrollView.addSubview(currentImageView!)
    }
    
    /**
     初始化下一个显示的imageview
     */
    private func initNextImageView() {
        nextImageView = UIImageView.init(frame: contentScrollView.frame)
        contentScrollView.addSubview(nextImageView!)
    }
    
    /**
     初始化分页显示控件
     */
    private func initPageControl(){
        pageControl = UIPageControl.init(frame: CGRect.init(x: 0, y: self.height-20, width: width, height: 20))
        pageControl.pageIndicatorTintColor = UIColor.grayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blueColor()
        self.addSubview(pageControl)
    }
    
    /**
     初始化内容描述显示控件
     */
    private func initDescribeLabel(){
        descContentLabel = UILabel.init(frame: CGRect.init(x: 0, y: pageControl.top-10, width: width, height: 20))
        descContentLabel.font = UIFont.systemFontOfSize(15.0)
        descContentLabel.text = "暂无描述"
        descContentLabel.textColor = UIColor.redColor()
        descContentLabel.textAlignment = .Center
        self.addSubview(descContentLabel)
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
        pageControl.currentPage = currentIndex
        descContentLabel.text = descsArray[currentIndex]
    }

}
