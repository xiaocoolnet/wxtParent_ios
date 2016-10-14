//
//  ScollViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/30.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class ScollViewController: UIViewController{

    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var startButton: UIButton!
    
    private var scrollView: UIScrollView!
    
    private let numOfPages = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = self.view.bounds
        startButton.layer.borderWidth = 2.0
        startButton.layer.borderColor = UIColor(red: 54.0 / 255.0, green: 190.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0).CGColor
        scrollView = UIScrollView(frame: frame)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.contentOffset = CGPointZero
        // 将 scrollView 的 contentSize 设为屏幕宽度的3倍(根据实际情况改变)
        scrollView.contentSize = CGSize(width: frame.size.width * CGFloat(numOfPages), height: frame.size.height)
        
        scrollView.delegate = self
        
        for index  in 0..<numOfPages {
            let imageView = UIImageView(image: UIImage(named: "引导页模板-\(index + 1)"))
            imageView.frame = CGRect(x: frame.size.width * CGFloat(index), y: 0, width: frame.size.width, height: frame.size.height)
            scrollView.addSubview(imageView)
        }
        
        self.view.insertSubview(scrollView, atIndex: 0)
        
        // 给开始按钮设置圆角
        startButton.layer.cornerRadius = 5.0
        startButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        // 隐藏开始按钮
        startButton.alpha = 0.0
    }
    
    // 隐藏状态栏
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}

extension ScollViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        // 随着滑动改变pageControl的状态
        pageControl.currentPage = Int(offset.x / view.bounds.width)
        
        // 因为currentPage是从0开始，所以numOfPages减1
        if pageControl.currentPage == numOfPages - 1 {
            UIView.animateWithDuration(0.5) {
                self.startButton.alpha = 1.0
            }
        } else {
            UIView.animateWithDuration(0.2) {
                self.startButton.alpha = 0.0
            }
        }
    }
}
