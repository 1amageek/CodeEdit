//
//  CodeEditWindowController.swift
//  CodeEdit
//
//  Created by Pavel Kasila on 18.03.22.
//

import Cocoa
import SwiftUI
import CodeFile
import Overlays

class CodeEditWindowController: NSWindowController {

    var workspace: WorkspaceDocument?

    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's
        // window has been loaded from its nib file.
    }

    private func getSelectedCodeFile() -> CodeFileDocument? {
        guard let id = workspace?.selectedId else { return nil }
        guard let item = workspace?.openFileItems.first(where: { item in
            return item.id == id
        }) else { return nil }
        guard let file = workspace?.openedCodeFiles[item] else { return nil }
        return file
    }

    @IBAction func saveDocument(_ sender: Any) {
        getSelectedCodeFile()?.save(sender)
    }

    @IBAction func openQuickly(_ sender: Any) {
        if let workspace = workspace, let state = workspace.quickOpenState {
            if let window = window?.childWindows?.filter({ window in
                return (window.contentView as? NSHostingView<QuickOpenView>) != nil
            }).first {
                window.close()
                return
            }

            let panel = OverlayPanel()
            let contentView = QuickOpenView(state: state) {
                panel.close()
            }
            panel.contentView = NSHostingView(rootView: contentView)
            window?.addChildWindow(panel, ordered: .above)
            panel.makeKeyAndOrderFront(self)
        }
    }
}
