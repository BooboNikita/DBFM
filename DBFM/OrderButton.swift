//
//  OrderButton.swift
//  DBFM
//
//  Created by 包笛 on 2017/2/5.
//  Copyright © 2017年 包笛. All rights reserved.
//

import UIKit

class OrderButton: UIButton {

    var order=1
    
    let order1=UIImage(named: "rank")
    let order2=UIImage(named: "random")
    let order3=UIImage(named: "single")
    
    required init(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)!
        self.addTarget(self, action: #selector(OrderButton.onClick), for: .touchUpInside)
    }
    func onClick(){
        order += 1
        if order==1{
            self.setImage(order1, for: .normal)
        }
        else if order==2{
            self.setImage(order2, for: .normal)
        }
        else if order==3{
            self.setImage(order3, for: .normal)
        }
        else if order>3{
            order=1
            setImage(order1, for: .normal)
        }
    }

}
