//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by George Kedenburg on 5/19/15.
//  Copyright (c) 2015 GK3. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController,UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var feedScrollView: UIScrollView!
    @IBOutlet weak var mailboxView: UIView!
    @IBOutlet weak var singleMessage: UIImageView!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var helpImage: UIImageView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var singleMessageView: UIView!
    @IBOutlet weak var messageIconImage: UIImageView!
    
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var rescheduleImage: UIImageView!
    @IBOutlet weak var laterImage: UIImageView!
    @IBOutlet weak var archiveImage: UIImageView!
    @IBOutlet weak var composeView: UIView!
    @IBOutlet weak var composeImage: UIImageView!
    @IBOutlet weak var composeInput: UITextField!
    
    @IBOutlet var messageSwipeGesture: UIPanGestureRecognizer!
    
    var messageOrigin:CGFloat!
    var mailboxOrigin:CGFloat!
    var blueColor = UIColor(red:0.34, green:0.73, blue:0.85, alpha:1)
    var yellowColor = UIColor(red:1, green:0.82, blue:0.23, alpha:1)
    var brownColor = UIColor(red:0.84, green:0.65, blue:0.47, alpha:1)
    var redColor = UIColor(red:0.93, green:0.33, blue:0.13, alpha:1)
    var greenColor = UIColor(red:0.4, green:0.84, blue:0.41, alpha:1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageOrigin = singleMessage.center.x
        mailboxOrigin = mailboxView.center.x
        messageSwipeGesture.delegate = self
        
        feedScrollView.delegate = self
        feedScrollView.contentSize.width = CGFloat(320)
        feedScrollView.contentSize.height = helpImage.image!.size.height + singleMessage.image!.size.height + searchImage.image!.size.height + feedImage.image!.size.height
        feedScrollView.contentOffset.y = searchImage.image!.size.height + helpImage.image!.size.height
        
        messageIconImage.center.y = singleMessage.center.y
        
        segmentControl.tintColor = blueColor
        
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "edgeDrag:")
        edgeGesture.edges = UIRectEdge.Left
        view.addGestureRecognizer(edgeGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var direction = "none"
    var inMode = ""
    @IBAction func dragMessage(sender: UIPanGestureRecognizer) {
        var velocity = sender.velocityInView(view)
        var translation = sender.translationInView(view)
        var viewPos = singleMessage.frame.origin
        
        if sender.state == UIGestureRecognizerState.Began{
            
        } else if sender.state == UIGestureRecognizerState.Changed{
            singleMessage.center.x = messageOrigin + translation.x
            viewPos = singleMessage.frame.origin
            
            if viewPos.x < 0{
                direction = "left"
            } else {
                direction = "right"
            }
            
            
            if direction == "left"{
                messageIconImage.image = UIImage(named: "later_icon")
                if viewPos.x < -60 && viewPos.x >= -260{
                    inMode = "yellow"
                    messageIconImage.alpha = 1
                    self.singleMessageView.backgroundColor = yellowColor
                    messageIconImage.image = UIImage(named: "later_icon")
                    messageIconImage.frame.origin.x = singleMessage.frame.origin.x + CGFloat(335)
                } else if viewPos.x < -260{
                    inMode = "brown"
                    messageIconImage.alpha = 1
                    self.singleMessageView.backgroundColor = brownColor
                    messageIconImage.image = UIImage(named: "list_icon")
                    messageIconImage.frame.origin.x = singleMessage.frame.origin.x + CGFloat(335)
                } else{
                    inMode = ""
                    self.singleMessageView.backgroundColor = UIColor.lightGrayColor()
                    var progress = CGFloat(convertValue(Float(viewPos.x), 0, -60, 0, 1))
                    messageIconImage.alpha = progress
                    messageIconImage.center.x = 290
                }
                
            } else if direction == "right" {
                messageIconImage.image = UIImage(named: "archive_icon")
                if viewPos.x < 260 && viewPos.x > 60{
                    inMode = "green"
                    messageIconImage.alpha = 1
                    self.singleMessageView.backgroundColor = greenColor
                    messageIconImage.image = UIImage(named: "archive_icon")
                    messageIconImage.frame.origin.x = singleMessage.frame.origin.x - CGFloat(40)
                } else if viewPos.x >= 260{
                    inMode = "red"
                    messageIconImage.alpha = 1
                    self.singleMessageView.backgroundColor = redColor
                    messageIconImage.image = UIImage(named: "delete_icon")
                    messageIconImage.frame.origin.x = singleMessage.frame.origin.x - CGFloat(40)
                } else{
                    inMode = ""
                    self.singleMessageView.backgroundColor = UIColor.lightGrayColor()
                    var progress = CGFloat(convertValue(Float(viewPos.x), 0, 60, 0, 1))
                    messageIconImage.alpha = progress
                    messageIconImage.center.x = 30
                }
            }
            
        } else if sender.state == UIGestureRecognizerState.Ended{
            if inMode == ""{
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 200, initialSpringVelocity: 20, options: nil, animations: { () -> Void in
                    self.singleMessage.center.x = self.messageOrigin
                    }, completion: nil)
            } else {
                if inMode == "green" || inMode == "red"{
                    UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 200, initialSpringVelocity: 10, options: nil, animations: { () -> Void in
                        self.singleMessage.frame.origin.x = 360
                        self.messageIconImage.frame.origin.x = self.singleMessage.frame.origin.x - CGFloat(40)
                        }, completion: nil)
                    delay(0.6, { () -> () in
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.singleMessageView.frame.origin.y -= 86
                            self.singleMessageView.alpha = 0
                            self.feedImage.frame.origin.y -= 86
                            self.feedScrollView.contentSize.height -= 86
                        })
                        
                    })
                    
                }
                if inMode == "yellow"{
                    UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 200, initialSpringVelocity: 10, options: nil, animations: { () -> Void in
                        self.singleMessage.frame.origin.x = -360
                        self.messageIconImage.frame.origin.x = self.singleMessage.frame.origin.x + CGFloat(335)
                        }, completion: nil)
                    UIView.animateWithDuration(0.2, delay: 0.6, options: nil, animations: { () -> Void in
                        self.rescheduleImage.alpha = 1
                        }, completion: nil)
                }
                if inMode == "brown"{
                    UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 200, initialSpringVelocity: 10, options: nil, animations: { () -> Void in
                        self.singleMessage.frame.origin.x = -360
                        self.messageIconImage.frame.origin.x = self.singleMessage.frame.origin.x + CGFloat(335)
                        }, completion: nil)
                    UIView.animateWithDuration(0.2, delay: 0.6, options: nil, animations: { () -> Void in
                        self.listImage.alpha = 1
                        }, completion: nil)
                }
            }
            direction = "none"
        }
    }
    
    @IBAction func tapList(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 200, initialSpringVelocity: 10, options: nil, animations: { () -> Void in
            self.listImage.alpha = 0
            }, completion: nil)
        delay(0.2, { () -> () in
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.singleMessageView.frame.origin.y -= 86
                self.singleMessageView.alpha = 0
                self.feedImage.frame.origin.y -= 86
                self.feedScrollView.contentSize.height -= 86
            })
            
        })
    }
    
    @IBAction func tapReschedule(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 200, initialSpringVelocity: 10, options: nil, animations: { () -> Void in
            self.rescheduleImage.alpha = 0
            }, completion: nil)
        delay(0.2, { () -> () in
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.singleMessageView.frame.origin.y -= 86
                self.singleMessageView.alpha = 0
                self.feedImage.frame.origin.y -= 86
                self.feedScrollView.contentSize.height -= 86
            })
            
        })
        
    }
    @IBAction func toggleMenu(sender: AnyObject) {
        if mailboxView.frame.origin.x == 285{
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                self.mailboxView.frame.origin.x = 0
                }, completion: nil)
        } else {
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                self.mailboxView.frame.origin.x = 285
                }, completion: nil)
        }
        
    }
    @IBAction func segmentChange(sender: AnyObject) {
        var selected = segmentControl.selectedSegmentIndex
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            if selected == 0{
                self.segmentControl.tintColor = self.yellowColor
                self.laterImage.frame.origin.x = 0
                self.feedScrollView.frame.origin.x = 320
                self.archiveImage.frame.origin.x = 640
            } else if selected == 1{
                self.segmentControl.tintColor = self.blueColor
                self.laterImage.frame.origin.x = -320
                self.feedScrollView.frame.origin.x = 0
                self.archiveImage.frame.origin.x = 320
            } else if selected == 2{
                self.segmentControl.tintColor = self.greenColor
                self.laterImage.frame.origin.x = -640
                self.feedScrollView.frame.origin.x = -320
                self.archiveImage.frame.origin.x = 0
            }
        })
        
    }
    
    var canEdgeDrag = true
    @IBAction func edgeDrag(sender: AnyObject) {
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        if sender.state == UIGestureRecognizerState.Began{
            if mailboxView.frame.origin.x != 0{
                canEdgeDrag = false
            }
        } else if sender.state == UIGestureRecognizerState.Changed && canEdgeDrag{
            var newX = mailboxOrigin + translation.x
            println(newX)
            if newX > 445{
                newX = mailboxOrigin + 260 + (translation.x / 10)
            }
            self.mailboxView.center.x = newX        } else if sender.state == UIGestureRecognizerState.Ended && canEdgeDrag{
            if velocity.x > 0{
                toggleMenu(view)
            } else {
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                    self.mailboxView.frame.origin.x = 0
                    }, completion: nil)
            }
            
        }
    }
    @IBAction func doCompose(sender: AnyObject) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.composeView.alpha = 1
        })
        
        UIView.animateWithDuration(0.3, delay: 0.2, options: nil, animations: { () -> Void in
            self.composeImage.frame.origin.y = 20
        }, completion: nil)
        
        delay(0.2, { () -> () in
            composeInput.becomeFirstResponder()
        })
        
    }
    @IBAction func endComposeEditing(sender: AnyObject) {
        view.endEditing(true)
    }
    @IBAction func cancelComposing(sender: AnyObject) {
        view.endEditing(true)
        
        UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: { () -> Void in
            self.composeImage.frame.origin.y = 568
            self.composeView.alpha = 0
            }, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if(event.subtype == UIEventSubtype.MotionShake) {
            if singleMessageView.alpha == 0{
                self.singleMessage.frame.origin.x = 0
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.singleMessageView.frame.origin.y += 86
                    self.singleMessageView.alpha = 1
                    self.feedImage.frame.origin.y += 86
                    self.feedScrollView.contentSize.height += 86
                })
                
            }
        }
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
