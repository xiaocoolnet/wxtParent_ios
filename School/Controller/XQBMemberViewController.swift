//
//  XQBMemberViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/2.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class XQBMemberViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    var colltionView : UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "成员"
        self.createCollectionView()
    }
//    创建流视图
    func createCollectionView(){
        let layout = UICollectionViewFlowLayout()
        colltionView = UICollectionView(frame: CGRectMake(0, 0,WIDTH, HEIGHT-64), collectionViewLayout: layout)
        //        注册一个cell
        colltionView?.registerClass(MemberCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        colltionView?.delegate = self
        colltionView?.dataSource = self
        colltionView?.backgroundColor = UIColor.whiteColor()
        //        设置每一个cell的高度
        layout.itemSize = CGSizeMake((WIDTH-125)/5, (WIDTH-125)/5+30)
        self.view.addSubview(colltionView!)
    }
    //返回多少个组
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    //    返回多少个cell
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    //    返回自定义的cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MemberCollectionViewCell
        
        return cell
    }
    
    //    返回cell上下左右的间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(5, 25, 5, 25)
    }
    
}
