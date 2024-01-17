//
//  Screen.swift
//
//
//  Created by Alexey Govorovsky on 05.05.2022.
//  https://github.com/Cantallops/Lighterpack/blob/main/Frameworks/DesignSystem/Sources/DesignSystem/Screen.swift

import SwiftUI
//TODO: merge log with https://github.com/chrisaljoudi/swift-log-oslog
//import os.log
import Logging

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let ui = Logger(label: "UI") //Logger(subsystem: subsystem, category: "UI")
}


public protocol Screen: View {
    associatedtype Content : View
    @ViewBuilder var content: Self.Content { get }
}

public extension Screen {
    
    var body: some View {
        content
            .onAppear {
                Logger.ui.info("▫️ Screen \(type(of: self)) appeared")
            }
            .onDisappear {
                Logger.ui.info("◾️ Screen \(type(of: self)) disappeared")
            }
    }
}

public struct AliveScreen : Screen {
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State var t = 0
    let text: String
    
    public var content: some View {
        Text(text)
            .onAppear {
                timer = Timer.publish(every: 1, on: .main, in: .common)
                _ = timer.connect()
            }
            .onDisappear {
                timer.connect().cancel()
            }
            .onReceive(timer) { _ in
                t += 1
                Logger.ui.info("▫️ Screen \(type(of: self)) alive for \(t)")
            }
    }
}
