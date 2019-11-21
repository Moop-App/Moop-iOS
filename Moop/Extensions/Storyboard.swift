//
//  Storyboard.swift
//  Moop
//
//  Created by kor45cw on 31/07/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import kor45cw_Extension

enum Storyboard: StoryboardName {
    case main
    case movie
    case setting
    case favorite
    
    var name: String {
        switch self {
        case .main: return "Main"
        case .movie: return "Movie"
        case .setting: return "Setting"
        case .favorite: return "Favorite"
        }
    }
}
