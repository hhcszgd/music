//
//  PlayVC.swift
//  PHPAPI
//
//  Created by WY on 2018/3/26.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class PlayVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange
        if let dict = self.userInfo as? [String : Any ]{
            if let currentNusicIndex = dict["currentSong"] as? Int , let musicArr = dict["songsArr"] as? [MusicModel]{
                let musicName = musicArr[currentNusicIndex].name
                self.title = musicName
                MusicPlayer.share.playMusic(currentNusicIndex: currentNusicIndex , musicArr:musicArr)
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    override var canBecomeFirstResponder: Bool{
        get{return true }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.endReceivingRemoteControlEvents()
        self.resignFirstResponder()
    }

    override func remoteControlReceived(with event: UIEvent?) {
        super.remoteControlReceived(with: event)
        if let eventUnwrap = event{
            if eventUnwrap.type == UIEventType.remoteControl {
                switch eventUnwrap.subtype{
                case .remoteControlPause://
                    MusicPlayer.share.player?.pause()
                    
                case .remoteControlPlay://
                    MusicPlayer.share.player?.play()
                    
                case .remoteControlPreviousTrack:////上一曲
//                    MusicPlayer.share.player?.pause()
                    break
                case .remoteControlNextTrack://
//                    MusicPlayer.share.player?.pause()
                    break
                default :
                    break
                }
            }
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    deinit {
        MusicPlayer.share.stop()
    }
}
