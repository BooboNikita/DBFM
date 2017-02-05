//
//  ViewController.swift
//  DBFM
//
//  Created by 包笛 on 2017/2/4.
//  Copyright © 2017年 包笛. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MediaPlayer

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,HttpProtocol,ChannelProtocol {

    @IBOutlet var bg: UIImageView!
    @IBOutlet var iv: EkoImage!
    @IBOutlet var progress: UIImageView!
    @IBOutlet var tv: UITableView!
    @IBOutlet var playTime: UILabel!
    
    var eHttp:HttpController=HttpController()
    var tableData:[JSON]=[]
    var channelData:[JSON]=[]
    @IBOutlet var btnPre: UIButton!
    @IBOutlet var btnPlay: EkoButton!
    @IBOutlet var btnNext: UIButton!
    var imageCache=Dictionary<String,UIImage>()
    var audioPlayer:MPMoviePlayerController=MPMoviePlayerController()
    var timer:Timer?
    var curIndex=0
    var isAutoFinish = true
    @IBOutlet var btnOrder:OrderButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        iv.onRoatation()
        
        //背景模糊
        let blurEffect=UIBlurEffect(style: .light)
        let blurView=UIVisualEffectView(effect: blurEffect)
        blurView.frame.size=CGSize(width: view.frame.width, height: view.frame.height)
        bg.addSubview(blurView)
        
        tv.dataSource=self
        tv.delegate=self
        // Do any additional setup after loading the view, typically from a nib.
        eHttp.delegate=self
        eHttp.onSearch(url: "https://www.douban.com/j/app/radio/channels")
        eHttp.onSearch(url: "https://douban.fm/j/mine/playlist?type=n&channel=3&from=mainsite")
        
        tv.backgroundColor=UIColor.clear
        
        btnPlay.addTarget(self, action: #selector(onPlay(btn:)), for: .touchUpInside)
        btnNext.addTarget(self, action: #selector(onClick(btn:)), for: .touchUpInside)
        btnPre.addTarget(self, action: #selector(onClick(btn:)), for: .touchUpInside)
        btnOrder.addTarget(self, action: #selector(onOrder(btn:)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector:#selector(ViewController.playFinish), name: .MPMoviePlayerPlaybackDidFinish, object: audioPlayer)
    }
    
    func playFinish(){
        if isAutoFinish{
            switch btnOrder.order {
            case 1:
                curIndex += 1
                if curIndex>tableData.count-1{
                    curIndex=0
                }
                onSelectedRow(index: curIndex)
            case 2:
                curIndex = Int(arc4random()) % tableData.count
                onSelectedRow(index: curIndex)
            case 3:
                onSelectedRow(index: curIndex)
            default:
                onSelectedRow(index: curIndex)
            }

        }
        else{
            isAutoFinish=true
        }
        
    }
    func onPlay(btn:EkoButton){
        if btn.isPlay{
            audioPlayer.play()
        }
        else{
            audioPlayer.pause()
        }
    }
    func onClick(btn:UIButton){
        isAutoFinish=false
        if btn==btnNext{
            curIndex += 1
            if curIndex>self.tableData.count-1{
                curIndex=0
            }
        }
        else{
            curIndex -= 1
            if curIndex<0{
                curIndex=self.tableData.count-1
            }
        }
        onSelectedRow(index: curIndex)
    }
    func onOrder(btn:OrderButton){
        var message=""
        switch btn.order {
        case 1:
            message="顺序播放"
        case 2:
            message="随机播放"
        case 3:
            message="单曲循环"
        default:
            message="haha"
        }
        self.view.makeToast(message: message, duration: 0.5, position: "center" as AnyObject)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count:\(tableData.count)")
        return tableData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tv.dequeueReusableCell(withIdentifier: "douban")
        cell?.backgroundColor=UIColor.clear
        let rowData:JSON=tableData[indexPath.row]
        cell?.textLabel?.text=rowData["title"].string
        cell?.detailTextLabel?.text=rowData["artist"].string
//        Alamofire.request(rowData["picture"].stringValue).response { (data) in
//            cell?.imageView?.image=UIImage(data: data.data!)
//        }
        onGetCacheImage(url: rowData["picture"].string!, imgView: (cell?.imageView)!)
        return cell!
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform=CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.25) { 
            cell.layer.transform=CATransform3DMakeScale(1, 1, 1)
        }
    }
    func didRecieveResults(results: AnyObject) {
//        print(results)
        let json=JSON(results)
        print(json)
        if let channels=json["channels"].array{
            self.channelData=channels
        }
        else if let song=json["song"].array{
            self.tableData=song
            isAutoFinish=false
            self.tv.reloadData()
            onSelectedRow(index: 0)
//            print(tableData)
        }
        else{
            print("error")
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isAutoFinish=false
        onSelectedRow(index: indexPath.row)
    }
    
    func onSelectedRow(index:Int){
        let indexPath=IndexPath(row: index, section: 0)
        tv.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        var rowData:JSON=self.tableData[index]
        let imgUrl=rowData["picture"].string
        onSetImage(url: imgUrl!)
        let url=rowData["url"].string
        //print(url)
        onSetAudio(url: url!)
    }
    //设置主图片
    func onSetImage(url:String){
        onGetCacheImage(url: url, imgView: self.iv)
        onGetCacheImage(url: url, imgView: self.bg)
    }
    func onChangeChannel(channel_id:String){
        let url:String="https://douban.fm/j/mine/playlist?type=n&channel=\(channel_id)&from=mainsite"
        eHttp.onSearch(url: url)
    }
    func onGetCacheImage(url:String,imgView:UIImageView){
        let image=self.imageCache[url]
        if image==nil{
            Alamofire.request(url).response { (data) in
                let img=UIImage(data: data.data!)
                imgView.image=img
                self.imageCache[url]=img
            }
        }
        else{
            imgView.image=image!
        }
    }
    func onSetAudio(url:String){
        self.audioPlayer.stop()
        self.audioPlayer.contentURL=NSURL(string: url) as URL!
        self.audioPlayer.play()
        btnPlay.onPlay()
        timer?.invalidate()
        playTime.text="00:00"
        timer=Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(ViewController.onUpdate), userInfo: nil, repeats: true)
        
        isAutoFinish=true
    }
    func onUpdate(){
        let c=audioPlayer.currentPlaybackTime
        if c>0.0{
            let t=audioPlayer.duration
            
            let pro=CGFloat(c/t)
            progress.frame.size.width=view.frame.size.width*pro
            let all=Int(c)
            let sec=all%60
            let min=Int(all/60)
            
            var time=""
            if min<10{
                time="0\(min)"
            }
            else{
                time="\(min)"
            }
            time+=":"
            if sec<10{
                time+="0\(sec)"
            }
            else{
                time+="\(sec)"
            }
            playTime.text=time
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let channelC:ChannelController=segue.destination as! ChannelController
        channelC.delegate=self
        channelC.channelData=self.channelData
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

