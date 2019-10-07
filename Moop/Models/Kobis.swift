//
//  Kobis.swift
//  Moop
//
//  Created by kor45cw on 07/10/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

/**
* @param genres 장르
* @param nations 국가
* @param companys 배급사/제작사
* @param directors 감독
* @param actors 배우
* @param showTm 상영시간 (분)
* @param boxOffice 박스오피스 정보
*/
struct Kobis: Decodable {
    let genres: [String]?
    let nations: [String]?
    let companys: [Company]?
    let directors: [String]?
    let showTm: Int
    let actors: [Actor]?
    let boxOffice: BoxOffice?
}

/**
* @param companyNm 회사 (이름)
* @param companyPartNm 회사 (역할)
*/
struct Company: Decodable {
    let companyNm: String
    let companyPartNm: String
}


/**
* @param peopleNm 배우 (이름)
* @param cast 배우 (역할)
*/
struct Actor: Decodable {
    let peopleNm: String
    let cast: String
}

/**
* @param rank 전일 순위
* @param audiCnt 전일 관객수
* @param audiAcc 누적 관객수
*/
struct BoxOffice: Decodable {
    let rank: Int
    let audiCnt: Int
    let audiAcc: Int
}
