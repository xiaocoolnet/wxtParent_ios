//
//  CDPLViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/31.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class CDPLViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    var id:String?
    var dataSource = Array<coursewarePicInfo>()
    
    var collectV:UICollectionView?
    var flowLayout = UICollectionViewFlowLayout()
    var count = NSInteger()
    var lastScaleFactor : CGFloat! = 1  //放大、缩小
    var imgView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "图片"
        
        self.view.backgroundColor = UIColor.blackColor()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.itemSize = CGSizeMake(WIDTH, HEIGHT)
        flowLayout.minimumLineSpacing = 0;
        self.collectV = UICollectionView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, HEIGHT), collectionViewLayout: flowLayout)
        //        注册
        self.collectV?.registerClass(HomeWorkDetailCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        self.collectV?.delegate = self
        self.collectV?.dataSource = self
        self.collectV?.backgroundColor = UIColor.clearColor()
        self.collectV!.pagingEnabled = true
        
        //设置每一个cell的宽高
        //        layout.itemSize = CGSizeMake(WIDTH, HEIGHT)
        self.view.addSubview(collectV!)
        //        collectV!.contentOffset = CGPointMake(CGFloat(nu)*WIDTH, 0)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        collectV!.contentOffset = CGPointMake(CGFloat(count - 1)*WIDTH, 0)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        imgView = UIImageView()
        imgView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        imgView.contentMode = .ScaleAspectFit
        cell.clipsToBounds = true
        let pciInfo = self.dataSource[indexPath.item]
        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
        let photourl = NSURL(string: imgUrl)
        imgView.sd_setImageWithURL(photourl, placeholderImage: (UIImage(named: "图片默认加载")))
        cell.contentView.addSubview(imgView)
        //手势为捏的姿势:按住option按钮配合鼠标来做这个动作在虚拟器上
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinchGesture))
        imgView.addGestureRecognizer(pinchGesture)
        
        //1.双击手势
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.clickDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        imgView.addGestureRecognizer(doubleTap);
        
        imgView.userInteractionEnabled = true
        
        return cell
    }
    
    
    //实现手势方法  双击手势
    func clickDoubleTap(sender: UITapGestureRecognizer)
    {
        if imgView.contentMode == UIViewContentMode.ScaleAspectFit{
            //把imageView模式改成UIViewContentModeCenter，按照图片原先的大小显示中心的一部分在imageView
            imgView.contentMode = UIViewContentMode.Center
        }else{
            imgView.contentMode = UIViewContentMode.ScaleAspectFit
        }
    }
    
    //捏的手势，使图片放大和缩小，捏的动作是一个连续的动作
    func handlePinchGesture(sender: UIPinchGestureRecognizer){
        let factor = sender.scale
        if factor > 1{
            //图片放大
            imgView.transform = CGAffineTransformMakeScale(lastScaleFactor+factor-1, lastScaleFactor+factor-1)
        }else{
            //缩小
            imgView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor)
        }
        //状态是否结束，如果结束保存数据
        if sender.state == UIGestureRecognizerState.Ended{
            if factor > 1{
                lastScaleFactor = lastScaleFactor + factor - 1
            }else{
                lastScaleFactor = lastScaleFactor * factor
            }
        }
    }
}
