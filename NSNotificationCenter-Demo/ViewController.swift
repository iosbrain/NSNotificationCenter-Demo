//
//  ViewController.swift
//  Delegation-In-Swift
//
//  Created by Software Testing on 2/8/18.
//
/*
 
 Copyright (c) 2018 Andrew L. Jaffee, microIT Infrastructure, LLC, and
 iosbrain.com.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 NOTE: As this code makes URL references to NASA images, if you make use of those URLs, you MUST abide by NASA's image guidelines pursuant to https://www.nasa.gov/multimedia/guidelines/index.html
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
*/

import UIKit

// NOTE: I set auto layout constraints for the view controller
// in the storyboard corresponding to this ViewController
// for "View as: iPhone SE."

class ViewController: UIViewController
{
    
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var leftSquareView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var rightSquareView: UIView!
    
    var logoDownloader:LogoDownloader?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //
        // This is ONE-TO-ONE: one sender (post) and one listener
        // (observer).
        //
        // STEP 2.1: Start "observing" (listening) for ONE "notification"
        // (message) labelled "com.iosbrain.logoDownloadCompletedNotificationID";
        // when we receive this message, we call the didFinishDownloading method to
        // display the login interface. The observer is this class,
        // ViewController.
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishDownloading), name: Notification.Name(rawValue: logoDownloadNotificationID), object: nil)

        //
        // STEP 2.2:
        //
        // This is ONE-TO-MANY: one sender (post) and MANY listeners
        // (observers). This of my radio station analogy.
        //
        // Start "observing" (listening) for THREE "notifications"
        // (messages) ALL labelled "com.iosbrain.welcomeReadyNotificationID";
        // when we receive these messages, we call the showLeftSquare,
        // showWelcomeLabel, and showRightSquare methods to
        // display the welcome interface. The observer is this class,
        // ViewController.
        NotificationCenter.default.addObserver(self, selector: #selector(showLeftSquare), name: Notification.Name(rawValue: welcomeReadyNotificationID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showWelcomeLabel), name: Notification.Name(rawValue: welcomeReadyNotificationID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showRightSquare), name: Notification.Name(rawValue: welcomeReadyNotificationID), object: nil)
        
        // Initially, the "Welcome" label and two green views are hidden -- being
        // saved for that juicy login.
        leftSquareView.alpha = 0.0
        welcomeLabel.alpha = 0.0
        rightSquareView.alpha = 0.0
        
        // Initially, the image view is hidden so we can fade it in with animation.
        imageView.alpha = 0.0

        // Initially, the login area, with username, password, and
        // login button are hidden until the logo image downloads;
        // then we fade it in.
        loginView.alpha = 0.0
        
        // NASA images used pursuant to https://www.nasa.gov/multimedia/guidelines/index.html
        let imageURL: String = "https://cdn.spacetelescope.org/archives/images/publicationjpg/heic1509a.jpg"
        
        // Construct a LogoDownloader to download the NASA file.
        logoDownloader = LogoDownloader(logoURL: imageURL)

        // Start the logo image download and get informed when it
        // finishes downloading -- that'll be when
        // didFinishDownloading() is called.
        logoDownloader?.downloadLogo()
        
    } // end func viewDidLoad()

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // STEP 5: It's good practice to remember to STOP
    // listening (observing) for notifications (messages)
    // once listening won't do us any good. In a more complex
    // and dynamic scenario, you'd see why you'd want to be
    // tiddy.
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: logoDownloadNotificationID), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: welcomeReadyNotificationID), object: nil)
    }
    
    // STEP 4.2: When welcomeReadyNotificationID is
    // received, THESE THREE methods are executed.
    // These methods are called when we receive a notification
    // that "Login" button was clicked.
    // NOTE the "@objc" definition (homework).
    @objc func showLeftSquare()
    {
        UIView.animate(withDuration: 1.0)
        {
            self.leftSquareView.alpha = 1.0
        }
    }
    @objc func showWelcomeLabel()
    {
        UIView.animate(withDuration: 1.0)
        {
            self.welcomeLabel.alpha = 1.0
        }
    }
    @objc func showRightSquare()
    {
        UIView.animate(withDuration: 1.0)
        {
            self.rightSquareView.alpha = 1.0
        }
    }
    // -------------------------------
    
    // STEP 4.1: When logoDownloadNotificationID is
    // received, this is the method that's executed.
    // This method is called when we receive a notification
    // that the logo image finished downloading.
    // NOTE the "@objc" definition (homework).
    @objc func didFinishDownloading()
    {
        imageView.image = logoDownloader?.image
        
        // Animate the appearance of this ViewController's
        // user interface.
        UIView.animate(withDuration: 2.0, delay: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations:
        {
            self.loadingLabel.alpha = 0.0
            self.imageView.alpha = 1.0
        })
        { (completed:Bool) in
            if (completed)
            {
                UIView.animate(withDuration: 2.0)
                {
                    self.loginView.alpha = 1.0
                }
            }
        }
    } // end func didFinishDownloading
    
    // STEP 3.2: When the can click the "Login" button, and does so,
    // this method is called and it BROADCASTS -- "posts" (sends) --
    // a "notification" (message) to anyone who's "observing" (listening).
    // Note below that this class ("object: self") is posting the notification.
    @IBAction func loginButtonTapped(_ sender: Any)
    {
        NotificationCenter.default.post(name: Notification.Name(rawValue: welcomeReadyNotificationID), object: self)
    }
    
} // end class ViewController

