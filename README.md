# 📞 POPIPOPI: 진화하는 보이스피싱에 맞서는 실시간 맞춤 대응

##  프로젝트 소개
> **한 줄 요약**: 통화 내용을 실시간으로 STT → 탐지(분류기) → 법률·기관 근거 RAG → 행동 가이드까지 안내하는 보이스피싱 대응 플랫폼.


https://github.com/user-attachments/assets/7b4c78bf-8605-47c3-a49d-f3bfa738c906

<div align="center">

[![Python](https://img.shields.io/badge/Python-3.10%2B-blue)](#) [![Android](https://img.shields.io/badge/Android-8.0%2B-green)](#) [![License-MIT](https://img.shields.io/badge/License-MIT-yellow)](#license)
[![Model](https://img.shields.io/badge/NLP-KLUE--RoBERTa%20%7C%20KoBERT%20%7C%20ALBERT%20%7C%20DistilKoBERT-orange)](#%EF%B8%8F-%EB%AA%A8%EB%8D%B8-models) [![LLM](https://img.shields.io/badge/LLM-Qwen2.5--3B%20%7C%20Gemma--3--4B-ff69b4)](#-llm--rag)

</div>

---

## 📚 목차

* [✨ 핵심 기능](#-핵심-기능)
* [🧱 아키텍처](#-아키텍처)
* [🗂 데이터셋](#-데이터셋)
* [🧠️ 모델 (Models)](#%EF%B8%8F-%EB%AA%A8%EB%8D%B8-models)
* [🧩 LLM & RAG](#-llm--rag)
* [🧪 평가 & 벤치마크](#-평가--벤치마크)
* [📎 참고 문헌](#-참고-문헌)

---

## ✨ 핵심 기능

* **실시간 탐지**: 음성인식 → STT → 문장 단위 분류(정상/의심 + 위험도 점수).
* **근거 제시**: 헌법·형사소송법·금융기관 가이드 등 RAG로 **왜 보이스피싱인지**를 즉시 설명.
* **대응 가이드**: 상황별 **즉시 행동 가이드**(통화 종료/대표번호 재확인/신고 등) 제공.
* **시각화**: 위험도(0–100) 타임라인, 의심 키워드 하이라이팅.

> 기존 통신사 솔루션의 **탐지 중심 한계**를 넘어, **탐지 → 근거 → 대응**까지 **완전한 보호 흐름** 제공.

---

## 🧱 아키텍처

<img width="1200" height="800" alt="image" src="https://github.com/user-attachments/assets/3efa6736-369c-47a2-90d4-31769b47c73a" />


**파이프라인**

1. **STT**: 통화 음성 스트리밍 → 텍스트 변환
2. **탐지(Detection)**: RoBERTa 기반 분류기 → 보이스피싱 확률 산출
3. **RAG 검색**: 법령·기관 문서 임베딩/검색 → reranking(K=2)
4. **LLM 분석**: 근거 기반 설명 생성(환각 억제)
5. **가이드**: 즉시 행동 지침 & 대표번호 재확인/신고 플로우

---

## 🗂 데이터셋

<img width="1200" height="800" alt="image" src="https://github.com/user-attachments/assets/ca03c3bc-cb57-42c3-9449-ee008968af1d" />

* **정상 대화**

  * GitHub **KorCCVi** 일상 대화
  * AI-Hub **콜센터 금융상담**
  * GPT 기반 **공공기관 정상 대화** 생성(검증·필터링 포함)

* **보이스피싱**

  * GitHub **KorCCVi** 보이스피싱 대화
  * 금융감독원 **그놈목소리**(mp3 → 텍스트화)

* **라벨링 버전**

  * **ver.0**: 이진(정상=0/피싱=1)
  * **ver.1**: **키워드 라벨링**(의심 단어 하이라이트)
  * **ver.2**: **분석문 라벨링**(왜 위험한지 근거 요약)
---

## 🧠️ 모델 (Models)

### 분류기 (Detection)

* 베이스: **KLUE‑RoBERTa / KoBERT / ALBERT / DistilKoBERT** 비교
* 출력: 보이스피싱 확률(0–1), 의심 키워드(옵션)
* 온디바이스/저지연을 위한 **경량화**(KD/Pruning/Quant, QLoRA) 적용


**경량화 실험(요약)**

* KD(Student) 기준 **Latency 3× 개선**, **GPU 메모리 79% 절감**, Acc/F1 **95%+ 유지**
<img width="805" height="413" alt="image" src="https://github.com/user-attachments/assets/f2d81329-2700-42f4-a295-482f4686a4dd" />


---

## 🧩 LLM & RAG

### 목표

* **환각 억제**와 **법령·기관 근거 기반 설명형 응답**

### 선택 모델

* **Qwen2.5‑3B‑Instruct**, **Gemma‑3‑4B‑IT** (분석형 파인튜닝)

### 파인튜닝 포인트

* **Keyword 기반** → 모호/불안정
* **Analysis 기반** → 맥락 비교·근거 제시에 유리 (최종 선정: **Qwen‑Analysis**)

### RAG 프로세스

1. **Docs**: 헌법/형사소송법/금융기관 가이드(예: 국민은행 10계명)
2. **Embedding & VDB**: 문서 임베딩 → Vector DB 저장
3. **1st Retriever**: Top‑10 후보
4. **Reranker**: 문맥 적합도 재정렬 → Top‑K(2)
5. **LLM 합성**: 근거 포함 요약/설명 생성

**프롬프트 프레임(Zero‑shot 예시)**

<details>
<summary>펼치기</summary>

```text
# 역할
너는 보이스피싱 탐지 AI 전문가다. 통화 내용의 표현/맥락을 분석해 위험도를 판단하고,
정상 절차/법적 근거와 비교해 왜 비정상인지 한 문장으로 설명하라.

# 분석 단계
1) 화자 신분 2) 긴급성/위협 3) 요구사항 4) 비상식적 유도 → 종합

# 출력 형식
- 분석 과정: (1)~(4)
- 요약: 핵심 근거 2–3문장
```

</details>

---

## 🧪 평가 & 벤치마크

**LLM 파인튜닝 전/후(요약)**

* 파인튜닝 전: 일반 설명 위주, 맥락 대응 미흡
* **Analysis 기반 파인튜닝 후**: 상황 적합성·안정성 향상 (Qwen‑Analysis 우수)

**LLM 지연/메모리(예)**

| 모델                          | Latency (ms/sample) |   Params |    GPU Mem |
| --------------------------- | ------------------: | -------: | ---------: |
| Qwen2.5‑3B                  |              12,335 |     3.1B |     3.9 GB |
| **Qwen2.5‑1.5B (KD+QLoRA)** |           **4,824** | **1.6B** | **2.4 GB** |

<img width="769" height="414" alt="image" src="https://github.com/user-attachments/assets/fff98eb5-b6dc-41a4-85e0-3bf464559d41" />

---

## 📎 참고 문헌

1. Lu, Y. et al., *Fantastically Ordered Prompts and Where to Find Them* (2021).
2. Xie, S. M. et al., *In-Context Learning as Implicit Bayesian Inference* (2021).
3. Sanh, V. et al., *T0: Multitask Prompted Training Enables Zero‑Shot Task Generalization* (2021).

---

## ETC
- ⏳ 기간: 2025년 7월 28일 ~ 8월 27일
- 🔗 보고서 링크: https://complete-margin-475.notion.site/25b9761f2ffc802fb2c1d87135ffb1f8?source=copy_link
- 📊 PPT 링크: https://www.canva.com/design/DAGwT84bQpM/BJL5R8ba0e6PSUwtWgvFrw/view?utm_content=DAGwT84bQpM&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=h1688711fc3

## 👥 팀원 소개

<table align="center">
 <tr align="center">
     <td><B>김도현<B></td>
     <td><B>안예은<B></td>
     <td><B>이동록<B></td>
     <td><B>이보림<B></td>
     <td><B>이아림<B></td>
     <td><B>장유진<B></td>
 </tr>
 <tr align="center">
     <td>
         <a href="https://github.com/Dohyeonking">
            <img src="https://github.com/Dohyeonking.png" style="width: 100px">
         </a>
         <br>
         <a href="https://github.com/Dohyeonking"><B>Tech</B></a>
     </td>
     <td>
         <a href="https://github.com/yeeniahn">
         <img src="https://github.com/yeeniahn.png" style="width: 100px">
         </a>
         <br>
         <a href="https://github.com/yeeniahn"><B>Leader</B></a>
     </td>
     <td>
         <a href="https://github.com/qhfla0130">
         <img src="https://github.com/qhfla0130.png" style="width: 100px">
         </a>
         <br>
         <a href="https://github.com/qhfla0130"><B>Domain</B></a>
     </td>
     <td>
         <a href="https://github.com/leeodo2">
         <img src="https://github.com/leeodo2.png" style="width: 100px">
         </a>
         <br>
         <a href="https://github.com/leeodo2"><B>Presentation</B></a>
     </td>
     <td>
         <a href="https://github.com/arieum">
         <img src="https://github.com/arieum.png" style="width: 100px">
         </a>
         <br>
         <a href="https://github.com/arieum"><B>Tech</B></a>
     </td>
     <td>
         <a href="https://github.com/Winterrr-24">
         <img src="https://github.com/Winterrr-24.png" style="width: 100px">
         </a>
         <br>
         <a href="https://github.com/Winterrr-24"><B>Presentation</B></a>
     </td>
 </tr>
</table>
