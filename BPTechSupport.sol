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
        // Бизнес-процесс тех. поддержки
        addBP(
            BP_TS_ID, 
            "\xd0\x9e\xd0\xb1\xd1\x80\xd0\xb0\xd1\x89\xd0\xb5\xd0\xbd\xd0\xb8\xd0\xb5\x20\xd0\xb2\x20\xd1\x82\xd0\xb5\xd1\x85\x2e\x20\xd0\xbf\xd0\xbe\xd0\xb4\xd0\xb4\xd0\xb5\xd1\x80\xd0\xb6\xd0\xba\xd1\x83"
        );
        
        // Справочник ролей
        addRole(
            ROLE_CLIENT_ID, 
            "\xd0\x9a\xd0\xbb\xd0\xb8\xd0\xb5\xd0\xbd\xd1\x82"
        );
        addRole(
            ROLE_SPECIALIST_ID, 
            "\xd0\xa1\xd0\xbf\xd0\xb5\xd1\x86\xd0\xb8\xd0\xb0\xd0\xbb\xd0\xb8\xd1\x81\xd1\x82"
        );
        addRole(
            ROLE_DEVELOPER_ID, 
            "\xd0\xa0\xd0\xb0\xd0\xb7\xd1\x80\xd0\xb0\xd0\xb1\xd0\xbe\xd1\x82\xd1\x87\xd0\xb8\xd0\xba"
        );
        
        // Справочник действий
        addAction(
            ACT_REG_ID,
            "\xd0\xa0\xd0\xb5\xd0\xb3\xd0\xb8\xd1\x81\xd1\x82\xd1\x80\xd0\xb0\xd1\x86\xd0\xb8\xd1\x8f\x20\xd0\xbe\xd0\xb1\xd1\x80\xd0\xb0\xd1\x89\xd0\xb5\xd0\xbd\xd0\xb8\xd1\x8f"
        );
        addAction(
            ACT_NOTIFY_CLIENT_ID,
            "\xd0\xa3\xd0\xb2\xd0\xb5\xd0\xb4\xd0\xbe\xd0\xbc\xd0\xbb\xd0\xb5\xd0\xbd\xd0\xb8\xd0\xb5\x20\xd0\xba\xd0\xbb\xd0\xb8\xd0\xb5\xd0\xbd\xd1\x82\xd0\xb0\x20\xd0\xbe\x20\xd1\x80\xd0\xb5\xd1\x88\xd0\xb5\xd0\xbd\xd0\xb8\xd0\xb8"
        );
        addAction(
            ACT_DEV_REQ_ID,
            "\xd0\x97\xd0\xb0\xd0\xbf\xd1\x80\xd0\xbe\xd1\x81\x20\xd0\xba\xd0\xbe\xd0\xbd\xd1\x81\xd1\x83\xd0\xbb\xd1\x8c\xd1\x82\xd0\xb0\xd1\x86\xd0\xb8\xd0\xb8\x20\xd1\x80\xd0\xb0\xd0\xb7\xd1\x80\xd0\xb0\xd0\xb1\xd0\xbe\xd1\x82\xd1\x87\xd0\xb8\xd0\xba\xd0\xb0"
        );
        addAction(
            ACT_DEV_RESP_ID,
            "\xd0\x9e\xd1\x82\xd0\xb2\xd0\xb5\xd1\x82\x20\xd1\x80\xd0\xb0\xd0\xb7\xd1\x80\xd0\xb0\xd0\xb1\xd0\xbe\xd1\x82\xd1\x87\xd0\xb8\xd0\xba\xd0\xb0\x20\xd1\x81\xd0\xbf\xd0\xb5\xd1\x86\xd0\xb8\xd0\xb0\xd0\xbb\xd0\xb8\xd1\x81\xd1\x82\xd1\x83"
        );
        addAction(
            ACT_REPROCESS_ID,
            "\xd0\x9d\xd0\xb0\xd0\xbf\xd1\x80\xd0\xb0\xd0\xb2\xd0\xbb\xd0\xb5\xd0\xbd\xd0\xb8\xd0\xb5\x20\xd0\xbd\xd0\xb0\x20\xd0\xbf\xd0\xbe\xd0\xb2\xd1\x82\xd0\xbe\xd1\x80\xd0\xbd\xd1\x83\xd1\x8e\x20\xd0\xbe\xd0\xb1\xd1\x80\xd0\xb0\xd0\xb1\xd0\xbe\xd1\x82\xd0\xba\xd1\x83"
        );
        addAction(
            ACT_RESOLVE_ID,
            "\xd0\x97\xd0\xb0\xd0\xb2\xd0\xb5\xd1\x80\xd1\x88\xd0\xb5\xd0\xbd\xd0\xb8\xd0\xb5\x20\xd0\xb1\xd0\xb8\xd0\xb7\xd0\xbd\xd0\xb5\xd1\x81\x2d\xd0\xbf\xd1\x80\xd0\xbe\xd1\x86\xd0\xb5\xd1\x81\xd1\x81\xd0\xb0"
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
            "\xd0\xa1\xd0\xb1\xd0\xb5\xd1\x80\xd0\xb1\xd0\xb0\xd0\xbd\xd0\xba",  // Сбербанк
            "\xd0\x91\xd0\xb0\xd0\xbd\xd0\xba"  // Банк
        );
        // Иванов Сергей
        addEmpl(
            EMPL_CLIENT_ID,
            SBERBANK, 
            "\xd0\x98\xd0\xb2\xd0\xb0\xd0\xbd\xd0\xbe\xd0\xb2\x20\xd0\xa1\xd0\xb5\xd1\x80\xd0\xb3\xd0\xb5\xd0\xb9",
            "ivanov@sberbank.ru"
        );
        // Кутепов Артём
        addEmpl(
            EMPL_CLIENT_2_ID,
            SBERBANK, 
            "\xd0\x9a\xd1\x83\xd1\x82\xd0\xb5\xd0\xbf\xd0\xbe\xd0\xb2\x20\xd0\x90\xd1\x80\xd1\x82\xd1\x91\xd0\xbc",
            "kutepov@sberbank.ru"
        );

        /***** Организация, отвечающая за решение проблемы *****/
        addOrg(
            FINTECH, 
            "\xd0\xa4\xd0\xb8\xd0\xbd\xd0\xa2\xd0\xb5\xd1\x85",  // ФинТех
            "\xd0\xa0\xd0\xb0\xd0\xb7\xd1\x80\xd0\xb0\xd0\xb1\xd0\xbe\xd1\x82\xd0\xba\xd0\xb0\x20\xd0\xb1\xd0\xbb\xd0\xbe\xd0\xba\xd1\x87\xd0\xb5\xd0\xb9\xd0\xbd\xd0\xb0"  // Разработка блокчейна
        );
        // Петров Евгений
        addEmpl(
            EMPL_SPECIALIST_ID,
            FINTECH, 
            "\xd0\x9f\xd0\xb5\xd1\x82\xd1\x80\xd0\xbe\xd0\xb2\x20\xd0\x95\xd0\xb2\xd0\xb3\xd0\xb5\xd0\xbd\xd0\xb8\xd0\xb9",
            "petrov@fintech.ru"
        );
        // Васечкин Пётр
        addEmpl(
            EMPL_SPECIALIST_2_ID,
            FINTECH, 
            "\xd0\x92\xd0\xb0\xd1\x81\xd0\xb5\xd1\x87\xd0\xba\xd0\xb8\xd0\xbd\x20\xd0\x9f\xd1\x91\xd1\x82\xd1\x80",
            "vasechkin@fintech.ru"
        );

        // Быстров Павел
        addEmpl(
            EMPL_DEVELOPER_ID,
            FINTECH, 
            "\xd0\x91\xd1\x8b\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb2\x20\xd0\x9f\xd0\xb0\xd0\xb2\xd0\xb5\xd0\xbb",
            "bistrov@fintech.ru"
        );
        // Умнов Алексей
        addEmpl(
            EMPL_DEVELOPER_2_ID,
            FINTECH, 
            "\xd0\xa3\xd0\xbc\xd0\xbd\xd0\xbe\xd0\xb2\x20\xd0\x90\xd0\xbb\xd0\xb5\xd0\xba\xd1\x81\xd0\xb5\xd0\xb9",
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
        addOrg(FORS, "Fors", "Vendor");
        // Empl1
        addEmpl(
            EMPL_VENDOR_SPECIALIST_ID,
            FORS, 
            "Fors employee 1",
            "empl1@fors.ru"
        );
        // Empl2
        addEmpl(
            EMPL_VENDOR_DEVELOPER_ID,
            FORS, 
            "Fors employee 2",
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
