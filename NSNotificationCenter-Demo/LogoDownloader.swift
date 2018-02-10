//
//  LogoDownloader.swift
//  Delegation-In-Swift
//
//  Created by Andrew L. Jaffee on 2/8/18.
//
/*
 
 Copyright © 2018 Andrew L. Jaffee, microIT Infrastructure, LLC, and
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

import Foundation

import UIKit

// STEP 1: Define unique strings to identify the purpose of
// all this app's notifications. I've defined these as global
// constants because messages are often sent to various locations
// throughout an app. I use my reverse domain name because
// I know it will be unique and won't clash with any
// iOS-based notifications.
let logoDownloadNotificationID =
    "com.iosbrain.logoDownloadCompletedNotificationID"
let welcomeReadyNotificationID =
    "com.iosbrain.welcomeReadyNotificationID"

class LogoDownloader
{
    
    var logoURL:String
    
    var image:UIImage?
    
    init(logoURL:String)
    {
        self.logoURL = logoURL
    }
    
    func downloadLogo() -> Void
    {
        // Start the image download task asynchronously by submitting
        // it to the default background queue; this task is submitted
        // and DispatchQueue.global returns immediately.
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async
        {
                
            // I'm PURPOSEFULLY downloading the image using a synchronous call
            // (NSData), but I'm doing so in the BACKGROUND.
            let imageURL = URL(string: self.logoURL)
            let imageData = NSData(contentsOf: imageURL!)
            self.image = UIImage(data: imageData! as Data)
            print("image downloaded")

            // Once the image finishes downloading, I jump onto the MAIN
            // THREAD TO UPDATE THE UI.
            DispatchQueue.main.async
            {
                // Tell somebody listening that the image
                // has downloaded so the listener can
                // display the image.
                self.didDownloadImage()
            }
                
        } // end DispatchQueue.global
    }
    
    // STEP 3.1: When the image finishes downloading, this method is
    // called and it "posts" (sends) a "notification"
    // (message) to anyone who's "observing" (listening). Note below
    // that this class ("object: self") is posting the notification.
    func didDownloadImage()
    {
        NotificationCenter.default.post(name: Notification.Name(rawValue: logoDownloadNotificationID), object: self)
    }
    
} // end class LogoDownloader
