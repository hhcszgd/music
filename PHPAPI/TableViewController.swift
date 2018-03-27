//
//  TableViewController.swift
//  PHPAPI
//
//  Created by WY on 2018/3/20.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import AVFoundation
class TableViewController: UITableViewController {
    var musics : [MusicModel]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.getData()
    }
    func readLocalFile() -> [String]{
        var  docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
//        docuPath = docuPath + "/\(musicName)"
        let arr = try? FileManager.default.contentsOfDirectory(atPath: docuPath)
        var arrMusics = [String]();
        if let arrUnrap = arr{
            for item in arrUnrap{
                if item.hasSuffix(".mp3"){
                    arrMusics.append(item)
                }
            }
        }
        return arrMusics
    }
    func getData(){
        let arr = self.readLocalFile()
        var musics = [MusicModel]()
        if arr.count > 0 {
            for item in arr{
                let model = MusicModel()
//                model.url
                let name = FileManager.default.displayName(atPath: item)
                model.name = name
                model.url = item
                musics.append(model)
            }
            self.musics = musics
            self.tableView.reloadData()
        }else{
            DDRequestManager.share.request(url: "music/get_music.php", method: .post, para: ["zhang":"小史同学"], true )?.responseJSON(completionHandler: { (response) in
                mylog(response.debugDescription)
                if let musicModel = DDDecode([MusicModel].self , from: response.data ?? Data()){
                    self.musics = musicModel
                    self.tableView.reloadData()
                }
            })
            
        }
        
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let name = musics?[indexPath.row].name {
            self.pushVC(vcIdentifier: "PlayVC", userInfo: ["currentSong":indexPath.row , "songsArr": self.musics ?? [] ])
        }else{
            //mingzi wuxaio
        }
        switch indexPath.row {
        case 0:
//            let str = self.musics?[indexPath.row].url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) ?? ""
//            let url = URL(string:str)!
//            let item = AVPlayerItem.init(url: url)
//            MusicPlayer.share.replaceCurrentItem(with: item)
//            MusicPlayer.share.playMusic(url: "")
            
//            DDRequestManager.share.request(url: "http://127.0.0.1:8080/test/add.php", method: .post, para: ["zhang":"小史同学" , "lastname":"秦"], true )?.responseJSON(completionHandler: { (response) in
//                mylog(response.debugDescription)
//            })
            break
        case 1:
//            PHPRequestManager.share.test()
            
            break
        case 2:
            break
        case 3:
            break
        case 4:
            let rect : CGRect = CGRect()
//            rect.attr
            break
        case 5:
            break
        default:
            break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.musics?.count ?? 0;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        if let tempCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier"){
            cell = tempCell
        }else{
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
        }
//        cell.backgroundColor = UIColor.init(red:CGFloat (arc4random() % 256) / 256, green: CGFloat((arc4random() % 256) / 256), blue:CGFloat((arc4random() % 256) / 256), alpha: 1)
        
        cell.textLabel?.text = self.musics?[indexPath.row].name 
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}


class MusicModel: NSObject , Codable {
    var name  = ""
    var url = ""
    var size = ""
    
}

class Test{
    func sss(a : Int ...)  {
        mylog(a)
    }
}
