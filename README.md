# FastAPI Web Single Pattern
- 목적 : FastAPI를 사용해 Web Single 패턴을 구현합니다
- 상황 : 데이터 과학자가 model.py을 만들었고(model.joblib이 학습 결과), 그 model을 FastAPI을 사용해 Online Serving을 구현해야 함
  - model.py는 추후에 수정될 수 있으므로, model.py를 수정하지 않음(데이터 과학자쪽에서 수정)

# 시작하기 전에
- 여러분들이라면 어떻게 시작할까? 어떻게 설계할까? -> 잠깐이라도 생각해보기
  - 여러분들의 생각과 제가 말하는 것을 비교 -> Diff -> 이 Diff가 왜 생겼는가?

# FastAPI 개발
- FastAPI를 개발한 때의 흐름
- 전체 구조를 생각 -> 파일, 풀더 구조를 어떻게 할까?
  - predict.py, api.py, config.py
  - 계층화 아키텍처 : 3 tier, 4 tier layer
  - Presentation(API) <-> Application(Service) <-> Database
- API : 외부와 통신. 건물의 문처럼 외부 경로, 클라이언트에서 APT 호출. 학습 결과 Return
  - schema : FastAPT에서 사용되는 개념
    - 자바의 DTo(Data Transfer Object)와 비슷한 개념. 네트위크를 통해 데이터를 주고 받을 때, 어떤 형태로 주고 반울지 정의
  - 예측(Request, Response)
  - Pydantic의 Basemodel을 사용해서 정의. Request, Response에 맞게 정의. Payload
- Application : 실제 로직. 머신러닝 모델이(딥러닝 모델이) 예측/추톤.
- Database : 데이터를 어딘가 저장하고, 데이터를 가지고 오면서 활용
- Contiq : 프로젝트의 설정 파일(Config)을 저장
- 역순으로 개발

# 구현해야 하는 기능
## TODO Tree 소개
- TODO Tree 확장 프로그램 설치
- [ ] : 해야할 것
- [x] : 완료
- FIXME : FIXME

# 기능 구현
- [x] : FastAPI 서버 만들기
  - [x] : POST /predict : 예측을 진행한 후(PredictionRequest), PredictionResponse 반환
    - [x] : Response를 저장, CSV, JSON. 데이터베이스에 저장(SQLModel)
  - [x] : GET /predict : 데이터베이스에 저장된 모든 PredictionResponse 반환
  - [x] : GET /predict/{id}: id로 필터링해서, 해당 id에 맞는 PredictionResponse 반환
- [x] : FastAPI가 띄워질 때, Model Load -> lifespan
- [x] : DB 객체 만들기
- [x] : Config 설정

# 참고
- 데이터베이스는 SQLite3, 라이브러리는 SQLModel 사용

# SQLModel
- FastAPI를 만든 사람이 Python ORM(Object Relationship Mapping) : 객체 -> Database
- 데이터베이스 = 테이블에 데이터를 저장하고 불러올 수 있음
- Session : 데이터베이스의 연결을 관리하는 방식
  - 외식. 음식점에 가서 나올 때까지를 하나의 Session으로 표현. Session 안에서 가게 입장, 주문, 식사
  - Session 내에서 데이터를 추가, 조회, 수정할 수 있다! -> POST / GET / PATCH
  - Transaction: 세션 내에 일어나는 모든 활동. 트랜잭션이 완료되면 결과가 데이터베이스에 저장됨

## 코드 예시
```
SQLModel.metadata.create_all(engine): SQLModel로 정의된 모델(테이블)을 데이터베이스에 생성
- 처음에 init할 때 테이블을 생성!
```

```
with Session(engine) as session:
  ...
  # 테이블에 어떤 데이터를 추가하고 싶은 경우
  result = ''
  session.add(result) # 새로운 객체를 세션에 추가. 아직 DB에 저장되지 않았음
  session.commit() # 세션의 변경 사항을 DB에 저장
  session.refresh(result) # 세션에 있는 객체를 업데이트

  # 테이블에서 id를 기준으로 가져오고 싶은 경우
  session.get(DB model, id)

  # 테이블에서 쿼리를 하고 싶은 경우
  session.query(DB model).all() # 모든 값을 가져옴
```

# SQLite3
- 가볍게 사용할 수 있는 데이터베이스. 프러덕션 용도가 아닌 학습용

# 현업에서 더 고려해야 하는 부분
- Dev, Prod 구분에 따라 어떻게 구현할 것인가?
- Data Input / Output 고려
- Database -> Cloud Database(AWS Aurora, GCP Cloud SQL)
- API 서버 모니터링
- API 부하 테스트
- Test Code