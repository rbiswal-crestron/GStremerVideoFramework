//
//  GStreamerBackendInterface.swift
//  CSMobileVideoStreaming
//
//  Created by Rakesh Kumar Biswal on 23/07/23.
//

import Foundation

 protocol GStreamerBackendDelegate{
    func gstreamerInitialized()
    func gstreamerSetUIMessage(_ message: String)
    func mediaSizeChanged(_ width: Int, height: Int)
}


