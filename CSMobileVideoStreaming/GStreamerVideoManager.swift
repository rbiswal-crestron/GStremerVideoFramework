//
//  GStreamerVideoViewController.swift
//  GStreamerSwift
//
//  Created by Rakesh Kumar Biswal on 21/07/23.
//

import Foundation
import UIKit




@objc public protocol VideoStreamingManagerDelegate{
    var  initialize:Bool {get set}
    func acceptMessage(_ json:[AnyHashable:Any])
    func setMessageListener(_ listner: (([AnyHashable:Any]?) -> Void)?)
    func dispose()
}


@objc public class VideoStreamingManager:NSObject,VideoStreamingManagerDelegate {
    
    private var messageListner:(([AnyHashable:Any]?) -> Void)?
    public var initialize:Bool = false
    private var streamingView:UIView?
    private var backend:GStreamerBackend?
        
    
    public func acceptMessage(_ v : [AnyHashable : Any]) {
        guard let json = v["Csig.video.request"] as? [String:Any],let action = json["action"] as? String else{
            return
        }
        if let frame = getFramefromJson(json) {
            streamingView = UIView()
            streamingView?.frame = frame
            self.backend = GStreamerBackend(self, videoView: streamingView)
        }
        
        if let nativeView = json["native_view"] as? UIView{
            self.backend = GStreamerBackend(self, videoView: nativeView)
        }
        if let source = json["source"] as? [String:String],let url = source["url"] {
            if action == "start"{
                initBackend(url: url)
            }
            if action == "stop"{
                stopVideo()
            }
         
        }
    }
    
    public func stopVideo(){
        self.backend?.pause()
        self.backend = nil
        self.backend?.deinit()
    }
   
    public func dispose() {
        stopVideo()
        messageListner  = nil
        initialize = false
    }
 
    @objc public override init() {
        super.init()
        gst_ios_init()
    }
    
    private func getFramefromJson(_ json:[AnyHashable:Any]) -> CGRect? {
        var location = CGRect()
        if let req_loc = json["location"] as? [String:Int] {
            location.origin.x =  CGFloat(integerLiteral: req_loc["left"]!)
            location.origin.y =  CGFloat(integerLiteral: req_loc["top"]!)
            location.size.width =  CGFloat(integerLiteral: req_loc["width"]!)
            location.size.height =  CGFloat(integerLiteral: req_loc["height"]!)
            return location
            
        }
        return nil
    }
    
    public func setMessageListener(_ listner: (([AnyHashable : Any]?) -> Void)?) {
        self.messageListner = listner
    }
    
    private func initBackend(url:String){
        let queue1 = DispatchQueue(label: "run_gstreamer")
        queue1.async{ [weak self] in
            self?.backend?.run_app_pipeline_threaded(url)
        }
    }
    
    private func appMovedToBackground() {
        print("App moved to background!")
        pause()
    }
    private func appWillMoveToForeground() {
        print("App will move to Foreground!")
        play()
    }
    private func play() {
        self.backend?.play()
    }
    
    private func pause() {
        self.backend?.pause()
    }
 
}

extension VideoStreamingManager: GStreamerBackendDelegate {
    @objc  public func mediaSizeChanged(_ width: Int, height: Int) {
        print("mediaSizeChanged \(width).....\(height)")
    
    }
    
    @objc  public func gstreamerInitialized() {
        print("INIT COMPLETED")
        DispatchQueue.main.async { [weak self] in
            if let view = self?.streamingView{
                UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(view)
                self?.initialize = true
            }
        }
    }
    
    
    @objc public func gstreamerSetUIMessage(_ message: String) {
        if let stateValue = message.components(separatedBy: "\n").last,let value = Int(stateValue) {
            DispatchQueue.main.async { [weak self] in
                let videoState = VideoPlayerState(rawValue: value)
                if let streamingStatus = videoState?.streamingStatus{
                    self?.messageListner?(["status":streamingStatus,"statusCode":0,"location":self?.streamingView?.frame as Any]
                    )
                }
            }
        }
        play()
    }
    
}



