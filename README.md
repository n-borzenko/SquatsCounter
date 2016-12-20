## Squats Counter

### Назначение

Приложение написано в рамках отборочного этапа Yandex Mobile Contest 2016.

Задача состояла в создании приложения для автоматического подсчета приседаний. По условию задачи, пользователь в течение одного дня делал несколько подходов, но выполнял один определенный тип упражнений. Каждый день при первом подходе пользователь выбирает тип приседний, причем для корректного распознавания движений допустимо было попросить пользователя сделать несколько тестовых приседаний.

Приложение соответствует условиям задачи, а также предоставляет возможность добавлять новые виды приседаний и отображать статистику по выполненным тренировкам.

### Характеристики

Поддержка iPhone с iOS 8.0+

В приложении используются:
- CoreData + NSFetchedResultsController
- CoreMotion

Необходимые библиотеки: 

- SwiftCharts (https://github.com/i-schuetz/SwiftCharts)
- Surge (https://github.com/mattt/Surge)

Установка и запуск из исходников:

```
git clone git@github.com:n-borzenko/SquatsCounter.git
cd SquatsCounter
pod install
open -a Xcode SquatsCounter.xcworkspace
```

Описание: http://nborzenko.ru/squats_counter

Скриншоты: 

<img src="http://nborzenko.ru/squats_counter/github/1.png" width="200">
<img src="http://nborzenko.ru/squats_counter/github/2.png" width="200">
<img src="http://nborzenko.ru/squats_counter/github/3.png" width="200">
<img src="http://nborzenko.ru/squats_counter/github/4.png" width="200">