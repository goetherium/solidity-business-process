// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import "./IncidentManagment.sol";

/**
 * @title Deploying business process of technical support
 * @author Lukyantsev Dmitry
 * @notice This is a test example only
 */
contract BPTechSupport is IncidentManagment {
    // Бизнес-процесс обращения в тех.поддержку поставщика услуг
    uint constant BP_TS_ID = 1;
    // Другой бизнес-процесс обращения в тех. поддержку вендора
    // Этот процесс инциируется разработчиком из первого бизнес-процесса,
    // который будет выступать клиентом для вендора
    uint constant BP_VENDOR_ID = 2;

    // Роли
    uint constant ROLE_CLIENT_ID = 1;  // Клиент
    uint constant ROLE_SPECIALIST_ID = 2;  // Специалист
    uint constant ROLE_DEVELOPER_ID = 3;  // Разработчик

    // Действия
    uint constant ACT_REG_ID = 1;  // Регистрация обращения
    uint constant ACT_NOTIFY_CLIENT_ID = 3;  // Уведомление клиента о решении проблемы
    uint constant ACT_DEV_REQ_ID = 4;  // Запрос консультации разработчика
    uint constant ACT_DEV_RESP_ID = 5; // Консультация разработчика - ответ специалисту 2-ой линии
    uint constant ACT_REPROCESS_ID = 6;  // Клиент отправляет обращение на повторную обработку
    uint constant ACT_RESOLVE_ID = 7;  // Проблема решена, клиент завершает бизнес-процесс

    // !!! Организации и сотрудники в данном контракте только для удобства
    // тестирования в Remix. В реальном контракте это нужно вынести во внешний
    // тестирующий контракт или выполнять внешние вызовы

    // Организация, зарегистрировавшая обращение
    uint constant SBERBANK = 1;
    // Клиент этой организации
    uint constant EMPL_CLIENT_ID = 1;        // Клиент 1
    uint constant EMPL_CLIENT_2_ID = 2;      // Клиент 2
    
    // Организация, отвечающая за решение проблемы
    uint constant FINTECH = 2;
    uint constant EMPL_SPECIALIST_ID = 3;    // Специалист 1
    uint constant EMPL_SPECIALIST_2_ID = 4;  // Специалист 2
    uint constant EMPL_DEVELOPER_ID = 5;     // Разработчик 1
    uint constant EMPL_DEVELOPER_2_ID = 6;    // Разработчик 1

    // Организация - вендор
    uint constant FORS = 3;
    uint constant EMPL_VENDOR_SPECIALIST_ID = 7;    // Специалист вендора
    uint constant EMPL_VENDOR_DEVELOPER_ID = 8;     // Разработчик вендора

    // Тестовые инциденты
    uint constant INCIDENT_1_ID = 1;
    uint constant INCIDENT_2_ID = 2;
    uint constant INCIDENT_3_ID = 3;


    constructor() {
        addBP(
            BP_TS_ID, 
            unicode"Бизнес-процесс тех. поддержки"
        );
        
        // Справочник ролей
        addRole(
            ROLE_CLIENT_ID, 
            unicode"Клиент"
        );
        addRole(
            ROLE_SPECIALIST_ID, 
            unicode"Специалист"
        );
        addRole(
            ROLE_DEVELOPER_ID, 
            unicode"Разработчик"
        );
        
        // Справочник действий
        addAction(
            ACT_REG_ID,
            unicode"Регистрация обращения"
        );
        addAction(
            ACT_NOTIFY_CLIENT_ID,
            unicode"Уведомление клиента о решении проблемы"
        );
        addAction(
            ACT_DEV_REQ_ID,
            unicode"Запрос консультации разработчика"
        );
        addAction(
            ACT_DEV_RESP_ID,
            unicode"Консультация разработчика - ответ специалисту 2-ой линии"
        );
        addAction(
            ACT_REPROCESS_ID,
            unicode"Клиент отправляет обращение на повторную обработку"
        );
        addAction(
            ACT_RESOLVE_ID,
            unicode"Проблема решена, клиент завершает бизнес-процесс"
        );
        
        // Назначение действий ролям в БП
        addRoleAction(BP_TS_ID, ROLE_CLIENT_ID, ACT_REG_ID);
        addRoleAction(BP_TS_ID, ROLE_CLIENT_ID, ACT_REPROCESS_ID);
        addRoleAction(BP_TS_ID, ROLE_CLIENT_ID, ACT_RESOLVE_ID);

        addRoleAction(BP_TS_ID, ROLE_SPECIALIST_ID, ACT_NOTIFY_CLIENT_ID);
        addRoleAction(BP_TS_ID, ROLE_SPECIALIST_ID, ACT_DEV_REQ_ID);

        addRoleAction(BP_TS_ID, ROLE_DEVELOPER_ID, ACT_DEV_RESP_ID);


        // !!! Всё что ниже в данном контракте только для удобства
        // тестирования в Remix. В реальном контракте это нужно вынести во внешний
        // тестирующий контракт или выполнять внешние вызовы

        /***** Организация - клиент *****/
        addOrg(
            SBERBANK, 
            unicode"Сбербанк",
            unicode"Банк"
        );
        addEmpl(
            EMPL_CLIENT_ID,
            SBERBANK, 
            unicode"Иванов Сергей",
            "ivanov@sberbank.ru"
        );
        addEmpl(
            EMPL_CLIENT_2_ID,
            SBERBANK, 
            unicode"Кутепов Артём",
            "kutepov@sberbank.ru"
        );

        /***** Организация, отвечающая за решение проблемы *****/
        addOrg(
            FINTECH, 
            unicode"ФинТех",
            unicode"Разработка блокчейна"
        );
        addEmpl(
            EMPL_SPECIALIST_ID,
            FINTECH, 
            unicode"Петров Евгений",
            "petrov@fintech.ru"
        );
        addEmpl(
            EMPL_SPECIALIST_2_ID,
            FINTECH, 
            unicode"Васечкин Пётр",
            "vasechkin@fintech.ru"
        );
        addEmpl(
            EMPL_DEVELOPER_ID,
            FINTECH, 
            unicode"Быстров Павел",
            "bistrov@fintech.ru"
        );
        addEmpl(
            EMPL_DEVELOPER_2_ID,
            FINTECH, 
            unicode"Умнов Алексей",
            "umnov@fintech.ru"
        );

        // Назначение в БП ролей сотрудникам
        addEmplRole(BP_TS_ID, EMPL_CLIENT_ID, ROLE_CLIENT_ID);
        addEmplRole(BP_TS_ID, EMPL_CLIENT_2_ID, ROLE_CLIENT_ID);

        addEmplRole(BP_TS_ID, EMPL_SPECIALIST_ID, ROLE_SPECIALIST_ID);
        addEmplRole(BP_TS_ID, EMPL_SPECIALIST_2_ID, ROLE_SPECIALIST_ID);

        addEmplRole(BP_TS_ID, EMPL_DEVELOPER_ID, ROLE_DEVELOPER_ID);
        addEmplRole(BP_TS_ID, EMPL_DEVELOPER_2_ID, ROLE_DEVELOPER_ID);


        // Клиент Сбербанка создает обращение в тех. поддержку ФинТеха
        regIncident(
            INCIDENT_1_ID,
            0,  // дата
            BP_TS_ID,
            ACT_REG_ID,
            SBERBANK,
            EMPL_CLIENT_ID,
            FINTECH,
            EMPL_SPECIALIST_ID,
            0x1234123412341234123412341234123412341234123412341234123412341234
        );
        // Специалист ФинТеха сообщает клиенту о решении
        addIncidentHistory(
            INCIDENT_1_ID,
            ACT_NOTIFY_CLIENT_ID,
            0,  // Дата
            EMPL_SPECIALIST_ID,
            EMPL_CLIENT_ID,
            0xffeeddccaabbccddeeffaabbccddeeffaabbccddeeffaabbccddeeffaabbccdd
        );
        // Клиент возвращает обращение на повторное выполнение
        addIncidentHistory(
            INCIDENT_1_ID,
            ACT_REPROCESS_ID,
            0,  // Дата
            EMPL_CLIENT_ID,
            EMPL_SPECIALIST_ID,
            0xffeeddccaabbccddeeffaabbccddeeffaabbccddeeffaabbccddeeffaabbccdd
        );
        // Специалист запрашивает консультацию разработчика
        addIncidentHistory(
            INCIDENT_1_ID,
            ACT_DEV_REQ_ID,
            0,  // Дата
            EMPL_SPECIALIST_ID,
            EMPL_DEVELOPER_ID,
            0xffeeddccaabbccddeeffaabbccddeeffaabbccddeeffaabbccddeeffaabbccdd
        );
        // Разработчик отвечает специалисту
        addIncidentHistory(
            INCIDENT_1_ID,
            ACT_DEV_RESP_ID,
            0,  // Дата
            EMPL_DEVELOPER_ID,
            EMPL_SPECIALIST_ID,
            0xffeeddccaabbccddeeffaabbccddeeffaabbccddeeffaabbccddeeffaabbccdd
        );
        // Специалист сообщает клиенту о решении
        addIncidentHistory(
            INCIDENT_1_ID,
            ACT_NOTIFY_CLIENT_ID,
            1,  // Дата
            EMPL_SPECIALIST_ID,
            EMPL_CLIENT_ID,
            0xffeeddccaabbccddeeffaabbccddeeffaabbccddeeffaabbccddeeffaabbccdd
        );
        // Клиент закрывает обращение
        resolveIncident(
            INCIDENT_1_ID,
            ACT_RESOLVE_ID,
            2,  // Дата
            EMPL_CLIENT_ID,
            EMPL_SPECIALIST_ID,
            0xffeeddccaabbccddeeffaabbccddeeffaabbccddeeffaabbccddeeffaabbccdd
        );

        

        // Зарегистрируем ещё инцидент для дальнейших тестов через вызовы в Remix
        regIncident(
            INCIDENT_2_ID,
            0,
            BP_TS_ID,
            ACT_REG_ID,
            SBERBANK,
            EMPL_CLIENT_2_ID,
            FINTECH,
            EMPL_SPECIALIST_2_ID,
            0xffeeddccaabbccddeeffaabbccddeeffaabbccddeeffaabbccddeeffaabbccdd
        );



        // Создадим ещё один бизнес-процесс обращения к вендору ПО
        // Этот процесс инциируется разработчиком из первого бизнес-процесса,
        // который будет выступать клиентом для вендора

        /***** Организация - вендор *****/
        addBP(BP_VENDOR_ID, "Vindor BP");
        // Назначение действий ролям в БП
        addRoleAction(BP_VENDOR_ID, ROLE_CLIENT_ID, ACT_REG_ID);
        addRoleAction(BP_VENDOR_ID, ROLE_CLIENT_ID, ACT_REPROCESS_ID);
        addRoleAction(BP_VENDOR_ID, ROLE_CLIENT_ID, ACT_RESOLVE_ID);

        addRoleAction(BP_VENDOR_ID, ROLE_SPECIALIST_ID, ACT_NOTIFY_CLIENT_ID);
        addRoleAction(BP_VENDOR_ID, ROLE_SPECIALIST_ID, ACT_DEV_REQ_ID);

        addRoleAction(BP_VENDOR_ID, ROLE_DEVELOPER_ID, ACT_DEV_RESP_ID);

        // Организация вендора
        addOrg(FORS, unicode"ООО Форс - центр разработки", unicode"Вендор");
        // Empl1
        addEmpl(
            EMPL_VENDOR_SPECIALIST_ID,
            FORS, 
            unicode"Форс - специалист",
            "empl1@fors.ru"
        );
        // Empl2
        addEmpl(
            EMPL_VENDOR_DEVELOPER_ID,
            FORS, 
            unicode"Форс - разработчик",
            "empl2@fors.ru"
        );

        // Назначение в БП ролей сотрудникам
        // Разработчик из первого БП - это клиент второго БП
        addEmplRole(BP_VENDOR_ID, EMPL_DEVELOPER_ID, ROLE_CLIENT_ID);
        addEmplRole(BP_VENDOR_ID, EMPL_DEVELOPER_2_ID, ROLE_CLIENT_ID);
        addEmplRole(BP_VENDOR_ID, EMPL_VENDOR_SPECIALIST_ID, ROLE_SPECIALIST_ID);
        addEmplRole(BP_VENDOR_ID, EMPL_VENDOR_DEVELOPER_ID, ROLE_DEVELOPER_ID);

        // Зарегистрируем инцидент у вендора:
        // Разработчик из первого БП для решения проблемы Сбербанка
        // создал заявку у вендора на доработку
        regIncident(
            INCIDENT_3_ID,
            0,
            BP_VENDOR_ID,
            ACT_REG_ID,
            FINTECH,
            EMPL_DEVELOPER_ID,
            FORS,
            EMPL_VENDOR_SPECIALIST_ID,
            0xfff4123412341234123412341234123412341234123412341234123412341234
        );

    }  // конструктор

}
