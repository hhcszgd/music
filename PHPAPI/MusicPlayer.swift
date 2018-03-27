//
//  MusicPlayer.swift
//  PHPAPI
//
//  Created by WY on 2018/3/26.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
class MusicPlayer: NSObject  {
    var player : AVAudioPlayer?
    static let share : MusicPlayer =  {
        
        let p = MusicPlayer()
        return p
    }()
    var musics : [MusicModel]?
    var currentMusicIndex = 0
    func stop() {
        self.player?.stop()
    }
    
    override init() {
        super.init()
        self.setupLockScreen()
    }
    
    func playMusic(currentNusicIndex:Int , musicArr: [MusicModel]? = nil )  {
        var musicName = ""
        
        if musicArr != nil && musicArr!.count > 0 {
            self.musics = musicArr
             musicName = self.musics?[currentNusicIndex].name ?? ""
        }
         musicName = self.musics?[currentNusicIndex].name ?? ""
        self.currentMusicIndex = currentNusicIndex
        var  docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        docuPath = docuPath + "/\(musicName)"
        let exists = FileManager.default.fileExists(atPath: docuPath)
        if exists {
            self.performPlay(musicName: musicName)
        }else{
            DDRequestManager.share.downloadMp3(musicName: musicName, complite: {
                self.performPlay(musicName: musicName)
            })
        }
        
        
    }
    
    private func performPlay(musicName:String) {
        var  docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        docuPath = docuPath + "/\(musicName)"
        player?.stop()
        let url = URL(fileURLWithPath: docuPath)
        
        let p = try? AVAudioPlayer.init(contentsOf: url )
        p?.delegate = self
        self.player = p
        p?.play()
        configureNowPlayingInfo(musicName:musicName)
        
    }
    func setupLockScreen(){
        let commandCenter = MPRemoteCommandCenter.shared()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle: ""]//要显示的歌名
        
        commandCenter.nextTrackCommand.isEnabled = true//下一曲
        commandCenter.nextTrackCommand.addTarget(self, action:#selector(nextSong))
        
        commandCenter.previousTrackCommand.isEnabled = true//上一曲
        commandCenter.previousTrackCommand.addTarget(self , action: #selector(priviousSong))
        
        commandCenter.pauseCommand.isEnabled = true//暂停
        commandCenter.pauseCommand.addTarget(self , action: #selector(pauseSong))
        
        commandCenter.playCommand.isEnabled = true//播放
        commandCenter.playCommand.addTarget(self , action: #selector(playSongControlFromBackground))
        
//        commandCenter.skipForwardCommand.isEnabled = true//快进
//        commandCenter.skipForwardCommand.addTarget(self , action: #selector(skipForwardAction(sender:)))
//
//        commandCenter.skipBackwardCommand.isEnabled = true//快退
//        commandCenter.skipBackwardCommand.addTarget(self , action: #selector(skipBackforwardAction(sender:)))
        
        
        commandCenter.changePlaybackRateCommand.isEnabled = true//
        commandCenter.changePlaybackRateCommand.addTarget(self , action: #selector(skipBackforwardAction(sender:)))
        
        
        
        commandCenter.changePlaybackRateCommand.isEnabled = true//
        commandCenter.changePlaybackRateCommand.addTarget(self , action: #selector(skipBackforwardAction(sender:)))
        
        commandCenter.changeRepeatModeCommand.isEnabled = true//
        commandCenter.changeRepeatModeCommand.addTarget(self , action: #selector(skipBackforwardAction(sender:)))
        
        commandCenter.changeShuffleModeCommand.isEnabled = true//
        commandCenter.changeShuffleModeCommand.addTarget(self , action: #selector(skipBackforwardAction(sender:)))
        
        commandCenter.seekForwardCommand.isEnabled = true
        commandCenter.seekForwardCommand.addTarget { (event ) -> MPRemoteCommandHandlerStatus in
            
            mylog(event)
        return MPRemoteCommandHandlerStatus.success
        }
        
        commandCenter.changePlaybackPositionCommand.isEnabled = true
//        commandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(changePlaybackPositionAction(sender:)))
        commandCenter.changePlaybackPositionCommand.addTarget { (event ) -> MPRemoteCommandHandlerStatus in
            if let eventPosition = event as? MPChangePlaybackPositionCommandEvent{
                mylog(eventPosition.positionTime)
//                self.player?.play(atTime: eventPosition.positionTime)
                self.player?.currentTime = eventPosition.positionTime
            }

            return .success
        }
        
    }
    func changedThumbSliderOnLockScreen(event :MPChangePlaybackPositionCommandEvent ) -> MPRemoteCommandHandlerStatus{
//        [self setCurrentPlaybackTime:event.positionTime];
        // update  MPNowPlayingInfoPropertyElapsedPlaybackTime
//        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
        return .success;
        
    }

    
    
    func configureNowPlayingInfo(musicName:String) {
        mylog(self.player!.duration)
        mylog(self.player!.currentTime)
        mylog(self.player!.deviceCurrentTime)
        let nowPlayingInfo = [MPMediaItemPropertyTitle: musicName,
                          MPMediaItemPropertyPlaybackDuration: TimeInterval(self.player!.duration),
                          MPNowPlayingInfoPropertyElapsedPlaybackTime: self.player!.currentTime,
                          MPNowPlayingInfoPropertyPlaybackRate: Double(self.player!.rate),
                          MPMediaItemPropertyMediaType: MPMediaType.movie.rawValue] as [String : Any]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
//        if let image = media.mediumCoverImage ?? media.mediumBackgroundImage, let request = try? URLRequest(url: image, method: .get) {
//            ImageDownloader.default.download(request) { (response) in
//                guard let image = response.result.value else { return }
//                if #available(iOS 10.0, tvOS 10.0, *) {
//                    self.nowPlayingInfo?[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { (_) -> UIImage in
//                        return image
//                    }
//                } else {
//                    self.nowPlayingInfo?[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: image)
//                }
//            }
//        }
    }
    @objc func changePlaybackPositionAction(sender:MPChangePlaybackPositionCommandEvent){
        dump(sender)
        mylog("positionTime : \(sender.positionTime)||| timestamp: \(sender.timestamp) ")
        
    }

    @objc func changePlaybackRateAction(sender:Any){
        dump(sender)
    }
    @objc func changeRepeatModeAction(sender:Any){
        dump(sender)
    }
    
    
    @objc func changeShuffleAction(sender:Any){
        dump(sender)
    }
    
    
    
    @objc func skipForwardAction(sender:MPSkipIntervalCommandEvent){
        dump(sender)
    }
    
    @objc func skipBackforwardAction(sender:MPSkipIntervalCommandEvent){
        dump(sender)
    }
    
    
    @objc func nextSong()
    {
                var nextIndex = self.currentMusicIndex + 1
                if musics?.count ?? 0 > 0 && nextIndex >= musics!.count {
                    nextIndex = 0
                }
                self.playMusic(currentNusicIndex: nextIndex)
        mylog("dddddddddddddd")
    }
    @objc func priviousSong()
    {
        
        var nextIndex = self.currentMusicIndex - 1

        if  (musics?.count ?? 0 ) > 0 && nextIndex < 0   {
            nextIndex = musics!.count - 1
        }
        self.playMusic(currentNusicIndex: nextIndex)
        mylog("dddddddddddddd")
    }
    @objc func pauseSong()
    {
        mylog("dddddddddddddd")
    }
    
    @objc func playSongControlFromBackground()
    {
        mylog("dddddddddddddd")
    }
    
    static func canPlayBackground()  {
        let session  = AVAudioSession.sharedInstance()
        do{
            try session.setCategory(AVAudioSessionCategoryPlayback, with: [])
            
        }catch{
            mylog(error)
        }
        do{
            try session.setActive(true)
            
        }catch{
            mylog(error)
        }
        
        
    }
    deinit {
        mylog("player is die")
    }
    
}
extension  MusicPlayer:  AVAudioPlayerDelegate{
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        self.nextSong()
    }
    
    
    /* if an error occurs while decoding it will be reported to the delegate. */
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?)
    {}
    
    /* AVAudioPlayer INTERRUPTION NOTIFICATIONS ARE DEPRECATED - Use AVAudioSession instead. */
    
    /* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer)
    
    {}
    /* audioPlayerEndInterruption:withOptions: is called when the audio session interruption has ended and this player had been interrupted while playing. */
    /* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int){}
}
