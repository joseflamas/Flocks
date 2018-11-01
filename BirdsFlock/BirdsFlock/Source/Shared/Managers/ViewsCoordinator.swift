//
//  GuiManager.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/21/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation
import UIKit


/// Graphical User Interface Manager
/// - comment:   Acts as Views and Views Controllers Coordinator
///              Handles push, pops, presentation, styling, etc
///              Initialized by the Application Manager
final class ViewsCoordinator {
    
    // Components
    private(set) var mainWindow               : UIWindow!
    private(set) var mainViewController       : UIViewController!
    private(set) var mainNavigationController : UINavigationController!
    private(set) var currentMainView          : UIView!
    
    // Styling - Navigation Controller
    let navigationBarsBackgroundColor : UIColor = .black
    let navigationBarsTextColor       : UIColor = .red
    // Styling - Views
    let viewsBackgroundColor          : UIColor = .black
    
    // Initializers
    init(){
        print("Initializing Views Coordinator ...")
        setInitalWindow()
        
    }
    
}

 
// MARK: - UIWindows
extension ViewsCoordinator {

    /// Used in the application delagete to set the main windoe and root navigation controller
    private func setInitalWindow() {
        mainWindow               = UIWindow(frame: UIScreen.main.bounds)
        mainViewController       = FlocksExplorerViewController(nibName: "FlocksExplorerViewController",
                                                                bundle: .main)
        mainViewController.title = TEXT_APPLICATIONNAME
        mainNavigationController = UINavigationController(rootViewController: mainViewController)
        // Styling
        setStyleForNavigationController(mainNavigationController)

    }
    
    /// Used only when application loads
    ///
    /// - Returns: returns the initial window
    public func getInitialWindow() -> UIWindow {
        mainWindow.rootViewController = mainNavigationController
        return mainWindow
        
    }
    
    /// Convenience access to the main window
    ///
    /// - Returns: current main window
    public func getmainWindow() -> UIWindow {
        return mainWindow
        
    }
    
}

/// MARK: - UIViewController
extension ViewsCoordinator {
    
    /// Pushes a view controller
    ///
    /// - Parameter aViewController: the view controller to push
    public func pushViewController(_ aViewController: UIViewController){
        mainNavigationController.isNavigationBarHidden = false
        mainNavigationController.pushViewController(aViewController, animated: true)
        
    }
    
    /// Pops the current view controller
    public func popViewController(){
        mainNavigationController.popViewController(animated: true)
        
    }
    
    /// Presents a view controller
    ///
    /// - Parameter aViewController: the view controller to present
    /// - comment: Apple discurages presenting a view controllers on detached view controllers
    ///            but is still useful for alerts
    public func presentViewController(_ aViewController: UIViewController){
        mainWindow.rootViewController?.present(aViewController, animated: true, completion: nil)
        
    }

}

/// MARK: - Alerts
extension ViewsCoordinator {
    
    /// Presents a standard alert to the user
    ///
    /// - Parameters:
    ///   - aTitle: Title of the alert
    ///   - aMessage: description of the problem
    public func showAlert(withTitle aTitle: String, andMessage aMessage: String){
        let alert = UIAlertController(title: aTitle,
                                      message: aMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        presentViewController(alert)
        
    }
    
    /// Presents an alert to the user outside the standard alert
    ///
    /// - Parameter someAlert: alert controller
    public func showAlert(alert someAlert: UIAlertController){
        presentViewController(someAlert)
        
    }
    
}


/// MARK: - Default Styling
extension ViewsCoordinator {
    
    /// Sets navigation controller style
    ///
    /// - Parameters:
    ///   - aNavigationController: a navigation controller
    ///   - hide: option to hide or show, false by default
    public func setStyleForNavigationController(_ aNavigationController: UINavigationController,
                                                hide: Bool = false){
        aNavigationController.isNavigationBarHidden = hide
        setStyleForNavigationControllerBar(aNavigationController.navigationBar)
        
    }
    
    /// Sets Navigation car style
    ///
    /// - Parameter aNavigationBar: the navigation bar to style
    public func setStyleForNavigationControllerBar(_ aNavigationBar: UINavigationBar){
        let textAttributes = [NSAttributedString.Key.foregroundColor:navigationBarsTextColor]
        aNavigationBar.barTintColor        = navigationBarsBackgroundColor
        aNavigationBar.titleTextAttributes = textAttributes
        
    }
    
    /// Sets buttons style
    ///
    /// - Parameter buttonItems: a button
    public func setStyleForBarButtonItems(_ buttonItems:[UIBarButtonItem]){
        for buttonItem in buttonItems{
            buttonItem.tintColor           = navigationBarsTextColor
        
        }
        
    }
    
    /// Sets a defailt style for a view
    ///
    /// - Parameter aView: a view to style
    public func setStyleForView(_ aView:UIView){
        aView.backgroundColor = viewsBackgroundColor
        
    }
    
}
