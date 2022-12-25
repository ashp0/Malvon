//
//  AXSidebarTabButton.swift
//  AXMalvon
//
//  Created by Ashwin Paudel on 2022-12-11.
//  Copyright © 2022 Aayam(X). All rights reserved.
//

import AppKit

class AXSidebarTabButton: NSButton, NSDraggingSource, NSPasteboardWriting, NSPasteboardReading {
    func writableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        return [NSPasteboard.PasteboardType("com.aayamx.malvon.tabButton")]
    }
    
    func pasteboardPropertyList(forType type: NSPasteboard.PasteboardType) -> Any? {
        // return "\(appProperties.window.windowNumber),\(self.tag)"
        return ""
    }
    
    static func readableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        return [NSPasteboard.PasteboardType("com.aayamx.malvon.tabButton")]
    }
    
    required init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
        super.init(frame: .zero)
        // if type == .init("com.aayamx.malvon.tabButton") {
        //  let value = propertyList as! String
        // }
    }
    
    static func readingOptions(forType type: NSPasteboard.PasteboardType, pasteboard: NSPasteboard) -> NSPasteboard.ReadingOptions {
        return .asString
    }
    
    let titleView = NSTextField(frame: .zero)
    
    // Drag and drop
    fileprivate var isDragging = false
    var dragOffset: CGFloat?
    var draggingView: NSImageView?
    
    var closeButton = AXHoverButton()
    
    var hoverColor: NSColor = NSColor.lightGray.withAlphaComponent(0.3)
    var selectedColor: NSColor = NSColor.lightGray.withAlphaComponent(0.6)
    
    var titleObserver: NSKeyValueObservation?
    var urlObserver: NSKeyValueObservation?
    
    weak var titleViewRightAnchor: NSLayoutConstraint?
    
    var tryingToCreateNewWindow: Bool = false
    
    unowned var appProperties: AXAppProperties!
    
    var isSelected: Bool = false {
        didSet {
            self.layer?.backgroundColor = isSelected ? selectedColor.cgColor : .clear
        }
    }
    
    var tabTitle: String = "Untitled" {
        didSet {
            titleView.stringValue = tabTitle
        }
    }
    
    var isMouseDown = false
    
    var trackingArea: NSTrackingArea!
    
    init(_ appProperties: AXAppProperties) {
        self.appProperties = appProperties
        super.init(frame: .zero)
        self.wantsLayer = true
        self.layer?.cornerRadius = 5
        self.isBordered = false
        self.bezelStyle = .shadowlessSquare
        self.layer?.borderColor = .white
        title = ""
        
        self.setTrackingArea()
        
        // Setup closeButton
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.target = self
        closeButton.action = #selector(closeTab)
        addSubview(closeButton)
        closeButton.image = NSImage(systemSymbolName: "xmark", accessibilityDescription: nil)
        closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
        closeButton.isHidden = true
        
        // Setup titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.isEditable = false // This should be set to true in a while :)
        titleView.alignment = .left
        titleView.isBordered = false
        titleView.usesSingleLineMode = true
        titleView.drawsBackground = false
        addSubview(titleView)
        titleView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        titleView.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
        titleViewRightAnchor = titleView.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: 20)
        titleViewRightAnchor?.isActive = true
    }
    
    public func stopObserving() {
        titleObserver?.invalidate()
        urlObserver?.invalidate()
    }
    
    public func startObserving() {
        titleObserver = self.appProperties.tabs[tag].view.observe(\.title, changeHandler: { [self] _, _ in
            appProperties.tabs[tag].title = appProperties.tabs[tag].view.title ?? "Untitled"
            tabTitle = appProperties.tabs[tag].title ?? "Untitled"
        })
        
        urlObserver = self.appProperties.tabs[tag].view.observe(\.url, changeHandler: { [self] _, _ in
            appProperties.tabs[tag].url = appProperties.tabs[tag].view.url
        })
    }
    
    @objc func closeTab() {
        appProperties.tabManager.removeTab(self.tag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTrackingArea() {
        let options: NSTrackingArea.Options = [.activeAlways, .inVisibleRect, .mouseEnteredAndExited, .enabledDuringMouseDrag]
        trackingArea = NSTrackingArea.init(rect: self.bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    
    override func mouseUp(with event: NSEvent) {
        self.isMouseDown = false
        layer?.backgroundColor = isSelected ? selectedColor.cgColor : .none
        
        if tryingToCreateNewWindow {
            let window = AXWindow(restoresTab: false)
            window.setFrameOrigin(.init(x: NSEvent.mouseLocation.x, y: NSEvent.mouseLocation.y))
            window.makeKeyAndOrderFront(nil)
            window.appProperties.tabs.append(appProperties.tabs[tag])
            appProperties.tabManager.tabMovedToNewWindow(tag)
            DispatchQueue.main.async {
                window.appProperties.tabManager.updateAll()
            }
        }
        
        isDragging = false
    }
    
    override func mouseEntered(with event: NSEvent) {
        titleViewRightAnchor?.constant = 0
        closeButton.isHidden = false
        
        if !isSelected {
            self.layer?.backgroundColor = self.isMouseDown ? selectedColor.cgColor : hoverColor.cgColor
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        if self.isMousePoint(self.convert(event.locationInWindow, from: nil), in: self.bounds) {
            sendAction(action, to: target)
        }
        self.isMouseDown = true
        self.layer?.backgroundColor = selectedColor.cgColor
    }
    
    override func mouseDragged(with event: NSEvent) {
        if !isDragging {
            let dragItem = NSDraggingItem(pasteboardWriter: self)
            dragItem.setDraggingFrame(self.bounds, contents: self.toImage())
            let draggingSession = self.beginDraggingSession(with: [dragItem], event: event, source: self)
            draggingSession.animatesToStartingPositionsOnCancelOrFail = true
            isHidden = true
        }
    }
    
    override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        isDragging = false
        isHidden = false
        closeButton.isHidden = false
    }
    
    override func mouseExited(with event: NSEvent) {
        titleViewRightAnchor?.constant = 20
        closeButton.isHidden = true
        self.layer?.backgroundColor = isSelected ? selectedColor.cgColor : .none
    }
    
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return .move
    }
    
    func draggingSession(_ session: NSDraggingSession, willBeginAt screenPoint: NSPoint) {
        dragOffset = self.frame.origin.x - screenPoint.x
        closeButton.isHidden = true
        let dragRect = self.bounds
        let image = NSImage(data: self.dataWithPDF(inside: dragRect))
        self.draggingView = NSImageView(frame: dragRect)
        if let draggingView = self.draggingView {
            draggingView.image = image
            draggingView.translatesAutoresizingMaskIntoConstraints = false
        }
        isDragging = true
        
        self.isHidden = true
    }
    
    func draggingSession(_ session: NSDraggingSession, movedTo screenPoint: NSPoint) {
        let offsetX = screenPoint.x - appProperties.window.frame.origin.x
        let offsetY = screenPoint.y - appProperties.window.frame.origin.y
        
        if offsetX <= appProperties.sidebarWidth && offsetX >= 0.0 && offsetY <= appProperties.sidebarView.scrollView.frame.height && offsetY >= 0.0 {
            let index = Int((offsetY - appProperties.sidebarView.scrollView.frame.size.height) / -31)
            if index <= appProperties.sidebarView.stackView.arrangedSubviews.count - 1 && index >= 0 {
                appProperties.tabManager.swapAt(self.tag, index)
            }
        } else {
            // TODO: Implement this
            // Also for splitview, maybe..
            //            print("View entered Outside, should create new window")
        }
    }
    
    func draggingSession(_ session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        self.isHidden = false
        let offsetX = screenPoint.x - appProperties.window.frame.origin.x
        let offsetY = screenPoint.y - appProperties.window.frame.origin.y
        
        if offsetX <= appProperties.sidebarWidth && offsetX >= 0.0 && offsetY <= appProperties.sidebarView.scrollView.frame.height && offsetY >= 0.0 {
            let index = Int((offsetY - appProperties.sidebarView.scrollView.frame.size.height) / -31)
            if index <= appProperties.sidebarView.stackView.arrangedSubviews.count - 1 && index >= 0 {
                appProperties.tabManager.swapAt(self.tag, index)
            }
        }
        
        isDragging = false
    }
}

extension NSView {
    func toImage() -> NSImage? {
        guard let bitmapImageRepresentation = self.bitmapImageRepForCachingDisplay(in: bounds) else {
            return nil
        }
        bitmapImageRepresentation.size = bounds.size
        self.cacheDisplay(in: bounds, to: bitmapImageRepresentation)
        
        let image = NSImage(size: bounds.size)
        image.addRepresentation(bitmapImageRepresentation)
        
        return image
    }
}