//
//  HTMLParser.swift
//  Divemeets-Parser
//
//  Created by Spencer Dearman on 3/3/23.
//

import SwiftSoup
import Foundation

final class HTMLParser{
    func parse(html: String) {
        do {
            let document: Document = try SwiftSoup.parse(html)
            guard let body = document.body() else {
                return
            }
            let main = try body.getElementsByTag("body").compactMap({try? $0.html()})
            let html = main[0]
            print(html)
        }
        catch {
            print("Error Parsing: " + String(describing: error))
        }
    }
}
