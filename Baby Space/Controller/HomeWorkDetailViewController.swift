//
//  HomeWorkDetailViewController.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/25.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class HomeWorkDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    var img = NSString()
    var nu = 0
    var count = 0
    var collectV:UICollectionView?
    var flowLayout = UICollectionViewFlowLayout()
    
    var arrayInfo = Array<PiInfo>()
    var dataSouce = Array<NewsIn>()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
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
        collectV!.contentOffset = CGPointMake(CGFloat(nu)*WIDTH, 0)

        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
//        return self.arrayInfo.
        return nu
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! HomeWorkDetailCollectionViewCell
        cell.imgView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        cell.imgView.contentMode = .ScaleAspectFit
        cell.clipsToBounds = true
        let str = arrayInfo[indexPath.item].picture_url
        let imgUrl = microblogImageUrl + str
        let photourl = NSURL(string: imgUrl)
        cell.imgView.sd_setImageWithURL(photourl, placeholderImage: (UIImage(named: "无网络的背景.png")))
        cell.contentView.addSubview(cell.imgView)
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
