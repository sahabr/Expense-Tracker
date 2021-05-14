//
//  OpenViewController.swift
//  Expense Tracker
//
//  Created by Brishti Saha on 5/13/21.
//

import UIKit
import AVFoundation


class OpenViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var audioPlayer: AVAudioPlayer!

    
    var yCurrent: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playSound(name: "ka-ching")
        
        yCurrent = imageView.frame.origin.y
        imageView.frame.origin.y = self.view.frame.height
        UIView.animateKeyframes(withDuration: 1.0, delay: 1.0) {
            self.imageView.frame.origin.y = self.yCurrent
        }
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        self.audioPlayer.stop()
        performSegue(withIdentifier: "ShowTableView", sender: nil)
    }
    
    func playSound(name: String){
        if let sound = NSDataAsset(name: name){
            do{
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            }catch{
                print("Error: \(name)")
            }
        }else{
            print("Error: can't load from \(name)")
        }
    }

}
