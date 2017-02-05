//
//  ChannelController.swift
//  DBFM
//
//  Created by 包笛 on 2017/2/4.
//  Copyright © 2017年 包笛. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ChannelProtocol {
    func onChangeChannel(channel_id:String)
}

class ChannelController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tv: UITableView!
    @IBAction func onClickReturn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var delegate:ChannelProtocol?
    
    var channelData:[JSON]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha=0.8
        // Do any additional setup after loading the view.
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelData.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform=CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.25) {
            cell.layer.transform=CATransform3DMakeScale(1, 1, 1)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tv.dequeueReusableCell(withIdentifier: "db")
        
        let rowData:JSON=self.channelData[indexPath.row]
        cell?.textLabel?.text=rowData["name"].string
//        cell?.textLabel?.text="标题： \(indexPath.row)"
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowData=self.channelData[indexPath.row]
        let channel_id=rowData["channel_id"].stringValue
        delegate?.onChangeChannel(channel_id: channel_id)
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
