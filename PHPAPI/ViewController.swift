//
//  ViewController.swift
//  PHPAPI
//
//  Created by WY on 2018/3/19.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        testPHP()
//         MusicPlayer.share.playMusic(url: "")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController{
    func testPHP() {
        PHPRequestManager.share.test()
    }
}
