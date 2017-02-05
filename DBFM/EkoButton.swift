//
//  EkoButton.swift
//  DBFM
//
//  Created by 包笛 on 2017/2/5.
//  Copyright © 2017年 包笛. All rights reserved.
//

import UIKit

class EkoButton: UIButton {

    var isPlay=true
    let imgPlay=UIImage(named: "play")
    let imgPause=UIImage(named: "pause")
    
    
    required init(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)!
        self.addTarget(self, action: #selector(EkoButton.onClick), for: .touchUpInside)
    }
    func onClick(){
        isPlay = !isPlay
        if isPlay{
            self.setImage(imgPause, for: .normal)
        }
        else{
            self.setImage(imgPlay, for: .normal)
        }
    }
    func onPlay(){
        isPlay=true
        self.setImage(imgPause, for: .normal)
        
    }
}
