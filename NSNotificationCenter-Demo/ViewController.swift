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
    
    var logoDownloader:LogoDownloader?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // STEP 3: Start "observing" (listening) for a "notification"
        // (message) labelled "logoDownloadCompleted"; when we
        // receive this message, we call the didFinishDownloading method to
        // display the login interface. The observer is this class,
        // ViewController.
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishDownloading), name: .logoDownloadCompleted, object: nil)
        
        // Initially, the image view is hidden so we can fade it in with animation.
        imageView.alpha = 0.0

        // Initially, the login area, with username and password, are hidden
        // until the logo image downloads, and then we fade it in.
        loginView.alpha = 0.0
        
        // NASA images used pursuant to https://www.nasa.gov/multimedia/guidelines/index.html
        let imageURL: String = "https://cdn.spacetelescope.org/archives/images/publicationjpg/heic1509a.jpg"
        
        // Construct a LogoDownloader to download the NASA file.
        logoDownloader = LogoDownloader(logoURL: imageURL)

        // Start the logo image download and get informed when it
        // finishes downloading when didFinishDownloading() is called.
        logoDownloader?.downloadLogo()
        
    } // end func viewDidLoad()

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     STEP 5: It's good practice to remember to STOP
     listening (observing) for notifications (messages)
     once listening won't do us any good. In a more complex
     and dynamic scenario, you'd see why you'd want to be
     tiddy.
    */
    deinit
    {
       NotificationCenter.default.removeObserver(self)
    }
    
    /**
     This method is called when we receive a notification
     that the logo image finished downloading.
     NOTE the "@objc" definition.
    */
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
    
    /**
     Navigation back to this view controller via unwind segue.
     
     - parameter sender: The segue which we're unwinding
     */
    @IBAction func unwindSegueFromContentVC(_ sender: UIStoryboardSegue)
    {
        let sender = sender.source.description
        print(sender)
    }

} // end class ViewController

