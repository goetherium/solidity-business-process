# solidity-business-process
Реализация произвольного бизнес процесса

Объектом любого бизнес-процесса является обращение (в смарт-контракте это incident).
Организации имеют сотрудников.
Один смарт-контракт может создать любое кол-во бизнес-процессов, в котором участвуют одни и те же организации и сотрудники. Т.о. справочник организаций и справочник сотрудников является общим для всех бизнес процессов.
Также общим для всех бизнес процессов являются справочники ролей и действий.
Для каждого бизнес процесса свой справочник соответствий:
•	Сотрудник – роль, при этом подразумевается, что в конкретном бизнес процессе сотрудник может выполнять только одну роль. Если у сотрудника ещё одна роль, значит это другой бизнес процесс. Например, описанный в задании бизнес процесс обращения в тех. поддержку на действии консультации разработчика может породить независимый бизнес процесс обращения к вендору ПО, в котором разработчик будет выступать уже как клиент своей организации по отношению к организации-вендора (в контракте есть такой пример)
•	Роль и соответствующие ей действия.
Для каждого действия, выполняемого в ходе решения обращения, создаётся запись в истории, которая в т.ч. хранит хеш файла.

Правила доступа к записи истории решения конкретного обращения:
1) сотрудник может прочитать любую запись в истории решения любого обращения, сделанную любым сотрудником с той же ролью, в т.ч. и хеш файла, хранящийся в записи истории;
2) если сотруднику назначено на выполнение действие, то запись в истории по данному действию может прочитать любой сотрудник с той же ролью. 
Другими словами, у запрашивающего файл сотрудника д.б. роль отправителя или получателя сообщения.
Пример: разработчики видят файлы в обращениях к ним и свои ответы.
Данные правила позволяют продолжать выполнять сотрудниками действия в бизнес процессе, несмотря на отсутствие исполнителей, непосредственно зарегистрированных в истории. Например, специалисты 1й линии тех.поддержки работают посменно и не важно, на какого сотрудника изначально было зарегистрировано обращение. Также, если разработчик в отпуске, то ответ специалисту 2й линии тех. поддержки может дать любой другой разработчик с соотв. ролью.

В задании приведена диаграмма и описание бизнес процесса. Описание упрощает диаграмму (нет сотрудника первой линии поддержки в организации, отвечающей за решение проблемы).
Для примера смарт-контракта, реализующего данный бизнес процесс, взято именно описание, т.к. указанное упрощение несущественно.

Реализованы операции с инцидентами:
•	Регистрация
•	Добавления действия в историю
•	Решение инцидента
•	Получение данных инцидента (без истории и файлов)
• Получение списка идентификаторов записей истории для дальнейшего итерирования по истории решения инцидента.
•	Получение записи из истории решения инцидента с проверкой прав доступа запросившего сотрудника

Замечание по создание смарт-контракта.
В виртуальной машине Remix создание потребовало свыше 3млн. газа, нужно задать соотв. gas limit перед выполнением деплоинга.


В файле BPTechSupport.sol реализован смарт-контракт с двумя бизнесс-процессами:
1. Бизнес-процесс обращения клиентов банка в тех.поддержку поставщика услуг
2. Бизнес-процесс обращения в тех. поддержку вендора ПО. Этот процесс инциируется разработчиком из первого бизнес-процесса, который будет выступать клиентом для вендора.
Организации и сотрудники в данном контракте создаются только для удобства тестирования в Remix. В реальном контракте это нужно вынести во внешний тестирующий контракт или выполнять внешние вызовы к предварительно созданному в блокчейне контракту.
