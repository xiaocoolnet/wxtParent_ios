//
//  MyPhotoViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/2/18.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class MyPhotoViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    
    var photoCollection : UICollectionView!
    var flowLayout = UICollectionViewFlowLayout()
    override func viewDidLoad() {
        super.viewDidLoad()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        print(UIScreen.mainScreen().bounds.width)
        flowLayout.itemSize = CGSizeMake((UIScreen.mainScreen().bounds.width-20)/2,150)
        photoCollection = UICollectionView(frame: CGRectMake(15, 10, UIScreen.mainScreen().bounds.width-30, 667), collectionViewLayout: flowLayout)
        photoCollection!.delegate = self
        photoCollection!.dataSource = self
        photoCollection!.alwaysBounceVertical = true
        photoCollection!.backgroundColor = UIColor.whiteColor()
        photoCollection.contentSize = CGSizeMake(100, 100)
        photoCollection!.registerClass(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
        self.view.addSubview(photoCollection!)

        // Do any additional setup after loading the view.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:PhotoCollectionViewCell  = photoCollection!.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        cell.photo.frame = CGRectMake(0,0,(UIScreen.mainScreen().bounds.width-100)/2,(UIScreen.mainScreen().bounds.width-100)/2)
        cell.photo.image = UIImage(named: "Logo")
        cell.contentView.addSubview(cell.photo)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake((UIScreen.mainScreen().bounds.width-100)/2, (UIScreen.mainScreen().bounds.width-100)/2)
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
