// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import "./Organizations.sol";
import "./BusinessProcesses.sol";
import "./EmployeesInBP.sol";

/**
 * @title Incident management
 * @author Lukyantsev Dmitry
 * @notice An incident is a workflow object of an arbitrary business process
 */
abstract contract IncidentManagment is Organizations, BusinessProcesses, EmployeesInBP {
    /// @dev Incident data
    struct Incident {
        uint keyIndex;       // Ключ в массиве инцидентов для их итерирования, начиная с заданного
        uint regDate;        // Дата регистрации инцидента
        uint bpId;           // Id бизнесс процесса
        uint reqOrgId;       // Id организации, создавшей инцидент
        uint reqEmplId;      // Id сотрудника в этой организации
        uint resOrgId;       // Id организации, отв. за решение инцидента
        uint resEmplId;      // Id сотрудника, отв. за решение инцидента
        uint resolveDate;    // Дата решения инцидента
    }
    /// @dev Type for incidents
    /// @dev For incident iterability type includes array wich stores incident ids
    /// @dev Mapping key is incident id
    struct Incidents {
        mapping(uint => Incident) data;
        uint[] keys;  // Хранит id инцидентов для их итерирования
    }
    /// @dev Incidents store confidential data
    Incidents private incidents;
    
    /// @dev Incident's history data
    struct IncidentHistory {
        uint historyId;   // Id записи в истории инцидента
        uint actionId;    // Id действия
        uint actionDate;  // Дата записи в историю
        uint reqEmplId;   // Id сотрудника - инициатора запроса
        uint resEmplId;   // Id сотрудника - получателя запроса
        bytes32 fileId;   // Hash файла с информацией по обращению
    }

    /// @dev Incident's history stores confidential data
    /// @dev Mapping incidentId => IncidentHistory
    mapping(uint => IncidentHistory[]) private incidentHistory;

    /// @notice Registrate new incident
    function regIncident(
        uint incidentId,
        uint regDate,
        uint bpId,
        uint regActionId,
        uint reqOrgId,
        uint reqEmplId,
        uint resOrgId,
        uint resEmplId,
        bytes32 fileId
    )
        public
        onlyOwner
        returns (
            uint historyId, 
            bool success
        )
    {
        // Проверим существование в справочниках
        validateBP(bpId);
        validateOrg(reqOrgId);
        validateOrg(resOrgId);
        validateEmployee(reqEmplId);
        validateEmployee(resEmplId);
        validateAction(regActionId);
        // Проверим наличие инцидента
        if (incidentExists(incidentId))
            revert(unicode"Инцидент уже существует");

        // Может ли сотрудник зарегистрировать инцидент?
        if (!checkEmplAction(bpId, reqEmplId, regActionId))
            revert(unicode"У сотрудника нет права создания инцидента");

        // Регистрация нового инцидента
        uint keyIndex;
        keyIndex = incidents.keys.length;
        incidents.keys.push(incidentId);
        // Заполнение начальных данных инцидента
        Incident storage incident = incidents.data[incidentId];
        incident.keyIndex = keyIndex + 1;
        incident.regDate = regDate;
        incident.bpId = bpId;
        incident.reqOrgId = reqOrgId;
        incident.reqEmplId = reqEmplId;
        incident.resOrgId = resOrgId;
        incident.resEmplId = resEmplId;  // Может быть нулевым

        // Добавление в историю действия регистрации инцидента
        ( historyId, success) = incidentHistoryInsert(
            incidentId,
            regActionId,
            regDate,
            reqEmplId,
            resEmplId,
            fileId);
    }
    
    /// @notice Insert new action in incident history
    /// @ dev For external purpose only, validates params
    function addIncidentHistory(
        uint incidentId,
        uint actionId,
        uint actionDate,
        uint reqEmplId,
        uint resEmplId,
        bytes32 fileId
    ) 
        public 
        returns (
            uint historyId,
            bool success
        )
    {
        validateEmployee(reqEmplId);
        validateEmployee(resEmplId);
        validateAction(actionId);
        if (!incidentExists(incidentId))
            revert(unicode"Инцидент не существует");
        // Получим инцидент
        Incident storage incident = incidents.data[incidentId];
        if (incident.resolveDate > 0)
            revert(unicode"Инцидент уже решён");
        // Может ли сотрудник выполнить данное действие?
        if (!checkEmplAction(incident.bpId, reqEmplId, actionId))
            revert(unicode"У сотрудника нет права выполнения действия");

        // Занесём новую запись в историю
        ( historyId, success) = incidentHistoryInsert(
            incidentId,
            actionId,
            actionDate,
            reqEmplId,
            resEmplId,
            fileId);
    }
    
    /// @notice Close incident with successful result
    /// @param reqEmplId - employee id who resolve incident
    /// @param resEmplId - employee id who can see this action (optional)
    function resolveIncident(
        uint incidentId,
        uint resolveActionId,
        uint resolveDate,
        uint reqEmplId,
        uint resEmplId,
        bytes32 fileId
    ) 
        public
        onlyOwner
        returns (
            uint historyId,
            bool success
        )
    {
        validateEmployee(reqEmplId);
        validateAction(resolveActionId);
        if (!incidentExists(incidentId))
            revert(unicode"Инцидент не существует");
        // Получим инцидент
        Incident storage incident = incidents.data[incidentId];
        if (incident.resolveDate > 0)
            revert(unicode"Инцидент уже завершён");
        // Может ли сотрудник завершить инцидент?
        if (!checkEmplAction(incident.bpId, reqEmplId, resolveActionId))
            revert(unicode"У сотрудника нет прав для завершения инцидента");
        // Занесём дату завершения
        incident.resolveDate = resolveDate;
        
        // Занесём в историю завершение инцидента
        // Если не указать в resEmplId сотрудника (проставить 0), то данную
        // запись в истории сможет посмотреть только создавший её
        ( historyId, success) = incidentHistoryInsert(
            incidentId,
            resolveActionId,
            resolveDate,
            reqEmplId,
            resEmplId,
            fileId);
    }

    /// @notice Retriving incident data by its id
    function getIncident(
        uint incidentId
    ) 
        external
        view
        returns (
            uint regDate,
            uint bpId,
            uint reqOrgId,
            uint reqEmplId,
            uint resOrgId,
            uint resEmplId,
            uint resolveDate,
            bool success
        ) 
    {
        // Проверим наличие инцидента
        if (!incidentExists(incidentId))
            return (0, 0, 0, 0, 0, 0, 0, false);

        Incident storage incident = incidents.data[incidentId];

        regDate = incident.regDate;
        bpId = incident.bpId;
        reqOrgId = incident.reqOrgId;
        reqEmplId = incident.reqEmplId;
        resOrgId = incident.resOrgId;
        resEmplId = incident.resEmplId;
        resolveDate = incident.resolveDate;
        success = true;
    }
    
    /// @notice Retriving incident history ids for iterating over array
    function getIncidentHistoryIds(uint incidentId) 
        external
        view
        returns (uint[] memory ids, bool success) 
    {
        // Проверим наличие инцидента
        if (!incidentExists(incidentId)) {
            return (new uint[](0), false);
        }

        // Получим историю инцидента
        IncidentHistory[] storage histArray = incidentHistory[incidentId];
        // Инициализируем массив результата
        uint[] memory historyIds = new uint[](histArray.length);
        // Заполним массив идентификаторами записей инцидента
        for (uint i = 0; i < histArray.length; i++)
            historyIds[i] = histArray[i].historyId;
        
        return (historyIds, true);
    }
    /// @notice Return incident's history length
    function getIncidentHistoryLength(uint incidentId) external view returns (uint)
    {
        // Проверим наличие инцидента
        if (incidentExists(incidentId)) {
            // Получим историю инцидента
            IncidentHistory[] storage histArray = incidentHistory[incidentId];
            return histArray.length;
        }
        else
            return 0;
    }

    /// @notice Retriving incident action from history 
    /// @param incidentHistoryId: Record id in incident history
    /// @param queryEmplId: Id of employee who query incident history
    function getIncidentAction(
        uint incidentId,
        uint incidentHistoryId,
        uint queryEmplId
    ) 
        external
        view
        returns (
            uint actionId,
            uint actionDate,
            uint reqEmplId,
            uint resEmplId,
            bytes32 fileId,
            bool success
        ) 
    {
        /* Правила доступа к записи истории решения конкретного обращения:
           1) сотрудник может прочитать любую запись в истории решения любого обращения, 
           сделанную любым сотрудником с той же ролью, в т.ч. и хеш файла, 
           хранящийся в записи истории;
           2) если сотруднику назначено на выполнение действие, то запись в истории
           по данному действию может прочитать любой сотрудник с той же ролью. 
           Другими словами, у запрашивающего файл сотрудника д.б. роль отправителя
           или получателя сообщения.
           Пример: разработчики видят файлы в обращениях к ним и свои ответы.
        */
        // Проверим наличие инцидента
        if (!incidentExists(incidentId))
            return (0, 0, 0, 0, 0, false);
        // Получим историю инцидента
        IncidentHistory[] storage histArray = incidentHistory[incidentId];
        // Найдем нужную запись в истории
        IncidentHistory memory hist;
        for (uint i = 0; i < histArray.length; i++) {
            if (histArray[i].historyId == incidentHistoryId) {
                hist = histArray[i];
                break;
            }
        }
         // Получим id БП из инцидента
        uint bpId = incidents.data[incidentId].bpId;
        // Проверим роль сотрудника - инциатора запроса
        // Проверим роль сотрудника - получателя запроса
        if (emplRoles[bpId][hist.reqEmplId] == emplRoles[bpId][queryEmplId] ||
            emplRoles[bpId][hist.resEmplId] == emplRoles[bpId][queryEmplId]
        ) {
            return (
                hist.actionId,
                hist.actionDate,
                hist.reqEmplId,
                hist.resEmplId,
                hist.fileId,
                true
            );
        }
    }  // getIncidentAction

    /// @notice Insert new action in incident history
    /// @ dev For internal purpose only, does not validate params
    function incidentHistoryInsert(
        uint incidentId,
        uint actionId,
        uint actionDate,
        uint reqEmplId,
        uint resEmplId,
        bytes32 fileId
    ) 
        internal 
        returns (
            uint historyId,
            bool success
        ) 
    {
        // Добавление в историю действия регистрации инцидента
        IncidentHistory storage hist = incidentHistory[incidentId].push();
        hist.historyId = incidentHistory[incidentId].length;
        hist.actionId = actionId;
        hist.actionDate = actionDate;
        hist.reqEmplId = reqEmplId;
        hist.resEmplId = resEmplId;
        hist.fileId = fileId;
        return (hist.historyId, true);
    }

    /// @notice return true if incident exists
    function incidentExists(uint incidentId) internal view returns (bool) {
        if (incidents.data[incidentId].keyIndex == 0)
            return false;
        else
            return true;
    }
}
