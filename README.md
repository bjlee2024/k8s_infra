# IaC_k8s


## main branch

aws terraform module 을 가지고 아래 아키텍쳐 구현

<img width="758" alt="image" src="https://github.com/user-attachments/assets/89bc2dfb-a971-4aef-a652-d77f42c36d67">

## modular branch

terraform 의 custom module 을 정의해서 아래 아키텍쳐 구현

<img width="839" alt="image" src="https://github.com/user-attachments/assets/b6ba4442-77e1-46f2-9c76-c058afe6566e">


## 구현 차이에 대한 의견

aws 에서 제공하는 module 의 경우 자동 생성되는 부분이 상당히 많아서, 

해당 모듈을 사용하면서 내부 뭘 생성해야하고 뭘 생성하면 안되는지,.. 등 깊이 있는 이해를 바탕으로 사용해야 함
만약 능숙하지 못한 사람이 사용하면 추후에 재앙으로 다가 올 수 있음

전문가가 되기 전까지는 자신이 직접 필요에 따라 module 을 만들어 보기는 권장함



## 상세 아키텍쳐 설명
https://meditcompany.atlassian.net/wiki/x/6gCrCw
