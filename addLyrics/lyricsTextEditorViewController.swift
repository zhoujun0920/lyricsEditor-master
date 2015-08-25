//
//  lyricsEditorViewController.swift
//  addLyrics
//
//  Created by Jun Zhou on 7/14/15.
//  Copyright (c) 2015 Jun Zhou. All rights reserved.
//

import UIKit

struct GlobalLyrics {
    static var tempLyrics: EditableLyrics = EditableLyrics()
}

class lyricsTextEditorViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var lyricsEditorTextView: UITextView!
    @IBOutlet weak var ToTimeEditor: UIButton!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var textViewBottomLayoutGuideConstraint: NSLayoutConstraint!
    
    var organizedLyrics: [String] = [String]()
    var testlyrics = "哪里有彩虹告诉我\n能不能把我的愿望还给我\n为什么天这么安静\n所有的云都跑到我这里\n有没有口罩一个给我\n释怀说了太多就成真不了\n也许时间是一种解药\n也是我现在正服下的毒药\n看不见你的笑我怎么睡得着\n你的声音这么近我却抱不到\n没有地球太阳还是会绕\n没有理由我也能自己走\n你要离开\n我知道很简单\n你说依赖\n是我们的阻碍\n就算放开\n但能不能别没收我的爱\n当作我最后才明白\n哪里有彩虹告诉我\n能不能把我的愿望还给我\n为什么天这么安静\n所有的云都跑到我这里\n有没有口罩一个给我\n释怀说了太多就成真不了\n也许时间是一种解药\n也是我现在正服下的毒药\n看不见你的笑我怎么睡得着\n你的声音这么近我却抱不到\n没有地球太阳还是会绕\n没有理由我也能自己走\n你要离开\n我知道很简单\n你说依赖\n是我们的阻碍\n就算放开\n但能不能别没收我的爱\n当作我最后才明白"
    
    var blurEffect: UIBlurEffect = UIBlurEffect()
    var trueWidth: CGFloat = CGFloat()
    var trueHeight: CGFloat = CGFloat()
    
    override func viewDidLoad() {
        if self.view.frame.width < self.view.frame.height {
            self.trueWidth = self.view.frame.width
            self.trueHeight = self.view.frame.height
        } else if self.view.frame.width > self.view.frame.height {
            self.trueWidth = self.view.frame.height
            self.trueHeight = self.view.frame.width
        }
        
        lyricsEditorTextView.backgroundColor = UIColor.clearColor()
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRectMake(0, 0, trueWidth, trueHeight)
        self.backgroundImage.addSubview(blurEffectView)
        backgroundImage.image = UIImage(named: "background1.jpg")
        lyricsEditorTextView.textColor = UIColor.whiteColor()
        lyricsEditorTextView.text = testlyrics
        songName.text = "彩虹"
        organizedLyrics = formatLyrics(testlyrics)
        lyricsEditorTextView.layer.opacity = 0.1
        UIView.animateWithDuration(1.4, animations: {
            self.lyricsEditorTextView.layer.opacity = 1
            
        })
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    var viewDidAppear = false
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        lyricsEditorTextView.layer.opacity = 0.1
        UIView.animateWithDuration(1.4, animations: {
            self.lyricsEditorTextView.layer.opacity = 1
            
        })
        viewDidAppear = true
        
        // Listen for changes to keyboard visibility so that we can adjust the text view accordingly.
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: Keyboard Event Notifications
    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: true)
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: false)
    }
    
    // MARK: Convenience
    
    func keyboardWillChangeFrameWithNotification(notification: NSNotification, showsKeyboard: Bool) {
        let userInfo = notification.userInfo!
        
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        // Convert the keyboard frame from screen to view coordinates.
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        var originDelta: CGFloat = CGFloat()
        if showsKeyboard == true {
            originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        } else {
            originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        }
        
        // The text view should be adjusted, update the constant for this constraint.   
        textViewBottomLayoutGuideConstraint.constant -= originDelta

        view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: .BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        // Scroll to the selected text once the keyboard frame changes.
        let selectedRange = lyricsEditorTextView.selectedRange
        lyricsEditorTextView.scrollRangeToVisible(selectedRange)
        
        lyricsEditorTextView.layer.opacity = 0.1
        UIView.animateWithDuration(1.4, animations: {
            self.lyricsEditorTextView.layer.opacity = 1
            
        })
    }
    
    @IBAction func organizeLyrics(sender: AnyObject) {
        if lyricsEditorTextView.text != "" {
            organizedLyrics = formatLyrics(lyricsEditorTextView.text)
            lyricsEditorTextView.text = array2String(organizedLyrics)
            lyricsEditorTextView.layer.opacity = 0.1
            UIView.animateWithDuration(1.4, animations: {
                self.lyricsEditorTextView.layer.opacity = 1
            
            })
        } else {
            var refreshAlert = UIAlertController(title: "NO Lyrics", message: "Please Add Lyrics first", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func array2String(sender: [String]) -> String {
        var tempString: String = String()
        for var index = 0; index < organizedLyrics.count; index++ {
            tempString += organizedLyrics[index]
            tempString += "\n"
        }
        return tempString
    }

    @IBAction func pressDeleteButton(sender: AnyObject) {
        var refreshAlert = UIAlertController(title: "Delete Lyrics", message: "Are you sure you want delete all?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            self.lyricsEditorTextView.text = ""
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    @IBAction func ToMusic(sender: AnyObject) {
        
    }
    
    @IBAction func backgroundTab(sender: UIControl) {
        lyricsEditorTextView.resignFirstResponder()
        lyricsEditorTextView.layer.opacity = 0.1
        UIView.animateWithDuration(1.4, animations: {
            self.lyricsEditorTextView.layer.opacity = 1
            
        })
        
    }
    
    @IBAction func ToTimeEditor(sender: AnyObject) {
        let lyricsTimeEditor = storyboard!.instantiateViewControllerWithIdentifier("lyricsTimeEditor") as! lyricsTimeEditorViewController
        lyricsTimeEditor.nameFromTextEditor = songName.text!
        if lyricsEditorTextView.text == "" {
            lyricsTimeEditor.lyricsFromTextEditor = "You don't have any lyrics"
        }else {
            // lyricsTimeEditor.lyricsFromTextEditor = lyricsEditorTextView.text
            lyricsTimeEditor.original_lyrics = organizedLyrics
        }
        self.presentViewController(lyricsTimeEditor, animated: true, completion: nil)
    }
    
    func textViewDidChange(textView: UITextView) {
        organizedLyrics = formatLyrics(textView.text)
        lyricsEditorTextView.layer.opacity = 0.1
        UIView.animateWithDuration(1.4, animations: {
            self.lyricsEditorTextView.layer.opacity = 1
            
        })
    }
    
    private func formatLyrics(lyric: String) -> [String]{
        let maxCharPerLine = 40
        let lineArray: [String] = split(lyric){ $0 == "\n" }
        let letterOrnumber = NSCharacterSet.alphanumericCharacterSet()
        var result: [String] = [String]()
        for j in 0...(lineArray.count-1) {
            if count(lineArray[j]) == 0 {
                continue
            }
            let strArray: [String] = split(lineArray[j]){ $0 == " " }
            var str: String = ""
            for i in 0...(strArray.count-1) {
                var letter = strArray[i].unicodeScalars
                //Delete the puncuation at the start of a word
                while count(letter) > 0 && !letterOrnumber.longCharacterIsMember(letter[advance(letter.startIndex,0)].value){
                    letter.removeAtIndex(advance(letter.startIndex, 0))
                }
                if count(letter) == 0{
                    continue
                }
                //check whether the last char is a puncuation
                if !letterOrnumber.longCharacterIsMember(letter[advance(letter.startIndex,count(letter)-1)].value) {
                    while count(letter) > 0 && !letterOrnumber.longCharacterIsMember(letter[advance(letter.startIndex,count(letter)-1)].value){
                        letter.removeAtIndex(advance(letter.startIndex, count(letter)-1))
                    }
                    if count(letter) > 0 {
                        var newstr = (count(str) == 0) ?  "\(letter)" : (str + " \(letter)")
                        println(newstr)
                        if count(newstr) > maxCharPerLine{
                            if count(str) > 0 {
                                result.append(str)
                            }
                            result.append("\(letter)")
                        }
                        else {
                            result.append(newstr)
                        }
                    }
                    str = ""
                }
                else
                {
                    var newstr = (count(str) == 0) ?  "\(letter)" : (str + " \(letter)")
                    
                    if count(newstr) > maxCharPerLine {
                        if count(str) > 0 {
                            result.append(str)
                        }
                        str = "\(letter)"
                    }
                    else {
                        str = newstr
                    }
                }
                
                if i == (strArray.count-1) && count(str) > 0{
                    result.append(str)
                }
            }
        }
        
        return result
    }
    
}
