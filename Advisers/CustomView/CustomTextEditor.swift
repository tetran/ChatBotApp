//
//  CustomTextEditor.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/21.
//

import SwiftUI
import AppKit

struct CustomTextEditor: NSViewRepresentable {
    @Binding var text: String
    
    var fontSize: CGFloat = 16
    
    let onCommandEnter: () -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: Context) -> NSTextView {
        let textView = NSTextView()
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateNSView(_ nsView: NSTextView, context: Context) {
        let currentText = nsView.string
        if currentText != text {
            nsView.string = text
            nsView.selectedRange = NSMakeRange(text.utf8.count, 0)  // カーソル位置固定
        }
        
//        if let font = context.environment.font {
//            nsView.font = NSFont.preferredFont(from: font)
//        }
        nsView.font = .systemFont(ofSize: fontSize)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = context.environment.lineSpacing
        nsView.defaultParagraphStyle = paragraphStyle
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: CustomTextEditor
        
        init(_ parent: CustomTextEditor) {
            self.parent = parent
        }
        
        func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            if let event = NSApp.currentEvent {
                if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == [.command] && event.keyCode == 36 {
                    parent.onCommandEnter()
                    return true
                }
            }
            return false
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
        }
    }
}

extension CustomTextEditor {
    func fontSize(_ size: CGFloat) -> CustomTextEditor {
        var view = self
        view.fontSize = size
        return view
    }
}
