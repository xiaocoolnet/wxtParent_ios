//
//  HomeworkTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/4/27.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class HomeworkTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {


    var titleLbl = UIButton()
    
    var contentLbl = UILabel()
    
    var imgLable = UILabel()
    
    var btn = UIButton()
    
    
    
    
    var collectionView : UICollectionView?
    
    var layout = UICollectionViewFlowLayout()

    
    var senderLbl = UILabel()
    
    var timeLbl = UILabel()
    
    var readLabel = UILabel()
    
    var str = NSString()
    var num = 1
    var vc = UINavigationController()
    
    var qu = Array<PiInfo>()
    
    
//    
//    func setShow(model:NewsIn){
//        
//        qu = model.pictur
//        num = model.pictur.count
//        print(model.pictur)
//    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        //  标题
//        titleLbl.frame = CGRectMake(WIDTH / 2 - 40, 10, 80, 30)
//        titleLbl.text = "周一家庭作业"
        
        contentView.addSubview(titleLbl)
        //  已读
//        readLabel.frame = CGRectMake(WIDTH - 60, 10, 40, 30)
        readLabel.text = "已读"
        readLabel.font = UIFont.systemFontOfSize(14)
        readLabel.textColor = UIColor.lightGrayColor()
        contentView.addSubview(readLabel)
        //  内容
//        contentLbl.frame = CGRectMake(10, 50, WIDTH - 20, 90)
        contentLbl.textColor = UIColor.lightGrayColor()
        contentLbl.numberOfLines = 0
        contentLbl.text = "口算：完成口算：完成口算：完成口算：完成口算：完成口算：完成口算：完成口算：完成口算：完成口算：完成口算：完成口算：完成口算：完成口算：完成口算：完成口算：完成"
        contentLbl.font = UIFont.boldSystemFontOfSize(14)
        contentView.addSubview(contentLbl)
        
        //  添加collectionView(填充照片)
        //  一张照片(自定义一个高度)
        
        //  两张到六张照片
        //  七张到九张照片
//        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRectMake(10, 150, WIDTH - 20, 240),collectionViewLayout:layout)
        collectionView!.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
//        contentView.addSubview(collectionView!)
        
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.itemSize = CGSizeMake((WIDTH - 50) / 3, (WIDTH - 50) / 3)
        //        注册
        self.collectionView?.registerClass(QCHomeWorkItem.self, forCellWithReuseIdentifier: "cell")
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self


        
        
//        imgLable.frame = CGRectMake(10, 150, WIDTH - 20, 240)
        
        
        //  老师
        let imageView = UIImageView()
        imageView.frame = CGRectMake(10, 400, 21, 21)
        imageView.image = UIImage.init(named: "ic_fasong")
//        contentView.addSubview(imageView)
        
//        senderLbl.frame = CGRectMake(35, 400, 100, 21)
        senderLbl.text = "王一老师"
        senderLbl.font = UIFont.systemFontOfSize(14)
        contentView.addSubview(senderLbl)
        
//        timeLbl.frame = CGRectMake(WIDTH - 130, 400, 120, 21)
        timeLbl.text = "04-23 16:30"
        timeLbl.textColor = UIColor.lightGrayColor()
        timeLbl.font = UIFont.systemFontOfSize(14)
        contentView.addSubview(timeLbl)
        
        btn.backgroundColor = UIColor.blackColor()
//        contentView.addSubview(btn)
        
        
    }
    
    
    
//    func send(vc:UINavigationController){
//        self.vc = vc
//    }
//    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(num)
        return num
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? QCHomeWorkItem
//        str = qu[indexPath.item].picture_url
//        
//        let imgUrl = microblogImageUrl + (str as String)
//        let photourl = NSURL(string: imgUrl)
//        item?.itemImageView.sd_setImageWithURL(photourl, placeholderImage: (UIImage(named: "无网络的背景.png")))
        return item!
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        let Home = HomeWorkDetailViewController()
//        Home.arrayInfo = qu
//        Home.count = num
//        Home.nu = indexPath.item
//        vc.pushViewController(Home, animated: true)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
