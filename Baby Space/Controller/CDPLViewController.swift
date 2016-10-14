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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! HomeWorkDetailCollectionViewCell
        cell.imgView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        cell.imgView.contentMode = .ScaleAspectFit
        cell.clipsToBounds = true
        let pciInfo = self.dataSource[indexPath.item]
        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
        let photourl = NSURL(string: imgUrl)
        cell.imgView.sd_setImageWithURL(photourl, placeholderImage: (UIImage(named: "图片默认加载")))
        cell.contentView.addSubview(cell.imgView)
        return cell
    }

}
