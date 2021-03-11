# RxUpbit
RxSwift + 업비트 실시간 조회 구현

## 목표
- RxSwift를 이용해서 비동기 프로그래밍에 대해 알아보자.
- [업비트 API](https://docs.upbit.com/reference#%EC%A0%84%EC%B2%B4-%EA%B3%84%EC%A2%8C-%EC%A1%B0%ED%9A%8C)를 이용해서 웹소켓 통신에 대해 알아보자.
    - 레퍼런스: https://docs.upbit.com/reference
    - 소켓통신: https://docs.upbit.com/docs/upbit-quotation-websocket
- 개발기간: 4주 (21년 3월 1일 ~ 31일)

### 화면기획
- 참고앱: 주식, 업비트, 코인원, 고팍스

- 코인마켓 현황

<img src="https://user-images.githubusercontent.com/20768506/109131414-22f1be00-7796-11eb-94ca-0aabedee4388.PNG" width="33%"><img src="https://user-images.githubusercontent.com/20768506/109131428-24bb8180-7796-11eb-9454-e8664708b6af.PNG" width="33%"><img src="https://user-images.githubusercontent.com/20768506/109131429-25541800-7796-11eb-976e-7716e3564d09.PNG" width="33%">

<img src="https://user-images.githubusercontent.com/20768506/109131381-1bcab000-7796-11eb-88d8-65fa2bbbf9ed.PNG" width="33%"><img src="https://user-images.githubusercontent.com/20768506/109131401-208f6400-7796-11eb-9b42-cc429c3476b4.PNG" width="33%"><img src="https://user-images.githubusercontent.com/20768506/109131407-2127fa80-7796-11eb-8dc6-3c7d3880f3e2.PNG" width="33%">
<img src="https://user-images.githubusercontent.com/20768506/109131411-21c09100-7796-11eb-8e61-03dec4c66fe6.PNG" width="33%"><img src="https://user-images.githubusercontent.com/20768506/109131417-238a5480-7796-11eb-8bfb-6bded65ada75.PNG" width="33%">
<img src="https://user-images.githubusercontent.com/20768506/109131426-2422eb00-7796-11eb-999d-7107d25aa36f.PNG" width="33%">
<img src="https://user-images.githubusercontent.com/20768506/109131431-25ecae80-7796-11eb-99f3-327c318dc8aa.PNG" width="33%">


### 개발스펙
- 사용 라이브러리: RxSwift, RxCocoa, RxMoya, ReactorKit, RxStarscream?
- 아키텍처: MVVM? VIP? RIBs?

