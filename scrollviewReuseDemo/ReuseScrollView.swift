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
    
    private var imagesUrlArray:[String]! = nil
    private var imagesArray:[UIImage]! = nil
    private var descsArray:[String]! = nil
    
    private var currentImageView:UIImageView! = nil //当前显示imageview
    private var nextImageView:UIImageView! = nil    //下一个显示的imageview
    
    private var descContentLabel:UILabel! = nil //描述的控件
    
    private var pageControl:UIPageControl! = nil    //页码控件
    
    private var currentIndex:Int = 0    //当前显示索引
    private var nextIndex:Int = 1       //下一个索引
    
    var queue:NSOperationQueue! = nil;  //图片加载队列
    
    var fileName = ""
    
    
    override func awakeFromNib() {
        print("加载xib")
        initSubView()
    }
    
    struct styleConfig {
        
        
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
        initQueue()
        createSaveImageFile()
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
        currentImageView.contentMode = .ScaleAspectFill
        contentScrollView.addSubview(currentImageView!)
    }
    
    /**
     初始化下一个显示的imageview
     */
    private func initNextImageView() {
        nextImageView = UIImageView.init(frame: contentScrollView.frame)
        nextImageView.contentMode = .ScaleAspectFill
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
    
    /**
     初始化下载队列
     */
    private func initQueue(){
        queue = NSOperationQueue()
    }
    
    internal func initDataSource(imagesValue:[String], descsValue:[String]){
        
        imagesUrlArray = imagesValue
        
        descsArray = descsValue
        
        if imagesUrlArray.count != descsArray.count {
            print("图片数量与描述数量不匹配!")
            return
        }
        
        addPlaceholderImage()
        
        downImageData()
        
        contentScrollView.contentSize = CGSize.init(width: width*CGFloat(imagesUrlArray.count), height: height)
        contentScrollView.contentOffset = CGPoint.init(x: width, y: 0)
        
        currentImageView.setLeft(width)
        nextImageView.setLeft(0)

        descContentLabel.text = descsArray[currentIndex]
        
        pageControl.numberOfPages = imagesUrlArray.count
    }
    
    /**
     添加占位图
     */
    private func addPlaceholderImage(){
        
        imagesArray = [UIImage]()
        for _ in 0..<imagesUrlArray.count {
            imagesArray.append(UIImage.init(named: "1111")!)
        }
        
        currentImageView.image = imagesArray[0]
        nextImageView.image = imagesArray[0]
    }
    
    /**
     创建存放图片文件的沙盒文件夹
     */
    private func createSaveImageFile(){
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let cacheDirectory = paths[0]
        fileName = "\(cacheDirectory)/LLK"
       
       // 创建文件管理器
       let fileManager :NSFileManager = NSFileManager.defaultManager()
        
        do {
            try fileManager.createDirectoryAtPath(fileName, withIntermediateDirectories: true, attributes: nil)
            print("创建成功")
        } catch let error as NSError {
            // 发生了错误
            print(error.localizedDescription)
        }
    }
    
    /**
     下载图片方法
     */
    private func downImageData(){
        
        let operation = NSBlockOperation()
        
        for index in 0..<imagesUrlArray.count {
            operation.addExecutionBlock({ [weak self] in
                
                let fileNamePath = self!.fileName.stringByAppendingString("/\(index)")
               
                let localImageFile = NSData.init(contentsOfFile: fileNamePath)
               
                if localImageFile != nil{
                    let image = UIImage.init(data: localImageFile!)
                    self?.imagesArray[index] = image!
                    if self!.currentIndex == index{
                        self?.currentImageView.image = image!
                    }
                }else{
                    let imageData = NSData.init(contentsOfURL: NSURL.init(string: self!.imagesUrlArray[index])!)
                    if imageData == nil{
                        print("图片数据为空")
                        return
                    }
                    let image = UIImage.init(data: imageData!)
                    imageData?.writeToFile(fileNamePath, atomically: true)
                    self?.imagesArray[index] = image!
                    dispatch_async(dispatch_get_main_queue(), {
                        if self!.currentIndex == index{
                            self?.currentImageView.image = image!
                        }
                    })
                }
            })
        }
        
        queue.addOperation(operation)
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
