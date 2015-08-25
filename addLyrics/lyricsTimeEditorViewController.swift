//
//  ViewController.swift
//  addLyrics
//
//  Created by Jun Zhou on 7/13/15.
//  Copyright (c) 2015 Jun Zhou. All rights reserved.
//

import UIKit

import AVFoundation

struct textFromTextEditor {
    static var organizedLyrics: [String] = [String]()
}

class lyricsTimeEditorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellTableIdentifier = "CellTableIdentifier"
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    var original_lyrics: [String] = [String]()    //lyrics without time
    var lyricsFromTextEditor: String = String()
    var nameFromTextEditor: String = String()
    var final_lyrics: EditableLyrics = EditableLyrics()
    var blurEffect: UIBlurEffect = UIBlurEffect()
    var trueWidth: CGFloat = CGFloat()
    var trueHeight: CGFloat = CGFloat()
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bar: UISlider!
    @IBOutlet weak var lyrics: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.view.frame.width < self.view.frame.height {
            self.trueWidth = self.view.frame.width
            self.trueHeight = self.view.frame.height
        } else if self.view.frame.width > self.view.frame.height {
            self.trueWidth = self.view.frame.height
            self.trueHeight = self.view.frame.width
        }
        // Do any additional setup after loading the view, typically from a nib.
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRectMake(0, 0, trueWidth, trueHeight)
        self.backgroundImage.addSubview(blurEffectView)
        backgroundImage.image = UIImage(named: "background1.jpg")
        
        lyrics.backgroundColor = UIColor.clearColor()
        lyrics.backgroundView = nil
        lyrics.opaque = false
        
        final_lyrics = EditableLyrics(original: original_lyrics)
        //self.lyrics.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        lyrics.tableFooterView = UIView(frame: CGRectZero)
        lyrics.separatorColor = UIColor.clearColor()
        
        var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("rainbow", ofType: "mp3")!)
        println(alertSound)
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)

        audioPlayer.prepareToPlay()
        
        bar.maximumValue = Float(audioPlayer.duration)
        bar.value = 0
        
        bar.addTarget(self, action: "changeAudioTime:", forControlEvents: UIControlEvents.ValueChanged)
        
        labelName.text = nameFromTextEditor
        labelName.textColor = UIColor.whiteColor()
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    var viewDidAppear = false
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppear = true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func update() {
        bar.value = Float(audioPlayer.currentTime)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            if !viewDidAppear {
                self.animate(cell)
            }
    }
    
    private func animate(cell: UITableViewCell) {
        let view = cell.contentView
        view.layer.opacity = 0.1
        UIView.animateWithDuration(1.4) {
            view.layer.opacity = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func changeAudioTime(sender: UISlider) {
        if audioPlayer.playing == true {
            audioPlayer.stop()
            audioPlayer.currentTime = NSTimeInterval(bar.value)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } else {
            audioPlayer.currentTime = NSTimeInterval(bar.value)
        }
    }
    
    @IBAction func pressBackButton(sender: AnyObject) {
        var refreshAlert = UIAlertController(title: "Back to Text Editor", message: "Are you sure you want back to Text Editor without saving the Tab?", preferredStyle: UIAlertControllerStyle.Alert)
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            //var jamListView: jamListViewController = jamListViewController()
            self.audioPlayer.stop()
            self.audioPlayer.currentTime = 0
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        refreshAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        presentViewController(refreshAlert, animated: true, completion: nil)
    }

    @IBAction func pressplayButton(sender: AnyObject) {
        if audioPlayer.playing {
            audioPlayer.stop()
            playButton.setTitle("Play", forState: UIControlState.Normal)
        } else {
            audioPlayer.play()
            playButton.setTitle("Pause", forState: UIControlState.Normal)
        }
    }

    
    @IBAction func pressdoneButton(sender: AnyObject) {
        println("Finish Editing")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:LyricsCell = self.lyrics.dequeueReusableCellWithIdentifier("cell") as! LyricsCell
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = nil
        cell.opaque = false
        if final_lyrics.isTimeAdded[indexPath.row] == false {
            cell.checkImage.alpha = 0
        } else {
            cell.checkImage.alpha = 1
            cell.checkImage.image = UIImage(named: "check.png")
        }
        cell.lyricsLabel.numberOfLines = 2;
        cell.lyricsLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.lyricsLabel.text = final_lyrics.lyrics[indexPath.row]
        cell.lyricsLabel.textAlignment = NSTextAlignment.Center
        cell.lyricsLabel.font = UIFont.systemFontOfSize(CGFloat(20))
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return final_lyrics.lyrics.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var line = final_lyrics.get(indexPath.row)
        println("You selected \(line)")
        if indexPath.row == 0 || final_lyrics.isTimeAdded[indexPath.row - 1] {
            if final_lyrics.isTimeAdded[indexPath.row] == false {
                var time = TimeNumber(time: Float(audioPlayer.currentTime))
                final_lyrics.times[indexPath.row] = time
                final_lyrics.lyrics[indexPath.row] = final_lyrics.lyrics[indexPath.row] + " " + "\(time.toDecimalNumer())"
                final_lyrics.isTimeAdded[indexPath.row] = true
                lyrics.reloadData()
            }else {
                audioPlayer.currentTime = NSTimeInterval(final_lyrics.times[indexPath.row].toDecimalNumer())
            }
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete && final_lyrics.isTimeAdded[indexPath.row] == true {
            // handle delete (by removing the data from your array and updating the tableview)
            var index = indexPath.row
            while final_lyrics.isTimeAdded[index] {
                var time = final_lyrics.get(index).time
                var n = count(final_lyrics.lyrics[index])
                var m = count("\(time.toDecimalNumer())")
                let range = Range(start: final_lyrics.lyrics[index].startIndex, end: advance(final_lyrics.lyrics[index].startIndex, n - m))
                var temp = final_lyrics.lyrics[index].substringWithRange(range)
                final_lyrics.lyrics[index] = temp
                final_lyrics.isTimeAdded[index] = false
                index++
            }
            lyrics.reloadData()
            if indexPath.row == 0 {
                audioPlayer.currentTime = NSTimeInterval(0)
            } else {
                audioPlayer.currentTime = NSTimeInterval(final_lyrics.get(indexPath.row - 1).time.toDecimalNumer())
            }
        }
    }
}


