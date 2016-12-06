//
//  ReuseScrollView.swift
//  scrollviewReuseDemo
//
//  Created by 李林凯 on 16/10/27.
//  Copyright © 2016年 7k7k. All rights reserved.
//

//两张imageview的scrollview重用

import UIKit

class ReuseScrollView: UIView, UIScrollViewDelegate {
    
     var contentScrollView:UIScrollView! = nil //滚动容器
    
     var imagesUrlArray:[String]! = nil
     var imagesArray:[UIImage]! = nil
     var descsArray:[String]! = nil
    
     var currentImageView:UIImageView! = nil //当前显示imageview
     var nextImageView:UIImageView! = nil    //下一个显示的imageview
    
     var descContentLabel:UILabel! = nil //描述的控件
    
     var pageControl:UIPageControl! = nil    //页码控件
    
     var currentIndex:Int = 0    //当前显示索引
     var nextIndex:Int = 1       //下一个索引
    
     var fileName = ""
    
     var timer:Timer? = nil
    
    var selectIndex:( (_ index:Int) -> Void )?
    
    override func awakeFromNib() {
        print("加载xib")
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    struct styleConfig {
        
        
    }
    
    /**
     设置定时器
     */
    func setUpTime() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(automaticChangePage), userInfo: nil, repeats: true)
    }
    
    /**
     释放定时器
     */
    func pauseTime(){
        timer?.invalidate()
        timer = nil
    }
    
    /**
     自动换页
     */
    func automaticChangePage() {
        contentScrollView.setContentOffset(CGPoint(x: width*2, y: 0), animated: true)
    }
    
    /**
     加载需要的控件
     */
    fileprivate func initSubView() {
        initContentScrollView()
        initCurrentImageView()
        initNextImageView()
        initPageControl()
        initDescribeLabel()
    }
    
    /**
     初始化scrollview
     */
    fileprivate func initContentScrollView() {
        contentScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        contentScrollView.clipsToBounds = true
        contentScrollView.isPagingEnabled = true
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.delegate = self
        self.addSubview(contentScrollView)
    }
    
    /**
     初始化始终显示的imageview
     */
    fileprivate func initCurrentImageView() {
        currentImageView = UIImageView.init(frame: contentScrollView.frame)
        currentImageView.contentMode = .scaleAspectFill
        contentScrollView.addSubview(currentImageView!)
        currentImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapCurrentImage))
        currentImageView.addGestureRecognizer(tapGesture)
    }
    
    /**
     点击当前显示的图片
     */
    func tapCurrentImage() {
        print("点击了当前显示的图片")
        selectIndex?(currentIndex)
    }
    
    /**
     初始化下一个显示的imageview
     */
    fileprivate func initNextImageView() {
        nextImageView = UIImageView.init(frame: contentScrollView.frame)
        nextImageView.contentMode = .scaleAspectFill
        contentScrollView.addSubview(nextImageView!)
    }
    
    /**
     初始化分页显示控件
     */
    func initPageControl(){
        pageControl = UIPageControl.init(frame: CGRect.init(x: 0, y: self.height-20, width: width, height: 20))
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = UIColor.init(colorLiteralRed: 255.0/255, green: 38.0/255, blue: 63.0/255, alpha: 1)
        self.addSubview(pageControl)
    }
    
    /**
     初始化内容描述显示控件
     */
    fileprivate func initDescribeLabel(){
        descContentLabel = UILabel.init(frame: CGRect.init(x: 0, y: pageControl.top-10, width: width, height: 20))
        descContentLabel.font = UIFont.systemFont(ofSize: 15.0)
        descContentLabel.text = "暂无描述"
        descContentLabel.textColor = UIColor.red
        descContentLabel.textAlignment = .center
        descContentLabel.isHidden = true
        self.addSubview(descContentLabel)
    }
    
    internal func initDataSource(_ imagesValue:[String], descsValue:[String]){
        
        initSubView()
        
        imagesUrlArray = imagesValue
        
        descsArray = descsValue
        
        if imagesUrlArray.count != descsArray.count {
            print("图片数量与描述数量不匹配!")
            return
        }
        
        downImageData()
        
        addPlaceholderImage()
        
        contentScrollView.contentSize = CGSize.init(width: width*CGFloat(imagesUrlArray.count), height: height)
        contentScrollView.contentOffset = CGPoint.init(x: width, y: 0)
        
        currentImageView.setLeft(width)
        nextImageView.setLeft(0)
        
        currentIndex = 0

        descContentLabel.text = descsArray[currentIndex]
        
        pageControl.numberOfPages = imagesUrlArray.count
        
        pauseTime()
        
        setUpTime()
    }
    
    /**
     添加占位图
     */
    func addPlaceholderImage(){
        imagesArray = [UIImage]()
        for _ in 0..<imagesUrlArray.count {
            imagesArray.append(UIImage.init(named: "占位图")!)
        }
        
        currentImageView.image = imagesArray[0]
        nextImageView.image = imagesArray[0]
    }
    
    /**
     下载图片方法
     */
    func downImageData(){
        
        let globQueue = DispatchQueue.global()
        
        for (index,imgUrlStr) in imagesUrlArray.enumerated(){
            
            globQueue.async { [weak self] in
                
                let imgUrl = URL(string: imgUrlStr)
                
                if let imgurlObj = imgUrl{
                    
                    let imgData = try? Data.init(contentsOf: imgurlObj)
                    
                    if let imgDataObj = imgData{
                        
                        let imgDataObj = UIImage.init(data: imgDataObj)
                        
                        self?.imagesArray[index] = imgDataObj!
                        
                        DispatchQueue.main.async {
                            
                            for (index,imageview) in (self?.contentScrollView.subviews.enumerated())!{
                                if index < (self?.imagesUrlArray.count)!{
                                    let imageviewObj = imageview as! UIImageView
                                    imageviewObj.image = self?.imagesArray[index]
                                }
                            }
                            
                        }
                        
                    }
                    
                }
            }
            
        }
    }
 
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        pauseTime()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        setUpTime()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
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
                nextIndex = imagesUrlArray.count - 1
            }
            nextImageView.image = imagesArray[nextIndex]
            
            if offSet <= 0 {
                changeNextImageView()
            }
        }
            
        //向左滚动了
        else if offSet > width{
            nextImageView.setLeft(width*2)
            nextIndex = (currentIndex + 1)%imagesUrlArray.count
            nextImageView.image = imagesArray[nextIndex]
            
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
