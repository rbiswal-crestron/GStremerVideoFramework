//
//  GStreamerStates.swift
//  CSMobileVideoStreaming
//
//  Created by Rakesh Kumar Biswal on 27/07/23.
//

import Foundation

enum VideoPlayerState:Int,CaseIterable {
    case VOIDSTATE = 0
    case IDLE =  1
    case READY =  2
    case PAUSED = 3
    case PLAYING = 4
    
    var streamingStatus:String{
        switch self{
        case .VOIDSTATE:
            return "VOID"
        case.IDLE:
            return "IDLE"
        case.READY:
            return "READY"
        case.PAUSED:
            return "PAUSED"
        case .PLAYING:
            return "STARTED"
        }
    }
}
