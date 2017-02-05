//
//  EkoImage.swift
//  DBFM
//
//  Created by 包笛 on 2017/2/4.
//  Copyright © 2017年 包笛. All rights reserved.
//

import UIKit

class EkoImage: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)!
        
        //设置圆角
        self.clipsToBounds=true
        self.layer.cornerRadius=self.frame.size.width/2
        
        //描边
        self.layer.borderWidth=4
        self.layer.borderColor=UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.7).cgColor
    }
    
    func onRoatation(){
        let animation=CABasicAnimation(keyPath: "transform.rotation")
        
        animation.fromValue=0
        animation.toValue=M_PI*2
        animation.duration=20
        animation.repeatCount=MAXFLOAT
        self.layer.add(animation, forKey: nil)
    }

}
