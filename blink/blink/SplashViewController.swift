//
//  SplashViewController.swift
//  blink
//
//  Created by Dharmesh Sonani on 12/04/19.
//  Copyright © 2019 Deedcoin Office. All rights reserved.
//

import UIKit
import AVKit

class SplashViewController: UIViewController {

    var player: AVPlayer?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadVideo()
    }
    

    private func loadVideo() {
        
        //this line is important to prevent background music stop
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .defaultToSpeaker)
        } catch { }
        
        let path = Bundle.main.path(forResource: "ledgerLeapLaunchScreen", ofType:"mp4")
        
        player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.zPosition = -1
        
        self.view.layer.addSublayer(playerLayer)
        
        player?.seek(to: CMTime.zero)
        player?.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)


    }
    
    @objc func playerDidFinishPlaying()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setupRootVC()
    }

}
