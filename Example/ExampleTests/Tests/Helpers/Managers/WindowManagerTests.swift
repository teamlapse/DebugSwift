//
//  WindowManagerTests.swift
//  DebugSwift
//
//  Created by Matheus Gois on 15/12/2024.
//

@testable import DebugSwift
import Testing
import UIKit

struct WindowManagerTests {

    @Test("Present debugger when not showing")
    @MainActor
    func presentDebuggerWhenNotShowing() async {
        // Given
        let hostWindow = makeHostWindow()
        let mockViewController = UIViewController()
        FloatViewManager.isShowingDebuggerView = false
        defer {
            WindowManager.removeDebugger()
            hostWindow.isHidden = true
        }

        FloatViewManager.setup(mockViewController)

        // When
        WindowManager.presentDebugger()

        // Then
        #expect(FloatViewManager.isShowingDebuggerView == true)
        #expect(WindowManager.rootNavigation?.topViewController == mockViewController)
        #expect(WindowManager.window.isKeyWindow)
        #expect(WindowManager.window.windowLevel == hostWindow.windowLevel)

        WindowManager.removeDebugger()

        #expect(hostWindow.isKeyWindow)
        #expect(WindowManager.window.windowLevel == .alert + 1)
    }

    @Test("Present debugger when already showing")
    @MainActor
    func presentDebuggerWhenAlreadyShowing() async {
        // Given
        FloatViewManager.isShowingDebuggerView = true
        defer { FloatViewManager.isShowingDebuggerView = false }

        // When
        WindowManager.presentDebugger()

        // Then
        #expect(FloatViewManager.isShowingDebuggerView == true)
    }

    @Test("Remove debugger when not showing")
    @MainActor
    func removeDebuggerWhenNotShowing() async {
        // Given
        FloatViewManager.isShowingDebuggerView = false

        // When
        WindowManager.removeDebugger()

        // Then
        #expect(FloatViewManager.isShowingDebuggerView == false)
        #expect(WindowManager.window.windowLevel == .alert + 1)
    }

    @Test("Present view debugger when showing")
    @MainActor
    func presentViewDebuggerWhenShowing() async {
        // Given
        FloatViewManager.isShowingDebuggerView = true
        defer { FloatViewManager.isShowingDebuggerView = false }

        // When
        WindowManager.presentViewDebugger()

        // Then
        #expect(FloatViewManager.isShowingDebuggerView == true)
    }

    @Test("Remove view debugger when showing")
    @MainActor
    func removeViewDebuggerWhenShowing() async {
        // Given
        FloatViewManager.isShowingDebuggerView = true

        // When
        WindowManager.removeViewDebugger()

        // Then
        #expect(FloatViewManager.isShowingDebuggerView == false)
    }

    @MainActor
    private func makeHostWindow() -> UIWindow {
        let hostWindow: UIWindow
        if let scene = WindowManager.window.windowScene {
            hostWindow = UIWindow(windowScene: scene)
        } else {
            hostWindow = UIWindow(frame: UIScreen.main.bounds)
        }
        hostWindow.windowLevel = .normal
        hostWindow.rootViewController = UIViewController()
        hostWindow.makeKeyAndVisible()
        return hostWindow
    }
}
